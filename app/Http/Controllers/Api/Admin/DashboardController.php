<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Company;
use App\Models\Job;
use App\Models\JobApplication;
use App\Models\User;
use App\Models\UserCv;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    /**
     * Get admin dashboard statistics and metrics.
     */
    public function index(): JsonResponse
    {
        $stats = [
            // User statistics
            'users' => [
                'total' => User::count(),
                'job_seekers' => User::where('user_type', 'job_seeker')->count(),
                'company_owners' => User::where('user_type', 'company_owner')->count(),
                'admins' => User::where('is_admin', true)->count(),
                'new_this_month' => User::whereMonth('created_at', now()->month)->count(),
                'new_today' => User::whereDate('created_at', now())->count(),
            ],

            // Company statistics
            'companies' => [
                'total' => Company::count(),
                'with_active_jobs' => Company::whereHas('jobs', function ($q) {
                    $q->where('status', 'active');
                })->count(),
                'new_this_month' => Company::whereMonth('created_at', now()->month)->count(),
                'new_today' => Company::whereDate('created_at', now())->count(),
            ],

            // Job statistics
            'jobs' => [
                'total' => Job::count(),
                'active' => Job::where('status', 'active')->count(),
                'closed' => Job::where('status', 'closed')->count(),
                'draft' => Job::where('status', 'draft')->count(),
                'featured' => Job::where('is_featured', true)->count(),
                'new_this_month' => Job::whereMonth('created_at', now()->month)->count(),
                'new_today' => Job::whereDate('created_at', now())->count(),
            ],

            // Application statistics
            'applications' => [
                'total' => JobApplication::count(),
                'pending' => JobApplication::where('status', 'pending')->count(),
                'reviewed' => JobApplication::where('status', 'reviewed')->count(),
                'shortlisted' => JobApplication::where('status', 'shortlisted')->count(),
                'interview' => JobApplication::where('status', 'interview')->count(),
                'accepted' => JobApplication::where('status', 'accepted')->count(),
                'rejected' => JobApplication::where('status', 'rejected')->count(),
                'new_this_month' => JobApplication::whereMonth('created_at', now()->month)->count(),
                'new_today' => JobApplication::whereDate('created_at', now())->count(),
            ],

            // CV statistics
            'cvs' => [
                'total' => UserCv::count(),
                'public' => UserCv::where('is_public', true)->count(),
                'new_this_month' => UserCv::whereMonth('created_at', now()->month)->count(),
            ],

            // Activity metrics
            'activity' => [
                'users_last_7_days' => $this->getUsersCreatedByDay(7),
                'jobs_last_7_days' => $this->getJobsCreatedByDay(7),
                'applications_last_7_days' => $this->getApplicationsCreatedByDay(7),
            ],

            // Top metrics
            'top' => [
                'industries' => Company::select('industry')
                    ->selectRaw('count(*) as count')
                    ->groupBy('industry')
                    ->orderByDesc('count')
                    ->limit(5)
                    ->get(),
                'job_types' => Job::select('job_type')
                    ->selectRaw('count(*) as count')
                    ->groupBy('job_type')
                    ->orderByDesc('count')
                    ->limit(5)
                    ->get(),
                'companies_by_jobs' => Company::withCount('jobs')
                    ->orderByDesc('jobs_count')
                    ->limit(10)
                    ->get(['id', 'name', 'slug']),
            ],
        ];

        return response()->json($stats);
    }

    /**
     * Get users created per day for the last N days.
     */
    private function getUsersCreatedByDay(int $days): array
    {
        return User::select(DB::raw('DATE(created_at) as date'), DB::raw('count(*) as count'))
            ->where('created_at', '>=', now()->subDays($days))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->pluck('count', 'date')
            ->toArray();
    }

    /**
     * Get jobs created per day for the last N days.
     */
    private function getJobsCreatedByDay(int $days): array
    {
        return Job::select(DB::raw('DATE(created_at) as date'), DB::raw('count(*) as count'))
            ->where('created_at', '>=', now()->subDays($days))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->pluck('count', 'date')
            ->toArray();
    }

    /**
     * Get applications created per day for the last N days.
     */
    private function getApplicationsCreatedByDay(int $days): array
    {
        return JobApplication::select(DB::raw('DATE(created_at) as date'), DB::raw('count(*) as count'))
            ->where('created_at', '>=', now()->subDays($days))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->pluck('count', 'date')
            ->toArray();
    }
}
