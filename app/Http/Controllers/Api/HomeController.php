<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\HomeContent;
use App\Models\Job;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class HomeController extends Controller
{
    /**
     * Get all home page content.
     */
    public function index(): JsonResponse
    {
        try {
            // Get home content from database
            $content = HomeContent::getAllContent();

            // Get featured jobs (latest 3 active jobs)
            $featuredJobs = Job::with(['company'])
                ->where('is_active', true)
                ->latest()
                ->take(3)
                ->get()
                ->map(function (Job $job) {
                    return [
                        'id' => $job->id,
                        'title' => $job->title,
                        'company' => $job->company->name ?? 'Unknown Company',
                        'location' => $job->location,
                        'type' => $job->employment_type,
                        'level' => $job->experience_level,
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

            return response()->json([
                'success' => true,
                'data' => [
                    'content' => $content,
                    'featuredJobs' => $featuredJobs,
                    'categories' => $categories,
                    'stats' => $this->getStats(),
                ],
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
     * Format large numbers (e.g., 1000 -> 1K).
     */
    private function formatNumber(int $number): string
    {
        if ($number >= 1000) {
            return round($number / 1000, 1).'K+';
        }

        return (string) $number;
    }

    /**
     * Format salary range.
     */
    private function formatSalary($job): string
    {
        if ($job->salary_min && $job->salary_max) {
            $currency = $job->salary_currency ?? '$';
            $min = $this->formatNumber($job->salary_min);
            $max = $this->formatNumber($job->salary_max);

            return "{$currency}{$min} - {$currency}{$max}";
        }

        return 'Competitive';
    }

    /**
     * Get content by section.
     */
    public function getSection(string $section): JsonResponse
    {
        try {
            $content = HomeContent::getSection($section);

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
}
