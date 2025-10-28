<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCompanyRequest;
use App\Http\Requests\UpdateCompanyRequest;
use App\Models\Company;
use App\Models\CompanyImage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class CompanyController extends Controller
{
    /**
     * Display a listing of companies.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Company::with(['logo', 'jobs'])
            ->where('is_active', true)
            ->withCount('jobs');

        // Search by name
        if ($request->has('search')) {
            $query->where('name', 'like', "%{$request->search}%");
        }

        // Filter by city
        if ($request->has('city')) {
            $query->where('city', $request->city);
        }

        // Filter by country
        if ($request->has('country')) {
            $query->where('country', $request->country);
        }

        // Random order for variety
        $query->inRandomOrder();

        $companies = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $companies,
        ]);
    }

    /**
     * Store a newly created company.
     */
    public function store(StoreCompanyRequest $request): JsonResponse
    {
        try {
            Log::info('Company creation started', [
                'user_id' => $request->user()->id,
                'has_logo' => $request->hasFile('logo'),
                'all_data' => $request->except(['logo']),
            ]);

            $validated = $request->validated();

            Log::info('Validation passed', ['validated_keys' => array_keys($validated)]);

            // Ensure is_active is set to true for new companies
            $validated['is_active'] = true;

            // Create company
            $company = Company::create($validated);

            Log::info('Company created', ['company_id' => $company->id]);

            // Attach user as primary owner
            $company->owners()->attach($request->user()->id, [
                'is_primary' => true,
            ]);

            Log::info('Owner attached');

            // Handle logo upload
            if ($request->hasFile('logo')) {
                Log::info('Processing logo upload');
                $this->uploadLogo($company, $request->file('logo'));
                Log::info('Logo uploaded successfully');
            }

            // Handle cover image upload
            if ($request->hasFile('cover')) {
                Log::info('Processing cover image upload');
                $this->uploadCover($company, $request->file('cover'));
                Log::info('Cover image uploaded successfully');
            }

            // Handle company images upload
            if ($request->hasFile('images')) {
                Log::info('Processing company images upload');
                $files = $request->file('images');
                if (is_array($files)) {
                    foreach ($files as $file) {
                        $this->uploadCompanyImage($company, $file);
                    }
                    Log::info('Company images uploaded successfully', ['count' => count($files)]);
                }
            }

            $company->load(['logo', 'cover', 'images', 'owners']);

            Log::info('Company creation completed successfully');

            return response()->json([
                'success' => true,
                'data' => $company,
                'message' => 'Company created successfully',
            ], 201);
        } catch (\Exception $e) {
            Log::error('Company creation failed: '.$e->getMessage(), [
                'trace' => $e->getTraceAsString(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to create company: '.$e->getMessage(),
            ], 500);
        }
    }

    /**
     * Display the specified company by slug (public).
     */
    public function showBySlug(string $slug): JsonResponse
    {
        $company = Company::where('slug', $slug)
            ->where('is_active', true)
            ->with(['logo', 'cover', 'images', 'jobs' => function ($query) {
                $query->active()->published()->latest('published_at');
            }])
            ->firstOrFail();

        return response()->json([
            'success' => true,
            'data' => $company,
        ]);
    }

    /**
     * Display the specified company by ID (authenticated).
     */
    public function show(Company $company): JsonResponse
    {
        $company->load(['logo', 'cover', 'images', 'jobs' => function ($query) {
            $query->active()->published()->latest('published_at');
        }, 'owners']);

        return response()->json([
            'success' => true,
            'data' => $company,
        ]);
    }

    /**
     * Update the specified company.
     */
    public function update(UpdateCompanyRequest $request, Company $company): JsonResponse
    {
        // Check if user owns this company
        if (! $request->user()->ownsCompany($company)) {
            return response()->json([
                'success' => false,
                'message' => 'You do not have permission to edit this company.',
            ], 403);
        }

        $company->update($request->validated());

        // Handle logo upload
        if ($request->hasFile('logo')) {
            // Delete old logo
            if ($company->logo) {
                Storage::delete($company->logo->path);
                $company->logo->delete();
            }

            $this->uploadLogo($company, $request->file('logo'));
        }

        // Handle cover upload
        if ($request->hasFile('cover')) {
            // Delete old cover
            $oldCover = $company->images()->where('type', 'cover')->first();
            if ($oldCover) {
                Storage::delete($oldCover->path);
                $oldCover->delete();
            }

            $this->uploadCover($company, $request->file('cover'));
        }

        // Handle company images upload
        if ($request->hasFile('images')) {
            $files = $request->file('images');
            if (is_array($files)) {
                foreach ($files as $file) {
                    $this->uploadCompanyImage($company, $file);
                }
            }
        }

        $company->load(['logo', 'cover', 'images', 'owners']);

        return response()->json([
            'success' => true,
            'data' => $company,
            'message' => 'Company updated successfully',
        ]);
    }

    /**
     * Remove the specified company.
     */
    public function destroy(Request $request, Company $company): JsonResponse
    {
        // Check if user is an owner of the company
        if (! $company->isOwnedBy($request->user())) {
            return response()->json([
                'success' => false,
                'message' => 'You do not have permission to delete this company',
            ], 403);
        }

        // Delete all images
        foreach ($company->images as $image) {
            Storage::delete($image->path);
        }

        $company->delete();

        return response()->json([
            'success' => true,
            'message' => 'Company deleted successfully',
        ]);
    }

    /**
     * Add an owner to the company.
     */
    public function addOwner(Request $request, Company $company): JsonResponse
    {
        // Check if user is owner
        if (! $request->user()->ownsCompany($company)) {
            return response()->json([
                'success' => false,
                'message' => 'Only company owners can add new owners',
            ], 403);
        }

        $request->validate([
            'user_id' => ['required', 'exists:users,id'],
        ]);

        // Check if user is already an owner
        if ($company->isOwnedBy(\App\Models\User::find($request->user_id))) {
            return response()->json([
                'success' => false,
                'message' => 'User is already an owner',
            ], 400);
        }

        $company->owners()->attach($request->user_id, [
            'is_primary' => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Owner added successfully',
        ]);
    }

    /**
     * Remove an owner from the company.
     */
    public function removeOwner(Request $request, Company $company, int $userId): JsonResponse
    {
        // Check if user is primary owner
        if (! $company->isPrimaryOwner($request->user())) {
            return response()->json([
                'success' => false,
                'message' => 'Only the primary owner can remove owners',
            ], 403);
        }

        // Cannot remove primary owner
        $ownerToRemove = \App\Models\User::findOrFail($userId);
        if ($company->isPrimaryOwner($ownerToRemove)) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot remove the primary owner',
            ], 400);
        }

        $company->owners()->detach($userId);

        return response()->json([
            'success' => true,
            'message' => 'Owner removed successfully',
        ]);
    }

    /**
     * Get companies owned by the authenticated user.
     */
    public function myCompanies(Request $request): JsonResponse
    {
        $companies = $request->user()
            ->ownedCompanies()
            ->with(['logo', 'cover', 'images', 'jobs'])
            ->withCount('jobs')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $companies,
        ]);
    }

    /**
     * Upload company logo.
     */
    protected function uploadLogo(Company $company, $file): CompanyImage
    {
        try {
            // Store the file
            $path = $file->store('companies/logos', 'public');

            if (! $path) {
                throw new \Exception('Failed to store logo file');
            }

            // Create the image record
            return $company->images()->create([
                'path' => $path,
                'type' => 'logo',
                'is_primary' => true,
            ]);
        } catch (\Exception $e) {
            Log::error('Logo upload failed: '.$e->getMessage());
            throw $e;
        }
    }

    /**
     * Upload company cover image.
     */
    protected function uploadCover(Company $company, $file): CompanyImage
    {
        try {
            // Store the file
            $path = $file->store('companies/covers', 'public');

            if (! $path) {
                throw new \Exception('Failed to store cover file');
            }

            // Create the image record
            return $company->images()->create([
                'path' => $path,
                'type' => 'cover',
                'is_primary' => true,
            ]);
        } catch (\Exception $e) {
            Log::error('Cover upload failed: '.$e->getMessage());
            throw $e;
        }
    }

    /**
     * Upload company image (gallery).
     */
    protected function uploadCompanyImage(Company $company, $file): CompanyImage
    {
        try {
            // Store the file
            $path = $file->store('companies/images', 'public');

            if (! $path) {
                throw new \Exception('Failed to store company image file');
            }

            // Create the image record
            return $company->images()->create([
                'path' => $path,
                'type' => 'gallery',
                'is_primary' => false,
            ]);
        } catch (\Exception $e) {
            Log::error('Company image upload failed: '.$e->getMessage());
            throw $e;
        }
    }
}
