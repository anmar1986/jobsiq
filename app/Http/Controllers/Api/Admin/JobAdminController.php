<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class JobAdminController extends Controller
{
    /**
     * Display a listing of jobs with pagination and filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = Job::with(['company', 'user']);

        // Search filter
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Job type filter
        if ($request->has('job_type')) {
            $query->where('job_type', $request->job_type);
        }

        // Experience level filter
        if ($request->has('experience_level')) {
            $query->where('experience_level', $request->experience_level);
        }

        // Status filter
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Featured filter
        if ($request->has('is_featured')) {
            $query->where('is_featured', $request->boolean('is_featured'));
        }

        // Company filter
        if ($request->has('company_id')) {
            $query->where('company_id', $request->company_id);
        }

        // Sorting
        $sortField = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortField, $sortOrder);

        $perPage = $request->get('per_page', 15);
        $jobs = $query->paginate($perPage);

        return response()->json($jobs);
    }

    /**
     * Store a newly created job.
     */
    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'company_id' => 'required|exists:companies,id',
            'user_id' => 'required|exists:users,id',
            'title' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255|unique:jobs',
            'description' => 'required|string',
            'requirements' => 'required|string',
            'responsibilities' => 'nullable|string',
            'job_type' => ['required', Rule::in(['full-time', 'part-time', 'contract', 'temporary', 'internship'])],
            'experience_level' => ['required', Rule::in(['entry', 'mid', 'senior', 'lead', 'executive'])],
            'salary_min' => 'nullable|numeric|min:0',
            'salary_max' => 'nullable|numeric|min:0|gte:salary_min',
            'salary_currency' => 'nullable|string|max:3',
            'location' => 'required|string|max:255',
            'remote_option' => ['required', Rule::in(['on-site', 'remote', 'hybrid'])],
            'skills_required' => 'nullable|array',
            'benefits' => 'nullable|array',
            'application_deadline' => 'nullable|date|after:today',
            'status' => ['required', Rule::in(['active', 'closed', 'draft'])],
            'is_featured' => 'boolean',
        ]);

        // Generate slug if not provided
        if (empty($validated['slug'])) {
            $validated['slug'] = Str::slug($validated['title']);

            $originalSlug = $validated['slug'];
            $counter = 1;
            while (Job::where('slug', $validated['slug'])->exists()) {
                $validated['slug'] = $originalSlug.'-'.$counter++;
            }
        }

        $job = Job::create($validated);

        $job->load(['company', 'user']);

        return response()->json([
            'message' => 'Job created successfully',
            'job' => $job,
        ], 201);
    }

    /**
     * Display the specified job.
     */
    public function show(Job $job): JsonResponse
    {
        $job->load(['company', 'user', 'applications']);

        return response()->json($job);
    }

    /**
     * Update the specified job.
     */
    public function update(Request $request, Job $job): JsonResponse
    {
        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'slug' => 'sometimes|string|max:255|unique:jobs,slug,'.$job->id,
            'description' => 'sometimes|string',
            'requirements' => 'sometimes|string',
            'responsibilities' => 'nullable|string',
            'job_type' => ['sometimes', Rule::in(['full-time', 'part-time', 'contract', 'temporary', 'internship'])],
            'experience_level' => ['sometimes', Rule::in(['entry', 'mid', 'senior', 'lead', 'executive'])],
            'salary_min' => 'nullable|numeric|min:0',
            'salary_max' => 'nullable|numeric|min:0|gte:salary_min',
            'salary_currency' => 'nullable|string|max:3',
            'location' => 'sometimes|string|max:255',
            'remote_option' => ['sometimes', Rule::in(['on-site', 'remote', 'hybrid'])],
            'skills_required' => 'nullable|array',
            'benefits' => 'nullable|array',
            'application_deadline' => 'nullable|date',
            'status' => ['sometimes', Rule::in(['active', 'closed', 'draft'])],
            'is_featured' => 'sometimes|boolean',
        ]);

        $job->update($validated);

        return response()->json([
            'message' => 'Job updated successfully',
            'job' => $job,
        ]);
    }

    /**
     * Remove the specified job.
     */
    public function destroy(Job $job): JsonResponse
    {
        $job->delete();

        return response()->json([
            'message' => 'Job deleted successfully',
        ]);
    }

    /**
     * Get statistics about jobs.
     */
    public function statistics(): JsonResponse
    {
        $stats = [
            'total_jobs' => Job::count(),
            'active_jobs' => Job::where('status', 'active')->count(),
            'closed_jobs' => Job::where('status', 'closed')->count(),
            'draft_jobs' => Job::where('status', 'draft')->count(),
            'featured_jobs' => Job::where('is_featured', true)->count(),
            'recent_jobs' => Job::where('created_at', '>=', now()->subDays(30))->count(),
            'jobs_by_type' => Job::select('job_type')
                ->selectRaw('count(*) as count')
                ->groupBy('job_type')
                ->get(),
            'jobs_by_experience_level' => Job::select('experience_level')
                ->selectRaw('count(*) as count')
                ->groupBy('experience_level')
                ->get(),
        ];

        return response()->json($stats);
    }

    /**
     * Toggle featured status of a job.
     */
    public function toggleFeatured(Job $job): JsonResponse
    {
        $job->update(['is_featured' => ! $job->is_featured]);

        return response()->json([
            'message' => 'Job featured status updated',
            'is_featured' => $job->is_featured,
        ]);
    }
}
