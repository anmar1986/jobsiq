<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\BlogController;
use App\Http\Controllers\Api\CompanyController;
use App\Http\Controllers\Api\FreeCvController;
use App\Http\Controllers\Api\HomeController;
use App\Http\Controllers\Api\JobController;
use App\Http\Controllers\Api\UserCvController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Authentication routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Home page routes
Route::get('/home', [HomeController::class, 'index']);
Route::get('/home/{section}', [HomeController::class, 'getSection']);

// Public routes
Route::get('/jobs', [JobController::class, 'index']);
Route::get('/jobs/featured', [JobController::class, 'featured']);
Route::get('/jobs/{job}', [JobController::class, 'show']);

Route::get('/companies', [CompanyController::class, 'index']);
Route::get('/companies/{company}', [CompanyController::class, 'show']);

// Public CV routes (for companies to view public CVs)
Route::get('/cvs', [FreeCvController::class, 'index']);
Route::get('/cvs/{slug}', [FreeCvController::class, 'show']);

// Blog routes - public access but Auth will work if token is provided
Route::get('/blogs', [BlogController::class, 'index']);
Route::get('/blogs/categories', [BlogController::class, 'categories']);
Route::get('/blogs/featured', [BlogController::class, 'featured']);
Route::get('/blogs/{slug}', [BlogController::class, 'show']);

// Authenticated routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth user routes
    Route::get('/user', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/logout-all', [AuthController::class, 'logoutAll']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::put('/change-password', [AuthController::class, 'changePassword']);

    // Job management
    Route::post('/jobs', [JobController::class, 'store']);
    Route::put('/jobs/{job}', [JobController::class, 'update']);
    Route::delete('/jobs/{job}', [JobController::class, 'destroy']);

    // Company management
    Route::post('/companies', [CompanyController::class, 'store']);
    Route::put('/companies/{company}', [CompanyController::class, 'update']);
    Route::delete('/companies/{company}', [CompanyController::class, 'destroy']);

    // Company ownership
    Route::get('/my-companies', [CompanyController::class, 'myCompanies']);
    Route::post('/companies/{company}/owners', [CompanyController::class, 'addOwner']);
    Route::delete('/companies/{company}/owners/{userId}', [CompanyController::class, 'removeOwner']);

    // Blog management routes (require authentication)
    Route::get('/blogs/by-id/{id}', [BlogController::class, 'showById']);
    Route::post('/blogs', [BlogController::class, 'store']);
    Route::post('/blogs/upload-image', [BlogController::class, 'uploadImage']);
    Route::put('/blogs/{id}', [BlogController::class, 'update']);
    Route::delete('/blogs/{id}', [BlogController::class, 'destroy']);

    // User CV management
    Route::get('/my-cvs', [UserCvController::class, 'myCvs']);
    Route::post('/my-cvs', [UserCvController::class, 'store']);
    Route::get('/my-cvs/{id}', [UserCvController::class, 'show']);
    Route::post('/my-cvs/{id}', [UserCvController::class, 'update']);
    Route::delete('/my-cvs/{id}', [UserCvController::class, 'destroy']);
    Route::post('/my-cvs/{id}/primary', [UserCvController::class, 'setPrimary']);
});
