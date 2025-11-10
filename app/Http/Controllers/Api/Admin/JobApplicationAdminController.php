<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\JobApplication;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class JobApplicationAdminController extends Controller
{
    /**
     * Display a listing of job applications with pagination and filters.
     */
    public function index(Request $request): JsonResponse
    {
        $query = JobApplication::with(['job', 'job.company', 'user']);

        // Search filter
        if ($request->has('search')) {
            $search = $request->search;
            $query->whereHas('user', function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            })->orWhereHas('job', function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%");
            });
        }

        // Status filter
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Job filter
        if ($request->has('job_id')) {
            $query->where('job_id', $request->job_id);
        }

        // User filter
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Company filter
        if ($request->has('company_id')) {
            $query->whereHas('job', function ($q) use ($request) {
                $q->where('company_id', $request->company_id);
            });
        }

        // Sorting
        $sortField = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortField, $sortOrder);

        $perPage = $request->get('per_page', 15);
        $applications = $query->paginate($perPage);

        return response()->json($applications);
    }

    /**
     * Display the specified job application.
     */
    public function show(JobApplication $application): JsonResponse
    {
        $application->load(['job', 'job.company', 'user', 'cv']);

        return response()->json($application);
    }

    /**
     * Update the specified job application status.
     */
    public function updateStatus(Request $request, JobApplication $application): JsonResponse
    {
        $validated = $request->validate([
            'status' => ['required', Rule::in(['pending', 'reviewed', 'shortlisted', 'interview', 'rejected', 'accepted'])],
            'notes' => 'nullable|string',
        ]);

        $application->update($validated);

        return response()->json([
            'message' => 'Application status updated successfully',
            'application' => $application,
        ]);
    }

    /**
     * Remove the specified job application.
     */
    public function destroy(JobApplication $application): JsonResponse
    {
        $application->delete();

        return response()->json([
            'message' => 'Application deleted successfully',
        ]);
    }

    /**
     * Get statistics about job applications.
     */
    public function statistics(): JsonResponse
    {
        $stats = [
            'total_applications' => JobApplication::count(),
            'pending_applications' => JobApplication::where('status', 'pending')->count(),
            'reviewed_applications' => JobApplication::where('status', 'reviewed')->count(),
            'shortlisted_applications' => JobApplication::where('status', 'shortlisted')->count(),
            'interview_applications' => JobApplication::where('status', 'interview')->count(),
            'rejected_applications' => JobApplication::where('status', 'rejected')->count(),
            'accepted_applications' => JobApplication::where('status', 'accepted')->count(),
            'recent_applications' => JobApplication::where('created_at', '>=', now()->subDays(30))->count(),
            'applications_by_status' => JobApplication::select('status')
                ->selectRaw('count(*) as count')
                ->groupBy('status')
                ->get(),
        ];

        return response()->json($stats);
    }
}
