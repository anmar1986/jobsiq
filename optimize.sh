#!/bin/bash

# JobsIQ Performance Optimization Script
# This script applies immediate performance improvements

echo "🚀 JobsIQ Performance Optimization Script"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Step 1: Clearing Laravel caches...${NC}"
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
echo -e "${GREEN}✓ Caches cleared${NC}"
echo ""

echo -e "${YELLOW}Step 2: Optimizing Laravel for production...${NC}"
php artisan config:cache
php artisan route:cache
php artisan view:cache
echo -e "${GREEN}✓ Laravel optimized${NC}"
echo ""

echo -e "${YELLOW}Step 3: Optimizing Composer autoloader...${NC}"
composer dump-autoload -o
echo -e "${GREEN}✓ Autoloader optimized${NC}"
echo ""

echo -e "${YELLOW}Step 4: Building frontend assets...${NC}"
npm run build
echo -e "${GREEN}✓ Frontend assets built${NC}"
echo ""

echo -e "${YELLOW}Step 5: Setting proper permissions...${NC}"
chmod -R 775 storage bootstrap/cache
echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

echo "=========================================="
echo -e "${GREEN}🎉 Performance optimization complete!${NC}"
echo ""
echo "Additional recommendations:"
echo "  1. Enable OPcache in php.ini"
echo "  2. Consider using Redis for caching"
echo "  3. Add database indexes for frequently queried columns"
echo "  4. Enable Gzip compression in your web server"
echo "  5. Use a CDN for static assets"
echo ""
echo "For more details, see PERFORMANCE_OPTIMIZATION.md"
