<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Company;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class CompanyAdminController extends Controller
{
    /**
     * Display a listing of companies with pagination and filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Company::with(['owners', 'jobs', 'images']);

        // Search filter
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('industry', 'like', "%{$search}%");
            });
        }

        // Industry filter
        if ($request->has('industry')) {
            $query->where('industry', $request->industry);
        }

        // Company size filter
        if ($request->has('company_size')) {
            $query->where('company_size', $request->company_size);
        }

        // Country filter
        if ($request->has('country')) {
            $query->where('country', $request->country);
        }

        // Sorting
        $sortField = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortField, $sortOrder);

        $perPage = $request->get('per_page', 15);
        $companies = $query->paginate($perPage);

        return response()->json($companies);
    }

    /**
     * Store a newly created company.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255|unique:companies',
            'description' => 'required|string',
            'industry' => 'required|string|max:255',
            'company_size' => 'required|string|max:50',
            'founded_year' => 'nullable|integer|min:1800|max:'.date('Y'),
            'website' => 'nullable|url|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'nullable|string|max:20',
            'address' => 'required|string',
            'city' => 'required|string|max:255',
            'country' => 'required|string|max:255',
            'linkedin_url' => 'nullable|url|max:255',
            'twitter_url' => 'nullable|url|max:255',
            'facebook_url' => 'nullable|url|max:255',
            'culture_values' => 'nullable|array',
            'benefits' => 'nullable|array',
            'owner_id' => 'required|exists:users,id',
        ]);

        // Generate slug if not provided
        if (empty($validated['slug'])) {
            $validated['slug'] = Str::slug($validated['name']);

            // Ensure unique slug
            $originalSlug = $validated['slug'];
            $counter = 1;
            while (Company::where('slug', $validated['slug'])->exists()) {
                $validated['slug'] = $originalSlug.'-'.$counter++;
            }
        }

        $company = Company::create($validated);

        // Attach owner
        $company->owners()->attach($validated['owner_id'], ['is_primary' => true]);

        $company->load(['owners', 'images']);

        return response()->json([
            'message' => 'Company created successfully',
            'company' => $company,
        ], 201);
    }

    /**
     * Display the specified company.
     */
    public function show(Company $company): JsonResponse
    {
        $company->load(['owners', 'jobs', 'images']);

        return response()->json($company);
    }

    /**
     * Update the specified company.
     */
    public function update(Request $request, Company $company): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|max:255|unique:companies,slug,'.$company->id,
            'description' => 'sometimes|string',
            'industry' => 'sometimes|string|max:255',
            'company_size' => 'sometimes|string|max:50',
            'founded_year' => 'nullable|integer|min:1800|max:'.date('Y'),
            'website' => 'nullable|url|max:255',
            'email' => 'sometimes|email|max:255',
            'phone' => 'nullable|string|max:20',
            'address' => 'sometimes|string',
            'city' => 'sometimes|string|max:255',
            'country' => 'sometimes|string|max:255',
            'linkedin_url' => 'nullable|url|max:255',
            'twitter_url' => 'nullable|url|max:255',
            'facebook_url' => 'nullable|url|max:255',
            'culture_values' => 'nullable|array',
            'benefits' => 'nullable|array',
        ]);

        $company->update($validated);

        return response()->json([
            'message' => 'Company updated successfully',
            'company' => $company,
        ]);
    }

    /**
     * Remove the specified company.
     */
    public function destroy(Company $company): JsonResponse
    {
        // Delete company images from storage
        foreach ($company->images as $image) {
            if ($image->path) {
                Storage::disk('public')->delete($image->path);
            }
        }

        $company->delete();

        return response()->json([
            'message' => 'Company deleted successfully',
        ]);
    }

    /**
     * Get statistics about companies.
     */
    public function statistics(): JsonResponse
    {
        $stats = [
            'total_companies' => Company::count(),
            'companies_with_jobs' => Company::has('jobs')->count(),
            'recent_companies' => Company::where('created_at', '>=', now()->subDays(30))->count(),
            'top_industries' => Company::select('industry')
                ->selectRaw('count(*) as count')
                ->groupBy('industry')
                ->orderByDesc('count')
                ->limit(10)
                ->get(),
        ];

        return response()->json($stats);
    }
}
