<?php

namespace App\Http\Controllers\Api\Examples;

use App\Http\Controllers\Controller;
use App\Http\Traits\CachesApiResponses;
use App\Models\Job;
use App\Models\Company;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

/**
 * Example Controller demonstrating Redis caching implementation
 * 
 * This is a reference implementation showing how to use caching
 * in your controllers for better performance.
 */
class CachedJobController extends Controller
{
    use CachesApiResponses;

    /**
     * Get jobs list with caching
     * 
     * Cache Strategy:
     * - Cache key includes all query parameters
     * - TTL: 5 minutes (300 seconds)
     * - Auto-invalidated when jobs are created/updated
     */
    public function index(Request $request): JsonResponse
    {
        // Generate unique cache key based on request parameters
        $cacheKey = $this->getCacheKey('jobs_list', $request->all());
        
        // Cache the response for 5 minutes
        $jobs = $this->cacheResponse($cacheKey, function() use ($request) {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->where('is_active', true)
                ->when($request->filled('search'), function($q) use ($request) {
                    $q->where('title', 'like', "%{$request->search}%");
                })
                ->when($request->filled('location'), function($q) use ($request) {
                    $q->where('location', $request->location);
                })
                ->latest('published_at')
                ->paginate(20);
        }, 300);

        return response()->json([
            'success' => true,
            'data' => $jobs,
            'cached' => Cache::has($cacheKey), // Indicates if response was cached
        ]);
    }

    /**
     * Get single job with caching
     * 
     * Cache Strategy:
     * - Cache by job slug
     * - TTL: 10 minutes (600 seconds)
     * - Cleared when job is updated
     */
    public function show(string $slug): JsonResponse
    {
        $cacheKey = "job_detail_{$slug}";
        
        $job = $this->cacheResponse($cacheKey, function() use ($slug) {
            return Job::with([
                'company' => function($query) {
                    $query->select('id', 'name', 'slug', 'about', 'website', 'city', 'country');
                },
                'company.logo',
                'company.cover'
            ])
            ->where('slug', $slug)
            ->where('is_active', true)
            ->firstOrFail();
        }, 600);

        return response()->json([
            'success' => true,
            'data' => $job,
        ]);
    }

    /**
     * Create new job and invalidate relevant caches
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string',
            // ... other validations
        ]);

        $job = Job::create($validated);

        // Clear related caches
        $this->invalidateJobCaches();

        return response()->json([
            'success' => true,
            'data' => $job,
            'message' => 'Job created successfully',
        ], 201);
    }

    /**
     * Update job and invalidate caches
     */
    public function update(Request $request, string $slug): JsonResponse
    {
        $job = Job::where('slug', $slug)->firstOrFail();
        
        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            // ... other validations
        ]);

        $job->update($validated);

        // Clear specific job cache
        Cache::forget("job_detail_{$slug}");
        
        // If slug changed, clear old slug cache too
        if (isset($validated['title']) && $job->wasChanged('slug')) {
            Cache::forget("job_detail_{$job->getOriginal('slug')}");
        }

        // Clear list caches
        $this->invalidateJobCaches();

        return response()->json([
            'success' => true,
            'data' => $job,
            'message' => 'Job updated successfully',
        ]);
    }

    /**
     * Delete job and invalidate caches
     */
    public function destroy(string $slug): JsonResponse
    {
        $job = Job::where('slug', $slug)->firstOrFail();
        $job->delete();

        // Clear specific cache
        Cache::forget("job_detail_{$slug}");
        
        // Clear list caches
        $this->invalidateJobCaches();

        return response()->json([
            'success' => true,
            'message' => 'Job deleted successfully',
        ]);
    }

    /**
     * Get featured jobs with aggressive caching
     * 
     * Cache Strategy:
     * - Featured jobs change less frequently
     * - TTL: 15 minutes (900 seconds)
     */
    public function featured(): JsonResponse
    {
        $jobs = $this->cacheResponse('jobs_featured', function() {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->where('is_active', true)
                ->where('is_featured', true)
                ->latest('published_at')
                ->limit(6)
                ->get();
        }, 900);

        return response()->json([
            'success' => true,
            'data' => $jobs,
        ]);
    }

    /**
     * Get jobs by company with caching
     */
    public function byCompany(string $companySlug): JsonResponse
    {
        $cacheKey = "company_jobs_{$companySlug}";
        
        $data = $this->cacheResponse($cacheKey, function() use ($companySlug) {
            $company = Company::where('slug', $companySlug)->firstOrFail();
            
            $jobs = Job::where('company_id', $company->id)
                ->where('is_active', true)
                ->latest('published_at')
                ->paginate(20);
            
            return [
                'company' => $company,
                'jobs' => $jobs,
            ];
        }, 300);

        return response()->json([
            'success' => true,
            'data' => $data,
        ]);
    }

    /**
     * Search jobs with caching
     * 
     * Cache Strategy:
     * - Cache each unique search query
     * - Shorter TTL for search results
     */
    public function search(Request $request): JsonResponse
    {
        $query = $request->input('q', '');
        $cacheKey = "job_search_" . md5($query . serialize($request->except('page')));
        
        $results = $this->cacheResponse($cacheKey, function() use ($request, $query) {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->where('is_active', true)
                ->where(function($q) use ($query) {
                    $q->where('title', 'like', "%{$query}%")
                      ->orWhere('description', 'like', "%{$query}%");
                })
                ->latest('published_at')
                ->paginate(20);
        }, 180); // 3 minutes for search results

        return response()->json([
            'success' => true,
            'data' => $results,
            'query' => $query,
        ]);
    }

    /**
     * Clear all job-related caches
     * 
     * This can be called from a scheduled task or admin panel
     */
    public function clearCache(): JsonResponse
    {
        $this->invalidateJobCaches();

        return response()->json([
            'success' => true,
            'message' => 'Job caches cleared successfully',
        ]);
    }

    /**
     * Helper method to invalidate all job-related caches
     */
    protected function invalidateJobCaches(): void
    {
        // Clear list caches with wildcard pattern
        // Note: This works better with Redis tags feature
        $patterns = [
            'jobs_list*',
            'jobs_featured',
            'company_jobs_*',
            'job_search_*',
        ];

        foreach ($patterns as $pattern) {
            // For simple implementation, you might track cache keys
            // For advanced: use Cache::tags(['jobs'])->flush() with Redis
            Cache::forget($pattern);
        }
    }

    /**
     * Example: Using cache tags (Redis only)
     * 
     * Cache tags allow you to group related cache items
     * and flush them all at once.
     */
    public function indexWithTags(Request $request): JsonResponse
    {
        $cacheKey = $this->getCacheKey('jobs_list', $request->all());
        
        // Cache with tags
        $jobs = Cache::tags(['jobs', 'listings'])->remember($cacheKey, 300, function() use ($request) {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->where('is_active', true)
                ->latest('published_at')
                ->paginate(20);
        });

        return response()->json([
            'success' => true,
            'data' => $jobs,
        ]);
    }

    /**
     * Clear all caches with specific tag
     */
    public function clearTaggedCache(string $tag): JsonResponse
    {
        Cache::tags([$tag])->flush();

        return response()->json([
            'success' => true,
            'message' => "All caches with tag '{$tag}' cleared",
        ]);
    }
}
