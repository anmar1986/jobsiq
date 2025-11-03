@echo off
REM Quick test to check job applications in database
REM Run this in Windows Command Prompt or Git Bash

echo =========================================
echo JobsIQ - Quick Application Check
echo =========================================
echo.

echo Checking total applications in database...
php artisan tinker --execute="echo '\nTotal applications: ' . \App\Models\JobApplication::count(); echo '\n';"

echo.
echo Checking applications by user...
php artisan tinker --execute="$apps = \App\Models\JobApplication::with(['user', 'job'])->get(); foreach($apps as $app) { echo 'User: ' . $app->user->name . ' | Job: ' . $app->job->title . ' | Status: ' . $app->status . '\n'; }"

echo.
echo =========================================
echo Check completed!
echo =========================================
echo.
echo To see more details, run:
echo   php test-application-flow.php
echo.

pause
