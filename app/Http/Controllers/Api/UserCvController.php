<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCvRequest;
use App\Http\Requests\UpdateCvRequest;
use App\Models\UserCv;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class UserCvController extends Controller
{
    /**
     * Get all public CVs (paginated)
     */
    public function index(Request $request)
    {
        $query = UserCv::with('user')
            ->where('is_public', true);

        // Search filter
        if ($request->has('search') && $request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('full_name', 'like', "%{$search}%")
                    ->orWhere('title', 'like', "%{$search}%")
                    ->orWhere('summary', 'like', "%{$search}%");
            });
        }

        // Skills filter
        if ($request->has('skills') && $request->skills) {
            $query->whereJsonContains('skills', $request->skills);
        }

        // Location filter
        if ($request->has('location') && $request->location) {
            $query->where(function ($q) use ($request) {
                $q->where('city', 'like', "%{$request->location}%")
                    ->orWhere('country', 'like', "%{$request->location}%");
            });
        }

        $perPage = $request->get('per_page', 15);
        $cvs = $query->latest('updated_at')->paginate($perPage);

        // Map field names for frontend compatibility
        $cvs->getCollection()->transform(function ($cv) {
            $cvData = $cv->toArray();

            // Map work_experience to work_experiences for frontend
            if (isset($cvData['work_experience'])) {
                $cvData['work_experiences'] = $cvData['work_experience'];
            }

            // Map education to education_entries for frontend
            if (isset($cvData['education'])) {
                $cvData['education_entries'] = $cvData['education'];
            }

            return $cvData;
        });

        return response()->json([
            'success' => true,
            'data' => $cvs,
        ]);
    }

    /**
     * Get authenticated user's CVs
     */
    public function myCvs()
    {
        $cvs = UserCv::where('user_id', Auth::id())
            ->latest('updated_at')
            ->get()
            ->map(function ($cv) {
                $cvData = $cv->toArray();

                // Map work_experience to work_experiences for frontend
                if (isset($cvData['work_experience'])) {
                    $cvData['work_experiences'] = $cvData['work_experience'];
                }

                // Map education to education_entries for frontend
                if (isset($cvData['education'])) {
                    $cvData['education_entries'] = $cvData['education'];
                }

                return $cvData;
            });

        return response()->json([
            'success' => true,
            'data' => $cvs,
        ]);
    }

    /**
     * Get a single CV by ID or slug
     */
    public function show($id)
    {
        $cv = UserCv::with('user')
            ->where(function ($query) use ($id) {
                $query->where('id', $id)
                    ->orWhere('slug', $id);
            })
            ->firstOrFail();

        // Only show if public or owned by user
        if (! $cv->is_public && $cv->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'This CV is private.',
            ], 403);
        }

        // Ensure frontend compatibility by mapping database fields to expected names
        $cvData = $cv->toArray();

        // Map work_experience to work_experiences for frontend
        if (isset($cvData['work_experience'])) {
            $cvData['work_experiences'] = $cvData['work_experience'];
        }

        // Map education to education_entries for frontend
        if (isset($cvData['education'])) {
            $cvData['education_entries'] = $cvData['education'];
        }

        return response()->json([
            'success' => true,
            'data' => $cvData,
        ]);
    }

    /**
     * Create a new CV
     */
    public function store(StoreCvRequest $request)
    {
        try {
            $user = Auth::user();

            // Check if user has reached the maximum number of CVs (6)
            $cvCount = UserCv::where('user_id', $user->id)->count();

            if ($cvCount >= 6) {
                return response()->json([
                    'success' => false,
                    'message' => 'You have reached the maximum number of CVs (6). Please delete an existing CV before creating a new one.',
                ], 403);
            }

            $data = $request->validated();

            // Log validated data to debug
            Log::info('CV Store - Validated Data', [
                'has_skills' => isset($data['skills']),
                'skills' => $data['skills'] ?? 'not set',
                'skills_type' => isset($data['skills']) ? gettype($data['skills']) : 'N/A',
                'skills_count' => isset($data['skills']) ? count($data['skills']) : 0,
                'work_experience' => $data['work_experience'] ?? 'not set',
                'work_experience_type' => gettype($data['work_experience'] ?? null),
                'work_experience_count' => isset($data['work_experience']) ? count($data['work_experience']) : 0,
                'education' => $data['education'] ?? 'not set',
                'education_count' => isset($data['education']) ? count($data['education']) : 0,
                'certifications' => $data['certifications'] ?? 'not set',
                'certifications_count' => isset($data['certifications']) ? count($data['certifications']) : 0,
                'languages' => $data['languages'] ?? 'not set',
                'languages_count' => isset($data['languages']) ? count($data['languages']) : 0,
                'all_data_keys' => array_keys($data),
            ]);

            $data['user_id'] = Auth::id();

            // If no full_name provided, use user's name
            if (empty($data['full_name'])) {
                $data['full_name'] = $user->name;
            }

            // If no email provided, use user's email
            if (empty($data['email'])) {
                $data['email'] = $user->email;
            }

            // If is_primary is true, unset other primary CVs
            if ($data['is_primary'] ?? false) {
                UserCv::where('user_id', Auth::id())->update(['is_primary' => false]);
            }

            // The work_experience, education, certifications, and languages are already in $data
            // They will be automatically cast to JSON by the model
            // No need to extract or remove them

            $cv = UserCv::create($data);

            // Refresh to ensure we have the slug generated by boot method
            $cv->refresh();

            // Log for debugging
            Log::info('CV Created', [
                'id' => $cv->id,
                'slug' => $cv->slug,
                'title' => $cv->title,
                'full_name' => $cv->full_name,
                'work_experience_count' => count($cv->work_experience ?? []),
                'education_count' => count($cv->education ?? []),
                'certifications_count' => count($cv->certifications ?? []),
                'languages_count' => count($cv->languages ?? []),
                'skills_count' => count($cv->skills ?? []),
            ]);

            // Handle profile image upload
            if ($request->hasFile('profile_image')) {
                Log::info('Profile image detected', [
                    'has_file' => true,
                    'is_valid' => $request->file('profile_image')->isValid(),
                    'original_name' => $request->file('profile_image')->getClientOriginalName(),
                    'size' => $request->file('profile_image')->getSize(),
                    'mime_type' => $request->file('profile_image')->getMimeType(),
                ]);

                $path = $request->file('profile_image')->store('cvs/profiles', 'public');

                Log::info('Profile image stored', [
                    'path' => $path,
                ]);

                // Save the image path directly to the CV record
                $cv->update(['profile_image_path' => $path]);

                Log::info('Profile image path saved to CV', [
                    'cv_id' => $cv->id,
                    'path' => $path,
                ]);
            } else {
                Log::info('No profile image in request', [
                    'has_file' => $request->hasFile('profile_image'),
                    'all_files' => $request->allFiles(),
                    'FILES_debug' => isset($_FILES['profile_image']) ? [
                        'error' => $_FILES['profile_image']['error'] ?? 'no error key',
                        'name' => $_FILES['profile_image']['name'] ?? 'no name',
                    ] : 'no $_FILES entry',
                ]);
            }

            return response()->json([
                'success' => true,
                'data' => $cv->load('user'),
                'message' => 'CV created successfully',
            ], 201);
        } catch (\Exception $e) {
            Log::error('CV Creation Failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'request_data' => $request->except(['profile_image']),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to create CV: '.$e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update CV
     */
    public function update(UpdateCvRequest $request, $id)
    {
        $cv = UserCv::findOrFail($id);

        // Check ownership
        if ($cv->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized.',
            ], 403);
        }

        $data = $request->validated();

        // Add detailed debugging
        Log::info('CV Update Debug', [
            'cv_id' => $cv->id,
            'before_update' => $cv->toArray(),
            'validated_data' => $data,
            'validated_data_keys' => array_keys($data),
            'work_experience_in_validated' => isset($data['work_experience']),
            'work_experience_value' => $data['work_experience'] ?? 'not set',
            'work_experience_count' => isset($data['work_experience']) ? count($data['work_experience']) : 0,
            'education_in_validated' => isset($data['education']),
            'education_count' => isset($data['education']) ? count($data['education']) : 0,
            'certifications_in_validated' => isset($data['certifications']),
            'certifications_count' => isset($data['certifications']) ? count($data['certifications']) : 0,
            'languages_in_validated' => isset($data['languages']),
            'languages_count' => isset($data['languages']) ? count($data['languages']) : 0,
            'request_all' => $request->all(),
        ]);

        // If is_primary is true, unset other primary CVs
        if (($data['is_primary'] ?? false) && ! $cv->is_primary) {
            UserCv::where('user_id', Auth::id())
                ->where('id', '!=', $cv->id)
                ->update(['is_primary' => false]);
        }

        // Handle profile image upload
        if ($request->hasFile('profile_image')) {
            Log::info('Update: Profile image detected', [
                'has_file' => true,
                'is_valid' => $request->file('profile_image')->isValid(),
                'original_name' => $request->file('profile_image')->getClientOriginalName(),
                'size' => $request->file('profile_image')->getSize(),
            ]);

            // Delete old profile image if exists
            if ($cv->profile_image_path) {
                Storage::disk('public')->delete($cv->profile_image_path);
            }

            $path = $request->file('profile_image')->store('cvs/profiles', 'public');
            $data['profile_image_path'] = $path;

            Log::info('Update: Profile image stored', ['path' => $path]);
        }

        // Update the CV with all data (including JSON fields)
        $cv->update($data);

        // Add debugging after update
        Log::info('CV Update After', [
            'cv_id' => $cv->id,
            'after_update' => $cv->fresh()->toArray(),
        ]);

        return response()->json([
            'success' => true,
            'data' => $cv->fresh(),
            'message' => 'CV updated successfully',
        ]);
    }

    /**
     * Delete CV
     */
    public function destroy($id)
    {
        $cv = UserCv::findOrFail($id);

        // Check ownership
        if ($cv->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized.',
            ], 403);
        }

        // Delete profile image if exists
        if ($cv->profile_image_path) {
            Storage::disk('public')->delete($cv->profile_image_path);
        }

        $cv->delete();

        return response()->json([
            'success' => true,
            'message' => 'CV deleted successfully.',
        ]);
    }

    /**
     * Set CV as primary.
     */
    public function setPrimary($id)
    {
        $cv = UserCv::findOrFail($id);

        // Check authorization
        if ($cv->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Unset all other primary CVs
        UserCv::where('user_id', Auth::id())
            ->where('id', '!=', $cv->id)
            ->update(['is_primary' => false]);

        $cv->update(['is_primary' => true]);

        return response()->json([
            'success' => true,
            'message' => 'CV set as primary successfully',
            'data' => $cv,
        ]);
    }
}
