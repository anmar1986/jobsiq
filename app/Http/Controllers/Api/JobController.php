<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreJobRequest;
use App\Http\Requests\UpdateJobRequest;
use App\Models\Job;
use App\Models\SearchHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class JobController extends Controller
{
    /**
     * Display a listing of jobs with search and filters.
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $perPage = min((int) $request->get('per_page', 15), 100); // Max 100 items per page

            $query = Job::with(['company' => function ($q) {
                $q->select('id', 'name', 'slug');
            }, 'company.logo'])
                ->select([
                'id', 'company_id', 'title', 'slug', 'description', 'requirements',
                'location', 'city', 'country', 'employment_type', 'experience_level',
                'category', 'skills', 'salary_min', 'salary_max', 'salary_currency',
                'salary_period', 'is_remote', 'is_featured', 'published_at',
                'expires_at', 'created_at',
            ])
                ->active()
                ->published()
                ->latest('published_at');

            // Apply filters
            $query = $this->applyFilters($query, $request);

            // Get total count efficiently
            $total = $query->count();

            // Paginate results
            $jobs = $query->paginate($perPage);

            // Log search asynchronously (don't wait for it)
            if ($request->filled('search') || $request->filled('location')) {
                dispatch(function () use ($request, $total) {
                    $this->logSearch($request, $total);
                })->afterResponse();
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

        // Filter by salary range
        if ($request->filled('salary_min') && $request->salary_min > 0) {
            $query->where('salary_max', '>=', $request->salary_min);
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

        $job = Job::create($validated);
        $job->load(['company', 'company.logo']);

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
        $job->update($request->validated());
        $job->load(['company', 'company.logo']);

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
        // Check authorization
        if (! $request->user()->ownsCompany($job->company)) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized to delete this job',
            ], 403);
        }

        $job->delete();

        return response()->json([
            'success' => true,
            'message' => 'Job deleted successfully',
        ]);
    }

    /**
     * Get featured jobs.
     */
    public function featured(Request $request): JsonResponse
    {
        $limit = min((int) $request->get('limit', 6), 20); // Max 20 featured jobs

        // Cache featured jobs for 1 hour
        $jobs = Cache::remember("featured_jobs_{$limit}", 3600, function () use ($limit) {
            return Job::with(['company' => function ($q) {
                $q->select('id', 'name', 'slug');
            }, 'company.logo'])
                ->select([
            'id', 'company_id', 'title', 'slug', 'location', 'city', 'country',
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
