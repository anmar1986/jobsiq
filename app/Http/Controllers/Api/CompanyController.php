<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreCompanyRequest;
use App\Http\Requests\UpdateCompanyRequest;
use App\Models\Company;
use App\Models\CompanyImage;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
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
        $validated = $request->validated();

        // Create company
        $company = Company::create($validated);

        // Attach user as primary owner
        $company->owners()->attach($request->user()->id, [
            'is_primary' => true,
        ]);

        // Handle logo upload
        if ($request->hasFile('logo')) {
            $this->uploadLogo($company, $request->file('logo'));
        }

        $company->load(['logo', 'owners']);

        return response()->json([
            'success' => true,
            'data' => $company,
            'message' => 'Company created successfully',
        ], 201);
    }

    /**
     * Display the specified company.
     */
    public function show(Company $company): JsonResponse
    {
        $company->load(['logo', 'images', 'jobs' => function ($query) {
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

        $company->load(['logo', 'owners']);

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
        // Check if user is primary owner
        if (! $company->isPrimaryOwner($request->user())) {
            return response()->json([
                'success' => false,
                'message' => 'Only the primary owner can delete the company',
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
            ->with(['logo', 'jobs'])
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
        $path = $file->store('companies/logos', 'public');

        return $company->images()->create([
            'path' => $path,
            'type' => 'logo',
            'is_primary' => true,
        ]);
    }
}
