<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreJobApplicationRequest;
use App\Mail\JobApplicationSubmitted;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobApplication;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class JobApplicationController extends Controller
{
    /**
     * Get current user's job applications.
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $userId = Auth::id();

            // Debug log
            Log::info('Fetching applications for user', ['user_id' => $userId]);

            $query = JobApplication::with(['job.company.logo', 'cv'])
                ->where('user_id', $userId)
                ->latest('applied_at');

            // Filter by status
            if ($request->has('status')) {
                $query->where('status', $request->status);
                Log::info('Filtering by status', ['status' => $request->status]);
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
                Log::info('Searching', ['search' => $search]);
            }

            $applications = $query->paginate($request->get('per_page', 15));

            Log::info('Applications retrieved', [
                'count' => $applications->count(),
                'total' => $applications->total(),
            ]);

            return response()->json([
                'success' => true,
                'data' => $applications,
            ]);
        } catch (\Exception $e) {
            Log::error('Error fetching applications', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch applications',
                'error' => $e->getMessage(),
            ], 500);
        }
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
            'status' => 'pending',
            'applied_at' => now(),
        ]);

        $application->load(['job.company.logo', 'cv', 'user']);

        // Send email notification to the company
        try {
            /** @var \App\Models\Company|null $company */
            $company = $job->company;
            if ($company && $company->email && filter_var($company->email, FILTER_VALIDATE_EMAIL)) {
                Mail::to($company->email)->send(new JobApplicationSubmitted($application));
            }
        } catch (\Exception $e) {
            // Log the error but don't fail the application submission
            Log::error('Failed to send job application email: '.$e->getMessage());
        }

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

    /**
     * Get applications for company owner's jobs.
     */
    public function companyApplications(Request $request): JsonResponse
    {
        try {
            /** @var \App\Models\User $user */
            $user = Auth::user();

            // Get all companies owned by this user
            $companyIds = $user->ownedCompanies()->pluck('companies.id');

            if ($companyIds->isEmpty()) {
                return response()->json([
                    'success' => true,
                    'data' => [
                        'data' => [],
                        'total' => 0,
                    ],
                    'message' => 'No companies found.',
                ]);
            }

            Log::info('Fetching applications for companies', ['company_ids' => $companyIds->toArray()]);

            $query = JobApplication::with(['job.company.logo', 'user', 'cv'])
                ->whereHas('job', function ($q) use ($companyIds) {
                    $q->whereIn('company_id', $companyIds);
                })
                ->latest('applied_at');

            // Filter by status
            if ($request->has('status')) {
                $query->where('status', $request->status);
            }

            // Filter by company
            if ($request->has('company_id')) {
                $query->whereHas('job', function ($q) use ($request) {
                    $q->where('company_id', $request->company_id);
                });
            }

            // Filter by job
            if ($request->has('job_id')) {
                $query->where('job_id', $request->job_id);
            }

            // Search by applicant name or job title
            if ($request->has('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->whereHas('user', function ($uq) use ($search) {
                        $uq->where('name', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%");
                    })
                        ->orWhereHas('job', function ($jq) use ($search) {
                            $jq->where('title', 'like', "%{$search}%");
                        });
                });
            }

            $applications = $query->paginate($request->get('per_page', 15));

            return response()->json([
                'success' => true,
                'data' => $applications,
            ]);
        } catch (\Exception $e) {
            Log::error('Error fetching company applications', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch applications',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
