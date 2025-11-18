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

                // Handle specific SQL errors using error codes
                // See: https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html
                $errorCode = $e->errorInfo[1] ?? null;

                switch ($errorCode) {
                    case 1406: // Data too long for column
                    case 1264: // Out of range value
                        $message = 'Invalid data provided. Please check your input fields and try again';
                        break;
                    case 1062: // Duplicate entry
                        $message = 'This record already exists in the database';
                        break;
                    case 1451: // Cannot delete or update a parent row: a foreign key constraint fails
                    case 1452: // Cannot add or update a child row: a foreign key constraint fails
                        $message = 'Cannot complete this action due to related records';
                        break;
                    case 1364: // Field doesn't have a default value
                        $message = 'Some required fields are missing. Please fill all required fields';
                        break;
                    default:
                        // Fallback to message matching for unsupported codes
                        if (str_contains($e->getMessage(), 'Data truncated')) {
                            $message = 'Invalid data provided. Please check your input fields and try again';
                        }
                        break;
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
