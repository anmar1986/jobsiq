<?php

use App\Http\Controllers\Api\Admin\CompanyAdminController;
use App\Http\Controllers\Api\Admin\CvAdminController;
use App\Http\Controllers\Api\Admin\DashboardController;
use App\Http\Controllers\Api\Admin\JobAdminController;
use App\Http\Controllers\Api\Admin\JobApplicationAdminController;
use App\Http\Controllers\Api\Admin\SearchHistoryAdminController;
use App\Http\Controllers\Api\Admin\UserController as AdminUserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CompanyController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\JobApplicationController;
use App\Http\Controllers\Api\JobController;
use App\Http\Controllers\Api\SavedJobController;
use App\Http\Controllers\Api\UserCvController;
use App\Http\Middleware\CacheResponse;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Authentication routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

// Home page routes - cached for 5 minutes
Route::middleware([CacheResponse::class.':300'])->group(function () {
    Route::get('/home', [HomeController::class, 'index']);
    Route::get('/home/{section}', [HomeController::class, 'getSection']);
});

// Public routes with caching (3 minutes for lists, 10 minutes for details)
Route::middleware([CacheResponse::class.':180'])->group(function () {
    Route::middleware('optional.auth')->get('/jobs', [JobController::class, 'index']);
    Route::get('/jobs/featured', [JobController::class, 'featured']);
});

Route::middleware([CacheResponse::class.':600'])->group(function () {
    Route::middleware('optional.auth')->get('/jobs/{job:slug}', [JobController::class, 'show']);
});

Route::middleware([CacheResponse::class.':180'])->group(function () {
    Route::get('/companies', [CompanyController::class, 'index']);
});

Route::middleware([CacheResponse::class.':600'])->group(function () {
    Route::get('/companies/{slug}', [CompanyController::class, 'showBySlug'])->where('slug', '[a-z0-9-]+');
});

// Authenticated routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth user routes
    Route::get('/user', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/logout-all', [AuthController::class, 'logoutAll']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::post('/profile', [AuthController::class, 'updateProfile']); // For file uploads
    Route::delete('/profile', [AuthController::class, 'deleteProfile']);
    Route::put('/change-password', [AuthController::class, 'changePassword']);

    // Job management
    Route::get('/my-jobs', [JobController::class, 'myJobs']); // Get all jobs posted by user
    Route::get('/my-jobs/{job}', [JobController::class, 'show']); // Get owned job by ID
    Route::post('/jobs', [JobController::class, 'store']);
    Route::put('/jobs/{job:id}', [JobController::class, 'update']);
    Route::delete('/jobs/{jobId}', [JobController::class, 'destroy']);

    // Company management
    Route::get('/my-companies/slug/{slug}', [CompanyController::class, 'showMyCompanyBySlug']); // Get owned company by slug
    Route::get('/my-companies/{company}', [CompanyController::class, 'show']); // Get owned company by ID (fallback)
    Route::post('/companies', [CompanyController::class, 'store']);
    Route::put('/companies/{company:id}', [CompanyController::class, 'update']);
    Route::post('/companies/{company:id}', [CompanyController::class, 'update']); // Support POST for file uploads
    Route::delete('/companies/{company:id}', [CompanyController::class, 'destroy']);

    // Company ownership
    Route::get('/my-companies', [CompanyController::class, 'myCompanies']);
    Route::post('/companies/{company:id}/owners', [CompanyController::class, 'addOwner']);
    Route::delete('/companies/{company:id}/owners/{userId}', [CompanyController::class, 'removeOwner']);

    // User CV management
    Route::get('/my-cvs', [UserCvController::class, 'myCvs']);
    Route::post('/my-cvs', [UserCvController::class, 'store']);
    Route::get('/my-cvs/{id}', [UserCvController::class, 'show']);
    Route::post('/my-cvs/{id}', [UserCvController::class, 'update']);
    Route::delete('/my-cvs/{id}', [UserCvController::class, 'destroy']);
    Route::post('/my-cvs/{id}/primary', [UserCvController::class, 'setPrimary']);

    // Job Application management
    Route::get('/my-applications', [JobApplicationController::class, 'index']);
    Route::post('/jobs/{job:slug}/apply', [JobApplicationController::class, 'store']);
    Route::get('/jobs/{job:slug}/check-application', [JobApplicationController::class, 'checkApplication']);
    Route::get('/applications/{application}', [JobApplicationController::class, 'show']);
    Route::put('/applications/{application}/status', [JobApplicationController::class, 'updateStatus']);
    Route::delete('/applications/{application}', [JobApplicationController::class, 'destroy']);

    // Saved Jobs management
    Route::get('/saved-jobs', [SavedJobController::class, 'index']);
    Route::post('/jobs/{job}/save', [SavedJobController::class, 'store']);
    Route::delete('/jobs/{job}/save', [SavedJobController::class, 'destroy']);
    Route::get('/jobs/{job}/saved', [SavedJobController::class, 'check']);
});

/*
|--------------------------------------------------------------------------
| Admin API Routes
|--------------------------------------------------------------------------
|
| These routes are protected by the 'auth:sanctum' and 'admin' middleware.
| Only users with is_admin = true can access these endpoints.
|
*/

Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index']);

    // User Management
    Route::get('/users', [AdminUserController::class, 'index']);
    Route::post('/users', [AdminUserController::class, 'store']);
    Route::get('/users/statistics', [AdminUserController::class, 'statistics']);
    Route::get('/users/{user}', [AdminUserController::class, 'show']);
    Route::put('/users/{user}', [AdminUserController::class, 'update']);
    Route::delete('/users/{user}', [AdminUserController::class, 'destroy']);

    // Company Management
    Route::get('/companies', [CompanyAdminController::class, 'index']);
    Route::post('/companies', [CompanyAdminController::class, 'store']);
    Route::get('/companies/statistics', [CompanyAdminController::class, 'statistics']);
    Route::get('/companies/{company}', [CompanyAdminController::class, 'show']);
    Route::put('/companies/{company}', [CompanyAdminController::class, 'update']);
    Route::delete('/companies/{company}', [CompanyAdminController::class, 'destroy']);

    // Job Management
    Route::get('/jobs', [JobAdminController::class, 'index']);
    Route::post('/jobs', [JobAdminController::class, 'store']);
    Route::get('/jobs/statistics', [JobAdminController::class, 'statistics']);
    Route::get('/jobs/{job}', [JobAdminController::class, 'show']);
    Route::put('/jobs/{job}', [JobAdminController::class, 'update']);
    Route::delete('/jobs/{job}', [JobAdminController::class, 'destroy']);
    Route::post('/jobs/{job}/toggle-featured', [JobAdminController::class, 'toggleFeatured']);

    // Job Application Management
    Route::get('/applications', [JobApplicationAdminController::class, 'index']);
    Route::get('/applications/statistics', [JobApplicationAdminController::class, 'statistics']);
    Route::get('/applications/{application}', [JobApplicationAdminController::class, 'show']);
    Route::put('/applications/{application}/status', [JobApplicationAdminController::class, 'updateStatus']);
    Route::delete('/applications/{application}', [JobApplicationAdminController::class, 'destroy']);

    // CV Management
    Route::get('/cvs', [CvAdminController::class, 'index']);
    Route::get('/cvs/statistics', [CvAdminController::class, 'statistics']);
    Route::get('/cvs/{identifier}', [CvAdminController::class, 'show']);
    Route::delete('/cvs/{id}', [CvAdminController::class, 'destroy']);
    Route::post('/cvs/{id}/toggle-visibility', [CvAdminController::class, 'toggleVisibility']);

    // Search History Management
    Route::get('/search-history', [SearchHistoryAdminController::class, 'index']);
    Route::get('/search-history/statistics', [SearchHistoryAdminController::class, 'statistics']);
    Route::delete('/search-history/{searchHistory}', [SearchHistoryAdminController::class, 'destroy']);
    Route::delete('/search-history/clear', [SearchHistoryAdminController::class, 'clear']);
});
