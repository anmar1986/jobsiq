#!/bin/bash

echo "==================================="
echo "Job Expiration Feature Test Script"
echo "==================================="
echo ""

# Test 1: Check if the command exists
echo "Test 1: Checking if deactivation command exists..."
php artisan list | grep "jobs:deactivate-expired"
if [ $? -eq 0 ]; then
    echo "✓ Command exists"
else
    echo "✗ Command not found"
    exit 1
fi
echo ""

# Test 2: Run the command
echo "Test 2: Running deactivation command..."
php artisan jobs:deactivate-expired
if [ $? -eq 0 ]; then
    echo "✓ Command executed successfully"
else
    echo "✗ Command failed"
    exit 1
fi
echo ""

# Test 3: Check expired jobs in database
echo "Test 3: Checking for expired jobs in database..."
php artisan tinker --execute="
\$expiredJobs = \App\Models\Job::where('expires_at', '<', now())->count();
echo 'Total jobs with expired date: ' . \$expiredJobs . PHP_EOL;

\$activeExpired = \App\Models\Job::where('is_active', true)->where('expires_at', '<', now())->count();
echo 'Active jobs that are expired: ' . \$activeExpired . PHP_EOL;

\$inactiveExpired = \App\Models\Job::where('is_active', false)->where('expires_at', '<', now())->count();
echo 'Inactive jobs that are expired: ' . \$inactiveExpired . PHP_EOL;
"
echo ""

# Test 4: Check job expiration settings
echo "Test 4: Checking job expiration configuration..."
php artisan tinker --execute="
\$days = config('job.default_expiration_days', 30);
echo 'Default expiration days: ' . \$days . PHP_EOL;
"
echo ""

# Test 5: Verify active job scope
echo "Test 5: Testing active job scope..."
php artisan tinker --execute="
\$totalJobs = \App\Models\Job::count();
\$activeJobs = \App\Models\Job::active()->count();
echo 'Total jobs: ' . \$totalJobs . PHP_EOL;
echo 'Active (non-expired) jobs: ' . \$activeJobs . PHP_EOL;
"
echo ""

echo "==================================="
echo "All tests completed!"
echo "==================================="
