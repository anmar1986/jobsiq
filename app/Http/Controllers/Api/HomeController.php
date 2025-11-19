<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\CachesApiResponses;
use App\Models\HomeContent;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller
{
    use CachesApiResponses;

    /**
     * Get all home page content.
     */
    public function index(): JsonResponse
    {
        try {
            // Cache home page data for 5 minutes
            $data = $this->cacheResponse('home_page_content', function () {
                // Get home content from database
                $content = HomeContent::getAllContent();

                // Get featured jobs (latest 3 active jobs)
                $featuredJobs = Job::with(['company'])
                    ->where('is_active', true)
                    ->latest()
                    ->take(3)
                    ->get()
                    ->map(function (Job $job): array {
                        return [
                            'id' => $job->id,
                            'title' => $job->title,
                            'company' => $job->company->name ?? 'Unknown Company',
                            'location' => $job->location,
                            'type' => $job->employment_type,
                            'level' => $job->experience_level ?? '',
                            'salary' => $this->formatSalary($job),
                            'posted' => $job->created_at->diffForHumans(),
                            'slug' => $job->slug,
                        ];
                    });

                // Get job counts by category
                $categories = DB::table('jobs')
                    ->select('category', DB::raw('COUNT(*) as count'))
                    ->where('is_active', true)
                    ->whereNotNull('category')
                    ->groupBy('category')
                    ->get()
                    ->map(function (\stdClass $item) {
                        return [
                            'name' => $item->category,
                            'count' => (int) $item->count,
                        ];
                    });

                return [
                    'content' => $content,
                    'featuredJobs' => $featuredJobs,
                    'categories' => $categories,
                    'stats' => $this->getStats(),
                ];
            }, 300); // 5 minutes

            return response()->json([
                'success' => true,
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load home page content',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get home page statistics.
     */
    private function getStats(): array
    {
        return [
            [
                'value' => $this->formatNumber(Job::where('is_active', true)->count()),
                'label' => 'Active Jobs',
            ],
            [
                'value' => $this->formatNumber(\App\Models\Company::count()),
                'label' => 'Companies',
            ],
            [
                'value' => $this->formatNumber(\App\Models\User::count()),
                'label' => 'Job Seekers',
            ],
            [
                'value' => '2K+', // This could be calculated from applications or other metrics
                'label' => 'Success Stories',
            ],
        ];
    }

    /**
     * Format large numbers (e.g., 1000 -> 1K, 10000 -> 10K+).
     */
    private function formatNumber(int $number): string
    {
        if ($number >= 10000) {
            return round($number / 1000, 1).'K+';
        }

        if ($number >= 1000) {
            return round($number / 1000, 1).'K';
        }

        return (string) $number;
    }

    /**
     * Format salary range.
     */
    private function formatSalary(Job $job): string
    {
        if ($job->salary_min && $job->salary_max) {
            $currency = $job->salary_currency ?? '$';
            $min = $this->formatSalaryAmount((int) $job->salary_min);
            $max = $this->formatSalaryAmount((int) $job->salary_max);

            return "{$currency}{$min} - {$currency}{$max}";
        }

        return 'Competitive';
    }

    /**
     * Format salary amount (similar to formatNumber but without '+' for salaries).
     */
    private function formatSalaryAmount(int $amount): string
    {
        if ($amount >= 1000) {
            $value = $amount / 1000;

            // Remove unnecessary decimals (e.g., 120.0K -> 120K)
            return (floor($value) == $value) ? ((int) $value).'K' : round($value, 1).'K';
        }

        return (string) $amount;
    }

    /**
     * Get content by section.
     */
    public function getSection(string $section): JsonResponse
    {
        try {
            // Cache section content for 10 minutes
            $content = $this->cacheResponse("home_section_{$section}", function () use ($section) {
                return HomeContent::getSection($section);
            }, 600);

            return response()->json([
                'success' => true,
                'data' => $content,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load section content',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get statistics for about page.
     */
    public function stats(): JsonResponse
    {
        try {
            $data = $this->cacheResponse('platform_stats', function () {
                return [
                    'activeJobs' => Job::where('is_active', true)->count(),
                    'companies' => \App\Models\Company::count(),
                    'jobSeekers' => \App\Models\User::where('user_type', 'job_seeker')->count(),
                    'applications' => \App\Models\JobApplication::count(),
                ];
            }, 300); // 5 minutes

            return response()->json([
                'success' => true,
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load statistics',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
