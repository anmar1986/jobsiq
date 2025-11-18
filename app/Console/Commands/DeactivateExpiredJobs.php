<?php

namespace App\Console\Commands;

use App\Models\Job;
use Illuminate\Console\Command;

class DeactivateExpiredJobs extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'jobs:deactivate-expired';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Deactivate jobs that have passed their expiration date';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Checking for expired jobs...');

        $expiredJobs = Job::where('is_active', true)
            ->whereNotNull('expires_at')
            ->where('expires_at', '<', now())
            ->get();

        if ($expiredJobs->isEmpty()) {
            $this->info('No expired jobs found.');

            return 0;
        }

        $count = 0;
        foreach ($expiredJobs as $job) {
            $job->is_active = false;
            $job->save();
            $count++;
            $this->line("Deactivated job: {$job->title} (ID: {$job->id})");
        }

        $this->info("Successfully deactivated {$count} expired job(s).");

        return 0;
    }
}
