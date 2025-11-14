<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class ContentSecurityPolicy
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        // Check if CSP is enabled
        if (! config('csp.enabled', true)) {
            return $response;
        }

        // Only apply CSP to HTML responses
        if (str_contains($response->headers->get('Content-Type', ''), 'text/html')) {
            $csp = $this->getContentSecurityPolicy();
            $response->headers->set('Content-Security-Policy', $csp);
        }

        return $response;
    }

    /**
     * Get the Content Security Policy based on environment
     */
    private function getContentSecurityPolicy(): string
    {
        $isDevelopment = config('app.debug');
        $policy = config($isDevelopment ? 'csp.development' : 'csp.production', []);

        $directives = [];
        foreach ($policy as $directive => $value) {
            if ($value === '') {
                $directives[] = $directive;
            } else {
                $directives[] = "$directive $value";
            }
        }

        return implode('; ', $directives);
    }
}
