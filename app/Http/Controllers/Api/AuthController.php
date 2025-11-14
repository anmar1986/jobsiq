<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Password as PasswordFacade;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new user.
     */
    public function register(Request $request): JsonResponse
    {
        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'confirmed', Password::defaults()],
            'user_type' => ['required', 'in:job_seeker,company_owner'],
            // Company fields (only required if user_type is company_owner)
            'company_name' => ['required_if:user_type,company_owner', 'string', 'max:255'],
            'company_email' => ['required_if:user_type,company_owner', 'email', 'max:255'],
        ]);

        try {
            DB::beginTransaction();

            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'user_type' => $request->user_type,
            ]);

            // If registering as company owner, create the company
            if ($request->user_type === 'company_owner' && $request->has('company_name')) {
                $company = \App\Models\Company::create([
                    'name' => $request->company_name,
                    'email' => $request->company_email ?? $request->email,
                    'is_active' => true,
                ]);

                Log::info('Company created during registration', [
                    'company_id' => $company->id,
                    'company_name' => $company->name,
                    'user_id' => $user->id,
                ]);

                // Attach user as primary owner
                $company->owners()->attach($user->id, ['is_primary' => true]);

                Log::info('User attached as company owner', [
                    'user_id' => $user->id,
                    'company_id' => $company->id,
                ]);
            }

            DB::commit();

            // Create token
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'User registered successfully',
                'data' => [
                    'user' => $user,
                    'token' => $token,
                    'token_type' => 'Bearer',
                ],
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Registration failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Registration failed. Please try again.',
            ], 500);
        }
    }

    /**
     * Login user and create token.
     */
    public function login(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        // Revoke all previous tokens (optional - comment out if you want multiple sessions)
        $user->tokens()->delete();

        // Create new token
        $token = $user->createToken('auth_token')->plainTextToken;

        // Determine redirect path based on user role
        $redirectTo = $user->is_admin ? '/admin' : '/dashboard';

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'data' => [
                'user' => $user,
                'token' => $token,
                'token_type' => 'Bearer',
                'redirect_to' => $redirectTo,
            ],
        ]);
    }

    /**
     * Logout user (Revoke token).
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ]);
    }

    /**
     * Logout from all devices (Revoke all tokens).
     */
    public function logoutAll(Request $request): JsonResponse
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out from all devices successfully',
        ]);
    }

    /**
     * Get the authenticated user.
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $request->user(),
        ]);
    }

    /**
     * Update user profile.
     */
    public function updateProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        try {
            $validated = $request->validate([
                'name' => ['required', 'string', 'max:255'],
                'email' => ['sometimes', 'string', 'email', 'max:255', 'unique:users,email,'.$user->id],
                'profile_photo' => ['nullable', 'image', 'mimes:jpeg,jpg,png,gif', 'max:2048'], // 2MB max
                'headline' => ['nullable', 'string', 'max:255'],
                'gender' => ['nullable', 'in:male,female,other,'],
                'date_of_birth' => ['nullable', 'date', 'before:today'],
                'nationality' => ['nullable', 'string', 'max:100'],
                'city' => ['nullable', 'string', 'max:100'],
                'country' => ['nullable', 'string', 'max:100'],
                'address' => ['nullable', 'string', 'max:500'],
                'phone_number' => ['nullable', 'string', 'max:20'],
                'linkedin_url' => ['nullable', 'url', 'max:255'],
            ]);

            // Convert empty strings to null for nullable fields
            foreach (['headline', 'gender', 'date_of_birth', 'nationality', 'city', 'country', 'address', 'phone_number', 'linkedin_url'] as $field) {
                if (isset($validated[$field]) && $validated[$field] === '') {
                    $validated[$field] = null;
                }
            }

            // Handle profile photo upload
            if ($request->hasFile('profile_photo')) {
                $file = $request->file('profile_photo');

                if ($file->isValid()) {
                    // Delete old profile photo if exists
                    if ($user->profile_photo) {
                        Storage::disk('public')->delete($user->profile_photo);
                    }

                    $path = $file->store('profile-photos', 'public');
                    $validated['profile_photo'] = $path;
                } else {
                    return response()->json([
                        'success' => false,
                        'message' => 'Invalid file upload',
                        'errors' => ['profile_photo' => ['The uploaded file is not valid']],
                    ], 422);
                }
            }

            // Remove profile_photo from validated if it wasn't set
            if (! isset($validated['profile_photo'])) {
                unset($validated['profile_photo']);
            }

            // Log the update for debugging
            Log::info('Updating user profile', [
                'user_id' => $user->id,
                'fields' => array_keys($validated),
                'date_of_birth' => $validated['date_of_birth'] ?? 'not set',
            ]);

            $user->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Profile updated successfully',
                'data' => $user->fresh(),
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('Profile update failed', [
                'error' => $e->getMessage(),
                'user_id' => $user->id,
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to update profile: '.$e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete user profile.
     */
    public function deleteProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        try {
            DB::beginTransaction();

            // Delete the user (this will trigger the deleting event in User model
            // which handles all cleanup: profile photo, companies, CVs, tokens, etc.)
            $user->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Profile deleted successfully',
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Profile deletion failed', [
                'error' => $e->getMessage(),
                'user_id' => $user->id,
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to delete profile. Please try again.',
            ], 500);
        }
    }

    /**
     * Change user password.
     */
    public function changePassword(Request $request): JsonResponse
    {
        $request->validate([
            'current_password' => ['required', 'current_password'],
            'password' => ['required', 'confirmed', Password::defaults()],
        ]);

        $user = $request->user();
        $user->update([
            'password' => Hash::make($request->password),
        ]);

        // Optionally revoke all tokens after password change
        $user->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Password changed successfully. Please login again.',
        ]);
    }

    /**
     * Send password reset link to user's email.
     */
    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate([
            'email' => ['required', 'email'],
        ]);

        $status = PasswordFacade::sendResetLink(
            $request->only('email')
        );

        if ($status === PasswordFacade::RESET_LINK_SENT) {
            return response()->json([
                'success' => true,
                'message' => 'Password reset link sent to your email.',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => __($status),
        ], 400);
    }

    /**
     * Reset user password with token.
     */
    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'token' => ['required'],
            'email' => ['required', 'email'],
            'password' => ['required', 'confirmed', Password::defaults()],
        ]);

        $status = PasswordFacade::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($user, $password) {
                $user->forceFill([
                    'password' => Hash::make($password),
                ])->save();

                // Revoke all tokens after password reset
                $user->tokens()->delete();
            }
        );

        if ($status === PasswordFacade::PASSWORD_RESET) {
            return response()->json([
                'success' => true,
                'message' => 'Password reset successfully. Please login with your new password.',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => __($status),
        ], 400);
    }
}
