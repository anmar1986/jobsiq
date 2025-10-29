<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
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
                // Silently fail - optional authentication
            }
        }

        return $next($request);
    }
}
