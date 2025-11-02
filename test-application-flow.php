<?php

/**
 * Test Job Application Flow
 * 
 * This script tests the job application submission and retrieval process
 * Run with: php test-application-flow.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(\Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\User;
use App\Models\Job;
use App\Models\JobApplication;
use Illuminate\Support\Facades\DB;

echo "========================================\n";
echo "Job Application Flow Test\n";
echo "========================================\n\n";

// Check database connection
try {
    DB::connection()->getPdo();
    echo "✓ Database connected successfully\n\n";
} catch (\Exception $e) {
    echo "✗ Database connection failed: " . $e->getMessage() . "\n";
    exit(1);
}

// Check if job_applications table exists
$tableExists = DB::select("SHOW TABLES LIKE 'job_applications'");
if (empty($tableExists)) {
    echo "✗ job_applications table does not exist!\n";
    echo "Run: php artisan migrate\n";
    exit(1);
}
echo "✓ job_applications table exists\n\n";

// Show table structure
echo "Table Structure:\n";
echo "----------------\n";
$columns = DB::select("DESCRIBE job_applications");
foreach ($columns as $column) {
    echo "  - {$column->Field} ({$column->Type}) " . ($column->Null === 'YES' ? 'NULL' : 'NOT NULL') . "\n";
}
echo "\n";

// Count existing records
$totalApplications = JobApplication::count();
echo "Total Applications: $totalApplications\n\n";

// Get a sample user (job seeker)
$jobSeeker = User::where('user_type', 'job_seeker')->first();
if (!$jobSeeker) {
    echo "✗ No job seeker found in database\n";
    echo "Create a job seeker account first\n";
    exit(1);
}
echo "✓ Found job seeker: {$jobSeeker->name} (ID: {$jobSeeker->id})\n";

// Get applications for this user
$userApplications = JobApplication::where('user_id', $jobSeeker->id)
    ->with(['job.company'])
    ->get();

echo "  Applications by this user: {$userApplications->count()}\n\n";

if ($userApplications->count() > 0) {
    echo "User's Applications:\n";
    echo "-------------------\n";
    foreach ($userApplications as $app) {
        echo "  - Job: {$app->job->title}\n";
        echo "    Company: {$app->job->company->name}\n";
        echo "    Status: {$app->status}\n";
        echo "    Applied: {$app->applied_at->format('Y-m-d H:i:s')}\n\n";
    }
}

// Get a sample job
$job = Job::with('company')->first();
if (!$job) {
    echo "✗ No jobs found in database\n";
    echo "Create a job first\n";
    exit(1);
}
echo "✓ Found sample job: {$job->title} at {$job->company->name} (ID: {$job->id})\n\n";

// Check if user already applied to this job
$existingApp = JobApplication::where('user_id', $jobSeeker->id)
    ->where('job_id', $job->id)
    ->first();

if ($existingApp) {
    echo "ℹ User has already applied to this job\n";
    echo "  Application ID: {$existingApp->id}\n";
    echo "  Status: {$existingApp->status}\n";
    echo "  Applied: {$existingApp->applied_at->format('Y-m-d H:i:s')}\n\n";
} else {
    echo "ℹ User has NOT applied to this job yet\n\n";
    
    echo "Would you like to create a test application? (yes/no): ";
    $handle = fopen("php://stdin", "r");
    $line = fgets($handle);
    $answer = trim(strtolower($line));
    fclose($handle);
    
    if ($answer === 'yes' || $answer === 'y') {
        echo "\nCreating test application...\n";
        
        try {
            $application = JobApplication::create([
                'user_id' => $jobSeeker->id,
                'job_id' => $job->id,
                'cv_id' => null,
                'cover_letter' => 'This is a test cover letter created by the test script.',
                'status' => 'pending',
                'applied_at' => now(),
            ]);
            
            echo "✓ Application created successfully!\n";
            echo "  Application ID: {$application->id}\n";
            echo "  Status: {$application->status}\n\n";
            
            // Test retrieval
            $retrieved = JobApplication::with(['job.company.logo', 'cv'])
                ->where('user_id', $jobSeeker->id)
                ->latest('applied_at')
                ->get();
            
            echo "✓ Retrieved {$retrieved->count()} applications for user\n";
            
        } catch (\Exception $e) {
            echo "✗ Failed to create application: " . $e->getMessage() . "\n";
        }
    }
}

echo "\n========================================\n";
echo "API Endpoint Test:\n";
echo "========================================\n";
echo "To test via API, use:\n\n";
echo "GET /api/my-applications\n";
echo "Authorization: Bearer {your-token}\n\n";

echo "To apply for a job:\n";
echo "POST /api/jobs/{job-slug}/apply\n";
echo "Authorization: Bearer {your-token}\n";
echo "Content-Type: application/json\n\n";
echo '{"cv_id": null, "cover_letter": "Your cover letter here"}' . "\n\n";

echo "========================================\n";
echo "Test completed!\n";
echo "========================================\n";
