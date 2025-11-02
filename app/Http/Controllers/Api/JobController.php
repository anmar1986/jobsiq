<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreJobRequest;
use App\Http\Requests\UpdateJobRequest;
use App\Http\Traits\CachesApiResponses;
use App\Models\Job;
use App\Models\SearchHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class JobController extends Controller
{
    use CachesApiResponses;

    /**
     * Searchable filter parameters that should trigger search history logging.
     */
    private const SEARCHABLE_FILTERS = [
        'search',
        'location',
        'employment_type',
        'experience_level',
        'is_remote',
        'category',
        'salary_min',
        'company',
    ];

    /**
     * Display a listing of jobs with search and filters.
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $perPage = min((int) $request->get('per_page', 15), 100); // Max 100 items per page

            $query = Job::with(['company:id,name,slug', 'company.logo'])
                ->select([
                    'id', 'company_id', 'title', 'slug', 'description', 'requirements',
                    'benefits',
                    'location', 'city', 'country', 'employment_type', 'experience_level',
                    'category', 'skills', 'salary_min', 'salary_max', 'salary_currency',
                    'salary_period', 'is_remote', 'is_featured', 'published_at',
                    'expires_at', 'created_at',
                ])
                ->active()
                ->published();

            // Apply filters
            $query = $this->applyFilters($query, $request);

            // Sort: Random order with featured jobs having priority
            if ($request->get('sort') === 'oldest') {
                $query->orderBy('published_at', 'asc');
            } elseif ($request->get('sort') === 'newest') {
                // Optional: keep newest sorting as an option
                $query->orderByDesc('is_featured')
                    ->orderByDesc('published_at');
            } else {
                // Default: Featured first, then random
                $query->orderByDesc('is_featured')
                    ->inRandomOrder();
            }

            // Paginate results
            $jobs = $query->paginate($perPage);
            $total = $jobs->total();

            // Log search history if search or filters are used
            if ($request->hasAny(self::SEARCHABLE_FILTERS)) {
                $this->logSearch($request, $total);
            }

            return response()->json([
                'success' => true,
                'data' => $jobs,
                'message' => "Found {$total} job".($total !== 1 ? 's' : ''),
            ]);
        } catch (\Exception $e) {
            Log::error('Job index error: '.$e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch jobs',
                'error' => config('app.debug') ? $e->getMessage() : null,
            ], 500);
        }
    }

    /**
     * Apply search and filter conditions to query.
     */
    protected function applyFilters($query, Request $request)
    {
        // Search by title or company
        if ($request->filled('search')) {
            $query->search($request->search);
        }

        // Filter by location
        if ($request->filled('location')) {
            $query->location($request->location);
        }

        // Filter by employment type
        if ($request->filled('employment_type')) {
            $query->employmentType($request->employment_type);
        }

        // Filter by experience level
        if ($request->filled('experience_level')) {
            $query->experienceLevel($request->experience_level);
        }

        // Filter by remote
        if ($request->has('is_remote') && $request->is_remote !== null) {
            $query->remote($request->boolean('is_remote'));
        }

        // Filter by category
        if ($request->filled('category')) {
            $query->where('category', $request->category);
        }

        // Filter by minimum salary
        if ($request->filled('salary_min') && $request->salary_min > 0) {
            $query->where('salary_max', '>=', $request->salary_min);
        }

        // Filter by company slug
        if ($request->filled('company')) {
            $query->whereHas('company', function ($q) use ($request) {
                $q->where('slug', $request->company);
            });
        }

        return $query;
    }

    /**
     * Store a newly created job.
     */
    public function store(StoreJobRequest $request): JsonResponse
    {
        $validated = $request->validated();
        $validated['user_id'] = $request->user()->id;

        // Set published_at to now if not provided
        if (! isset($validated['published_at'])) {
            $validated['published_at'] = now();
        }

        // Ensure is_active is true by default
        if (! isset($validated['is_active'])) {
            $validated['is_active'] = true;
        }

        $job = Job::create($validated);
        $job->load(['company', 'company.logo']);

        // Clear relevant caches
        $this->clearJobCaches();

        return response()->json([
            'success' => true,
            'data' => $job,
            'message' => 'Job created successfully',
        ], 201);
    }

    /**
     * Display the specified job.
     */
    public function show(Job $job): JsonResponse
    {
        $job->load(['company', 'company.logo', 'company.images', 'user']);

        return response()->json([
            'success' => true,
            'data' => $job,
        ]);
    }

    /**
     * Update the specified job.
     */
    public function update(UpdateJobRequest $request, Job $job): JsonResponse
    {
        $oldSlug = $job->slug;
        $job->update($request->validated());
        $job->load(['company', 'company.logo']);

        // Clear relevant caches
        $this->clearJobCaches($oldSlug);
        if ($job->slug !== $oldSlug) {
            $this->clearJobCaches($job->slug);
        }

        return response()->json([
            'success' => true,
            'data' => $job,
            'message' => 'Job updated successfully',
        ]);
    }

    /**
     * Remove the specified job.
     */
    public function destroy(Request $request, Job $job): JsonResponse
    {
        /** @var \App\Models\Company $company */
        $company = $job->company;

        // Check authorization
        if (! $company || ! $request->user()->ownsCompany($company)) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized to delete this job',
            ], 403);
        }

        $slug = $job->slug;
        $job->delete();

        // Clear relevant caches
        $this->clearJobCaches($slug);

        return response()->json([
            'success' => true,
            'message' => 'Job deleted successfully',
        ]);
    }

    /**
     * Clear job-related caches
     */
    protected function clearJobCaches(?string $slug = null): void
    {
        // Clear home page cache
        Cache::forget('home_page_content');

        // Clear featured jobs cache
        for ($i = 1; $i <= 20; $i++) {
            Cache::forget("featured_jobs_{$i}");
        }

        // Clear specific job cache if slug provided
        if ($slug) {
            Cache::forget("job_detail_{$slug}");
        }
    }

    /**
     * Get featured jobs.
     */
    public function featured(Request $request): JsonResponse
    {
        $limit = min((int) $request->get('limit', 6), 20); // Max 20 featured jobs

        // Cache featured jobs for 1 hour
        $jobs = Cache::remember("featured_jobs_{$limit}", 3600, function () use ($limit) {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->select([
                    'id', 'company_id', 'title', 'slug', 'description', 'requirements',
                    'benefits', 'location', 'city', 'country',
                    'employment_type', 'experience_level', 'category', 'salary_min', 'salary_max',
                    'salary_currency', 'salary_period', 'is_remote', 'is_featured',
                    'published_at', 'created_at',
                ])
                ->active()
                ->published()
                ->where('is_featured', true)
                ->latest('published_at')
                ->limit($limit)
                ->get();
        });

        return response()->json([
            'success' => true,
            'data' => $jobs,
        ]);
    }

    /**
     * Log search history asynchronously.
     */
    protected function logSearch(Request $request, int $resultsCount): void
    {
        try {
            $filters = [];

            if ($request->filled('employment_type')) {
                $filters['employment_type'] = $request->employment_type;
            }
            if ($request->filled('experience_level')) {
                $filters['experience_level'] = $request->experience_level;
            }
            if ($request->has('is_remote')) {
                $filters['is_remote'] = $request->boolean('is_remote');
            }
            if ($request->filled('category')) {
                $filters['category'] = $request->category;
            }
            if ($request->filled('salary_min')) {
                $filters['salary_min'] = $request->salary_min;
            }
            if ($request->filled('company')) {
                $filters['company'] = $request->company;
            }

            SearchHistory::create([
                'user_id' => $request->user()?->id,
                'search_query' => $request->get('search'),
                'location' => $request->get('location'),
                'filters' => ! empty($filters) ? $filters : null,
                'results_count' => $resultsCount,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'session_id' => null, // API routes don't have sessions
            ]);
        } catch (\Exception $e) {
            Log::warning('Failed to log search history: '.$e->getMessage());
        }
    }
}
