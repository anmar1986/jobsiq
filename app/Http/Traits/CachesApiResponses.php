<?php

namespace App\Http\Traits;

use Illuminate\Support\Facades\Cache;

trait CachesApiResponses
{
    /**
     * Cache the response data
     *
     * @param  int  $ttl  Time to live in seconds (default: 1 hour)
     */
    protected function cacheResponse(string $key, callable $callback, int $ttl = 3600): mixed
    {
        // In development, you might want to disable caching
        if (config('app.debug')) {
            return $callback();
        }

        return Cache::remember($key, $ttl, $callback);
    }

    /**
     * Generate a cache key for paginated results
     */
    protected function getCacheKey(string $prefix, array $params = []): string
    {
        $paramString = http_build_query($params);

        return $prefix.'_'.md5($paramString);
    }

    /**
     * Clear cache by tag or key pattern
     */
    protected function clearCache(string $pattern): void
    {
        // This works with Redis/Memcached, for file cache you'd need a different approach
        Cache::forget($pattern);
    }
}
