<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Job;
use App\Models\SavedJob;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SavedJobController extends Controller
{
    /**
     * Get all saved jobs for the authenticated user.
     */
    public function index(Request $request): JsonResponse
    {
        $savedJobs = $request->user()
            ->savedJobs()
            ->with(['company.logo', 'company.cover'])
            ->latest('saved_jobs.created_at')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $savedJobs,
        ]);
    }

    /**
     * Save a job for the authenticated user.
     */
    public function store(Request $request, Job $job): JsonResponse
    {
        $request->validate([
            'job_id' => 'sometimes|exists:jobs,id',
        ]);

        // Check if already saved
        $exists = SavedJob::where('user_id', $request->user()->id)
            ->where('job_id', $job->id)
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Job already saved',
            ], 400);
        }

        SavedJob::create([
            'user_id' => $request->user()->id,
            'job_id' => $job->id,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Job saved successfully',
        ], 201);
    }

    /**
     * Remove a saved job.
     */
    public function destroy(Request $request, Job $job): JsonResponse
    {
        $deleted = SavedJob::where('user_id', $request->user()->id)
            ->where('job_id', $job->id)
            ->delete();

        if (!$deleted) {
            return response()->json([
                'success' => false,
                'message' => 'Saved job not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Job removed from saved',
        ]);
    }

    /**
     * Check if a job is saved by the authenticated user.
     */
    public function check(Request $request, Job $job): JsonResponse
    {
        $isSaved = SavedJob::where('user_id', $request->user()->id)
            ->where('job_id', $job->id)
            ->exists();

        return response()->json([
            'success' => true,
            'data' => [
                'is_saved' => $isSaved,
            ],
        ]);
    }
}
