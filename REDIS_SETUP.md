# 🚀 Redis Setup Guide for JobsIQ

## Overview
This guide will help you set up Redis for caching, sessions, and queues in your JobsIQ application.

---

## Step 1: Install Redis Server

### Windows (XAMPP)

#### Option A: Using Memurai (Redis for Windows)
1. Download Memurai from: https://www.memurai.com/
2. Install and start the service
3. Default port: 6379

#### Option B: Using Redis via WSL (Recommended)
```bash
# In WSL terminal
sudo apt update
sudo apt install redis-server
sudo service redis-server start

# Test Redis
redis-cli ping
# Should return: PONG
```

#### Option C: Using Docker
```bash
docker run -d -p 6379:6379 --name redis redis:latest
```

### Linux/Mac
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server

# macOS
brew install redis
brew services start redis

# Test Redis
redis-cli ping
# Should return: PONG
```

---

## Step 2: Configure Laravel for Redis

### Update .env file

Replace these values in your `.env` file:

```env
# Cache Configuration
CACHE_STORE=redis
CACHE_PREFIX=jobsiq_cache_

# Session Configuration
SESSION_DRIVER=redis
SESSION_LIFETIME=120

# Queue Configuration
QUEUE_CONNECTION=redis

# Redis Configuration
REDIS_CLIENT=predis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
REDIS_DB=0
REDIS_CACHE_DB=1
```

**Note**: If using phpredis extension instead of predis, set:
```env
REDIS_CLIENT=phpredis
```

---

## Step 3: Verify Redis Connection

```bash
# Test Redis connection
php artisan tinker

# In tinker, run:
Cache::store('redis')->put('test', 'Hello Redis!', 60);
Cache::store('redis')->get('test');
# Should return: "Hello Redis!"

# Exit tinker
exit
```

---

## Step 4: Create Queue Tables (if using database fallback)

```bash
php artisan queue:table
php artisan migrate
```

---

## Step 5: Start Queue Worker

In production, you'll need to run queue workers:

```bash
# Development - single worker
php artisan queue:work redis

# Production - use supervisor or similar
php artisan queue:work redis --daemon --tries=3
```

---

## Performance Benefits

With Redis enabled, you'll see:

- **Cache Operations**: 50-100x faster than database cache
- **Session Management**: 30-50% faster user sessions
- **Queue Processing**: Near-instant job queuing
- **API Response Time**: 50-70% improvement with caching

---

## Testing Redis Performance

### Test 1: Cache Performance
```bash
php artisan tinker

# Test database cache
Cache::store('database')->put('test', 'value', 60);
# Time this operation

# Test Redis cache
Cache::store('redis')->put('test', 'value', 60);
# Much faster!
```

### Test 2: API Response Caching
```bash
# Without cache - check response time
curl http://localhost:8000/api/jobs

# With cache - much faster on subsequent requests
```

---

## Redis Commands

```bash
# Connect to Redis CLI
redis-cli

# Check all keys
KEYS *

# Get specific key
GET jobsiq_cache_:jobs_list

# Clear all cache
FLUSHDB

# Monitor Redis operations
MONITOR

# Check Redis info
INFO

# Exit
exit
```

---

## Troubleshooting

### Redis connection refused
```bash
# Check if Redis is running
redis-cli ping

# Start Redis (Linux)
sudo service redis-server start

# Start Redis (Mac)
brew services start redis

# Start Redis (Docker)
docker start redis
```

### Permission denied
```bash
# Check Redis logs
sudo tail -f /var/log/redis/redis-server.log
```

### Port already in use
```bash
# Check what's using port 6379
netstat -an | grep 6379

# Or use different port in .env
REDIS_PORT=6380
```

---

## Production Configuration

### Optimize Redis for Production

Edit Redis config (`/etc/redis/redis.conf`):

```conf
# Persistence
save 900 1
save 300 10
save 60 10000

# Max memory
maxmemory 256mb
maxmemory-policy allkeys-lru

# Performance
tcp-backlog 511
timeout 300
tcp-keepalive 300
```

### Secure Redis

```conf
# Bind to localhost only
bind 127.0.0.1

# Set password
requirepass your_strong_password_here
```

Update `.env`:
```env
REDIS_PASSWORD=your_strong_password_here
```

---

## Monitoring Redis

### Install Redis Commander (GUI)
```bash
npm install -g redis-commander
redis-commander

# Access at: http://localhost:8081
```

### Laravel Telescope
```bash
composer require laravel/telescope
php artisan telescope:install
php artisan migrate

# Access at: http://localhost:8000/telescope
```

---

## Cache Strategies

### Clear Cache Commands

```bash
# Clear application cache
php artisan cache:clear

# Clear config cache
php artisan config:clear

# Clear route cache
php artisan route:clear

# Clear view cache
php artisan view:clear

# Clear all
php artisan optimize:clear
```

### Selective Cache Clearing

```php
// Clear specific cache keys
Cache::forget('jobs_list');
Cache::forget('companies_list');

// Clear cache by tag (Redis only)
Cache::tags(['jobs'])->flush();
```

---

## Next Steps

1. ✅ Install Redis server
2. ✅ Update `.env` configuration
3. ✅ Test Redis connection
4. ✅ Apply caching to controllers (see examples below)
5. ✅ Start queue worker
6. ✅ Monitor performance

---

## Example: Implementing Cache in Controllers

### JobController with Redis

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\CachesApiResponses;
use App\Models\Job;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;

class JobController extends Controller
{
    use CachesApiResponses;

    public function index(Request $request)
    {
        $cacheKey = $this->getCacheKey('jobs_list', $request->all());
        
        return $this->cacheResponse($cacheKey, function() use ($request) {
            return Job::with(['company:id,name,slug', 'company.logo'])
                ->where('is_active', true)
                ->latest('published_at')
                ->paginate(20);
        }, 300); // 5 minutes cache
    }

    public function show(string $slug)
    {
        $cacheKey = "job_detail_{$slug}";
        
        return $this->cacheResponse($cacheKey, function() use ($slug) {
            return Job::with(['company', 'company.logo'])
                ->where('slug', $slug)
                ->firstOrFail();
        }, 600); // 10 minutes cache
    }

    // Clear cache when job is updated
    public function update(Request $request, Job $job)
    {
        $job->update($request->validated());
        
        // Clear related caches
        Cache::forget("job_detail_{$job->slug}");
        Cache::forget('jobs_list_*'); // Clear all job list caches
        
        return response()->json($job);
    }
}
```

---

## Performance Metrics

### Expected Improvements with Redis

| Metric | Before (Database) | After (Redis) | Improvement |
|--------|------------------|---------------|-------------|
| Cache Write | 10-50ms | 1-2ms | **90% faster** |
| Cache Read | 5-20ms | 0.1-0.5ms | **95% faster** |
| Session Load | 20-50ms | 1-3ms | **90% faster** |
| Queue Push | 50-100ms | 1-5ms | **95% faster** |
| API Response (cached) | 200-500ms | 10-50ms | **85% faster** |

---

## Resources

- Redis Documentation: https://redis.io/documentation
- Laravel Redis: https://laravel.com/docs/11.x/redis
- Predis Documentation: https://github.com/predis/predis
- Performance Tips: https://redis.io/topics/optimization

---

**Your application is now ready to use Redis!** 🚀

For questions, refer to the troubleshooting section or Laravel documentation.
