<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CacheResponse
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, int $ttl = 3600): Response
    {
        // Only cache GET requests
        if ($request->method() !== 'GET') {
            return $next($request);
        }

        $response = $next($request);

        // Add cache headers for public routes and cacheable status codes
        // 200: OK, 301: Moved Permanently, 302: Found, 304: Not Modified
        if (in_array($response->getStatusCode(), [200, 301, 302, 304], true)) {
            $response->headers->set('Cache-Control', "public, max-age={$ttl}");
            $response->headers->set('Expires', gmdate('D, d M Y H:i:s \G\M\T', time() + $ttl));
            // Add Vary header for proper cache key differentiation
            $response->headers->set('Vary', 'Accept, Accept-Encoding');
        }

        return $response;
    }
}
