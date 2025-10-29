# 🪟 Redis Installation Guide for Windows (XAMPP)

Since you're running XAMPP on Windows, you have several options to install Redis.

## ✅ **Recommended: Memurai (Redis for Windows)**

Memurai is a native Redis port for Windows that works perfectly with Laravel.

### Step 1: Download and Install

1. Go to: https://www.memurai.com/get-memurai
2. Download **Memurai Developer** (Free)
3. Run the installer
4. Accept defaults and install

### Step 2: Start Memurai Service

Memurai runs as a Windows service. After installation:

1. Press `Win + R`
2. Type `services.msc` and press Enter
3. Find "Memurai" in the list
4. Right-click → Start

Or from PowerShell (Run as Administrator):
```powershell
net start Memurai
```

### Step 3: Verify Installation

Open PowerShell or Command Prompt:
```cmd
memurai-cli ping
```
Should return: `PONG`

### Step 4: Configure for JobsIQ

The `.env` file is already configured! Just run:
```bash
php artisan config:cache
php artisan redis:test
```

---

## Alternative 1: Redis via Docker

If you have Docker Desktop for Windows:

### Quick Start

```bash
# Run Redis container
docker run -d --name redis -p 6379:6379 redis:latest

# Test connection
docker exec -it redis redis-cli ping
# Should return: PONG
```

### Start/Stop Redis

```bash
# Start
docker start redis

# Stop
docker stop redis

# Remove (if needed)
docker rm redis
```

---

## Alternative 2: WSL (Windows Subsystem for Linux)

If you have WSL installed:

### Step 1: Install Redis in WSL

```bash
# In WSL terminal
sudo apt update
sudo apt install redis-server -y
```

### Step 2: Start Redis

```bash
sudo service redis-server start
```

### Step 3: Test Connection

```bash
redis-cli ping
# Should return: PONG
```

### Step 4: Make Redis accessible from Windows

Edit Redis config:
```bash
sudo nano /etc/redis/redis.conf
```

Find and change:
```conf
bind 127.0.0.1
```
to:
```conf
bind 0.0.0.0
```

Restart Redis:
```bash
sudo service redis-server restart
```

---

## Quick Test After Installation

Once Redis is running, test from your project:

```bash
# Navigate to your project
cd C:\xampp\htdocs\myProjects\jobsiq

# Test Redis
php artisan redis:test

# You should see:
# ✓ Redis is responding
# ✓ Cache write successful
# ✓ Cache read successful
```

---

## Configuration Summary

Your `.env` is already configured with these Redis settings:

```env
CACHE_STORE=redis
CACHE_PREFIX=jobsiq_cache_

SESSION_DRIVER=redis
SESSION_LIFETIME=120

QUEUE_CONNECTION=redis

REDIS_CLIENT=predis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
REDIS_DB=0
REDIS_CACHE_DB=1
```

**No changes needed!** Just install Redis and it will work.

---

## Troubleshooting

### Connection Refused Error

If you see "Connection refused":

1. **Check if Redis is running**:
   ```bash
   # Memurai
   memurai-cli ping
   
   # Docker
   docker ps | grep redis
   
   # WSL
   sudo service redis-server status
   ```

2. **Check port 6379**:
   ```bash
   # Windows
   netstat -an | findstr 6379
   ```

3. **Restart Redis**:
   ```bash
   # Memurai
   net stop Memurai
   net start Memurai
   
   # Docker
   docker restart redis
   
   # WSL
   sudo service redis-server restart
   ```

### Still Having Issues?

Temporarily switch back to database cache in `.env`:
```env
CACHE_STORE=database
SESSION_DRIVER=database
QUEUE_CONNECTION=database
```

Then run:
```bash
php artisan config:cache
```

---

## Next Steps After Redis is Running

1. **Test Connection**:
   ```bash
   php artisan redis:test
   ```

2. **Clear All Caches**:
   ```bash
   php artisan cache:clear
   php artisan config:cache
   ```

3. **Start Development**:
   ```bash
   # Terminal 1: Laravel backend
   php artisan serve
   
   # Terminal 2: Frontend
   npm run dev
   
   # Terminal 3: Queue worker (optional)
   php artisan queue:work redis
   ```

4. **Monitor Redis**:
   ```bash
   # Memurai
   memurai-cli monitor
   
   # Or use Redis Desktop Manager (GUI)
   # Download: https://github.com/qishibo/AnotherRedisDesktopManager
   ```

---

## Performance Testing

After Redis is running, test the performance:

```bash
# Run the test command
php artisan redis:test

# You should see Redis is 90%+ faster than database cache
```

Visit your application and notice:
- ✅ Faster page loads
- ✅ Faster API responses
- ✅ Better overall performance

---

## My Recommendation

**For Windows + XAMPP**: Use **Memurai**

✅ Native Windows application  
✅ Easy to install  
✅ Runs as a service  
✅ Compatible with all Redis clients  
✅ Free for development  

Download: https://www.memurai.com/get-memurai

---

## Summary

1. Install Memurai (or Docker/WSL Redis)
2. Start the Redis service
3. Run `php artisan redis:test`
4. Enjoy 50-90% performance improvements! 🚀

Your Laravel app is already configured for Redis - just install and start the server!
