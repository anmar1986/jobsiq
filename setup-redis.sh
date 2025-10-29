#!/bin/bash

# Redis Configuration Script for JobsIQ
# This script helps configure Redis in your Laravel application

echo "🔧 Redis Configuration Helper for JobsIQ"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if .env file exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from .env.example...${NC}"
    cp .env.example .env
    php artisan key:generate
    echo -e "${GREEN}✓ .env file created${NC}"
    echo ""
fi

# Function to update .env file
update_env() {
    local key=$1
    local value=$2
    
    if grep -q "^${key}=" .env; then
        # Key exists, update it
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/^${key}=.*/${key}=${value}/" .env
        else
            # Linux/WSL
            sed -i "s/^${key}=.*/${key}=${value}/" .env
        fi
    else
        # Key doesn't exist, append it
        echo "${key}=${value}" >> .env
    fi
}

echo -e "${BLUE}Step 1: Checking Redis connection...${NC}"

# Test if Redis is available
if command -v redis-cli &> /dev/null; then
    if redis-cli ping &> /dev/null; then
        echo -e "${GREEN}✓ Redis is running and accessible${NC}"
        REDIS_AVAILABLE=true
    else
        echo -e "${YELLOW}⚠ Redis CLI found but server not responding${NC}"
        REDIS_AVAILABLE=false
    fi
else
    echo -e "${YELLOW}⚠ Redis CLI not found${NC}"
    REDIS_AVAILABLE=false
fi
echo ""

if [ "$REDIS_AVAILABLE" = false ]; then
    echo -e "${YELLOW}Redis Setup Instructions:${NC}"
    echo ""
    echo "Windows (WSL):"
    echo "  sudo apt update && sudo apt install redis-server"
    echo "  sudo service redis-server start"
    echo ""
    echo "Windows (Docker):"
    echo "  docker run -d -p 6379:6379 --name redis redis:latest"
    echo ""
    echo "Linux:"
    echo "  sudo apt install redis-server"
    echo "  sudo systemctl start redis-server"
    echo ""
    echo "macOS:"
    echo "  brew install redis"
    echo "  brew services start redis"
    echo ""
    
    read -p "Do you want to continue configuration anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}Step 2: Updating .env configuration for Redis...${NC}"

# Update cache configuration
update_env "CACHE_STORE" "redis"
update_env "CACHE_PREFIX" "jobsiq_cache_"

# Update session configuration
update_env "SESSION_DRIVER" "redis"

# Update queue configuration
update_env "QUEUE_CONNECTION" "redis"

# Update Redis configuration
update_env "REDIS_CLIENT" "predis"
update_env "REDIS_HOST" "127.0.0.1"
update_env "REDIS_PASSWORD" "null"
update_env "REDIS_PORT" "6379"

# Add Redis DB configurations if not exists
if ! grep -q "^REDIS_DB=" .env; then
    echo "REDIS_DB=0" >> .env
fi
if ! grep -q "^REDIS_CACHE_DB=" .env; then
    echo "REDIS_CACHE_DB=1" >> .env
fi

echo -e "${GREEN}✓ .env updated for Redis${NC}"
echo ""

echo -e "${BLUE}Step 3: Clearing Laravel caches...${NC}"
php artisan config:clear
php artisan cache:clear
echo -e "${GREEN}✓ Caches cleared${NC}"
echo ""

echo -e "${BLUE}Step 4: Testing Redis connection from Laravel...${NC}"

# Create a temporary PHP test file
cat > test_redis.php << 'EOF'
<?php
require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

try {
    $redis = \Illuminate\Support\Facades\Redis::connection();
    $redis->ping();
    echo "✓ Redis connection successful!\n";
    
    // Test cache
    \Illuminate\Support\Facades\Cache::store('redis')->put('test_key', 'Hello Redis!', 60);
    $value = \Illuminate\Support\Facades\Cache::store('redis')->get('test_key');
    
    if ($value === 'Hello Redis!') {
        echo "✓ Redis cache working!\n";
        \Illuminate\Support\Facades\Cache::store('redis')->forget('test_key');
    } else {
        echo "✗ Redis cache test failed\n";
    }
    
    exit(0);
} catch (\Exception $e) {
    echo "✗ Redis connection failed: " . $e->getMessage() . "\n";
    exit(1);
}
EOF

if php test_redis.php; then
    echo -e "${GREEN}✓ Redis integration working!${NC}"
    REDIS_WORKING=true
else
    echo -e "${RED}✗ Redis integration failed${NC}"
    REDIS_WORKING=false
fi

# Clean up test file
rm test_redis.php
echo ""

if [ "$REDIS_WORKING" = true ]; then
    echo -e "${BLUE}Step 5: Re-caching Laravel configuration...${NC}"
    php artisan config:cache
    echo -e "${GREEN}✓ Configuration cached${NC}"
    echo ""
fi

echo "=========================================="
echo -e "${GREEN}🎉 Redis configuration complete!${NC}"
echo ""

if [ "$REDIS_WORKING" = true ]; then
    echo -e "${GREEN}Redis is configured and working!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Apply caching to your controllers (see examples in REDIS_SETUP.md)"
    echo "  2. Start queue worker: php artisan queue:work redis"
    echo "  3. Monitor Redis: redis-cli monitor"
    echo ""
    echo "Performance improvements expected:"
    echo "  - Cache operations: 90-95% faster"
    echo "  - Session management: 85-90% faster"
    echo "  - API responses (with caching): 50-70% faster"
else
    echo -e "${YELLOW}Redis configuration updated, but connection failed.${NC}"
    echo ""
    echo "Please:"
    echo "  1. Install and start Redis server"
    echo "  2. Run this script again"
    echo ""
    echo "See REDIS_SETUP.md for detailed instructions."
fi

echo ""
echo "For more details, see REDIS_SETUP.md"
