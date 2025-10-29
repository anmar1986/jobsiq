<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

class OptionalAuthentication
{
    /**
     * Handle an incoming request.
     * Authenticates the user if a token is present, but doesn't fail if not.
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Try to authenticate using Sanctum if token is present
        if ($request->bearerToken()) {
            try {
                $user = Auth::guard('sanctum')->user();
                if ($user) {
                    Auth::setUser($user);
                }
            } catch (\Exception $e) {
                // Log authentication errors for debugging while allowing request to proceed
                Log::warning('Optional authentication failed', [
                    'error' => $e->getMessage(),
                    'token_prefix' => substr($request->bearerToken(), 0, 10).'...',
                    'ip' => $request->ip(),
                    'url' => $request->fullUrl(),
                ]);
            }
        }

        return $next($request);
    }
}
