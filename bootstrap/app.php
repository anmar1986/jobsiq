<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Register optional authentication middleware
        $middleware->alias([
            'optional.auth' => \App\Http\Middleware\OptionalAuthentication::class,
            'admin' => \App\Http\Middleware\IsAdmin::class,
        ]);

        // Apply Content Security Policy to all web requests
        $middleware->web(append: [
            \App\Http\Middleware\ContentSecurityPolicy::class,
        ]);

        // Configure API authentication to return JSON instead of redirecting
        $middleware->redirectGuestsTo(function (Request $request) {
            if ($request->expectsJson() || $request->is('api/*')) {
                abort(Response::HTTP_UNAUTHORIZED, 'Unauthenticated.');
            }

            return route('login');
        });
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Handle database query exceptions
        $exceptions->render(function (\Illuminate\Database\QueryException $e, Request $request) {
            if ($request->expectsJson() || $request->is('api/*')) {
                \Illuminate\Support\Facades\Log::error('Database error: '.$e->getMessage());

                // Extract meaningful error message
                $message = 'An error occurred while processing your request';

                // Handle specific SQL errors
                if (str_contains($e->getMessage(), 'Data truncated')) {
                    $message = 'Invalid data provided. Please check your input fields and try again';
                } elseif (str_contains($e->getMessage(), 'Duplicate entry')) {
                    $message = 'This record already exists in the database';
                } elseif (str_contains($e->getMessage(), 'foreign key constraint')) {
                    $message = 'Cannot complete this action due to related records';
                } elseif (str_contains($e->getMessage(), 'doesn\'t have a default value')) {
                    $message = 'Some required fields are missing. Please fill all required fields';
                }

                return response()->json([
                    'success' => false,
                    'message' => $message,
                ], 422);
            }
        });

        // Handle validation exceptions with better formatting
        $exceptions->render(function (\Illuminate\Validation\ValidationException $e, Request $request) {
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json([
                    'success' => false,
                    'message' => 'Validation failed. Please check your input',
                    'errors' => $e->errors(),
                ], 422);
            }
        });
    })->create();
