<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreJobApplicationRequest;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobApplication;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class JobApplicationController extends Controller
{
    /**
     * Get current user's job applications.
     */
    public function index(Request $request): JsonResponse
    {
        $query = JobApplication::with(['job.company.logo', 'cv'])
            ->where('user_id', Auth::id())
            ->latest('applied_at');

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Search by job title or company name
        if ($request->has('search')) {
            $search = $request->search;
            $query->whereHas('job', function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhereHas('company', function ($cq) use ($search) {
                        $cq->where('name', 'like', "%{$search}%");
                    });
            });
        }

        $applications = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $applications,
        ]);
    }

    /**
     * Apply for a job.
     */
    public function store(StoreJobApplicationRequest $request, Job $job): JsonResponse
    {
        // Check if user already applied
        $existingApplication = JobApplication::where('user_id', Auth::id())
            ->where('job_id', $job->id)
            ->first();

        if ($existingApplication) {
            return response()->json([
                'success' => false,
                'message' => 'You have already applied for this job.',
            ], 422);
        }

        $application = JobApplication::create([
            'user_id' => Auth::id(),
            'job_id' => $job->id,
            'cv_id' => $request->cv_id,
            'cover_letter' => $request->cover_letter,
            'applied_at' => now(),
        ]);

        $application->load(['job.company', 'cv']);

        return response()->json([
            'success' => true,
            'data' => $application,
            'message' => 'Application submitted successfully!',
        ], 201);
    }

    /**
     * Get a single application.
     */
    public function show(JobApplication $application): JsonResponse
    {
        // Check authorization
        if ($application->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $application->load(['job.company.logo', 'cv', 'user']);

        return response()->json([
            'success' => true,
            'data' => $application,
        ]);
    }

    /**
     * Update application status (for employers).
     */
    public function updateStatus(Request $request, JobApplication $application): JsonResponse
    {
        // Check if user owns the company that posted the job
        $application->load(['job.company']);
        /** @var Job $job */
        $job = $application->job;
        /** @var Company $company */
        $company = $job->company;

        if (! $company->isOwnedBy(Auth::user())) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Only company owners can update application status.',
            ], 403);
        }

        $validated = $request->validate([
            'status' => ['required', 'string', 'in:pending,reviewed,accepted,rejected'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ]);

        $application->update([
            'status' => $validated['status'],
            'reviewed_at' => now(),
            'notes' => $validated['notes'] ?? $application->notes,
        ]);

        $application->load(['job', 'user']);

        return response()->json([
            'success' => true,
            'data' => $application,
            'message' => 'Application status updated successfully.',
        ]);
    }

    /**
     * Withdraw an application.
     */
    public function destroy(JobApplication $application): JsonResponse
    {
        // Check authorization
        if ($application->user_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Only allow withdrawal of pending applications
        if (! $application->isPending()) {
            return response()->json([
                'success' => false,
                'message' => 'You can only withdraw pending applications.',
            ], 422);
        }

        $application->delete();

        return response()->json([
            'success' => true,
            'message' => 'Application withdrawn successfully.',
        ]);
    }

    /**
     * Check if user has applied to a specific job.
     */
    public function checkApplication(Job $job): JsonResponse
    {
        $application = JobApplication::where('user_id', Auth::id())
            ->where('job_id', $job->id)
            ->first();

        return response()->json([
            'success' => true,
            'data' => [
                'has_applied' => ! is_null($application),
                'application' => $application,
            ],
        ]);
    }
}
