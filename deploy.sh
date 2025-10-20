#!/bin/bash

# Deployment script for JobsIQ
# Usage: ./deploy.sh [staging|production]

set -e

ENVIRONMENT=${1:-staging}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Deploying JobsIQ to $ENVIRONMENT..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Validate environment
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    print_error "Invalid environment. Use 'staging' or 'production'"
    exit 1
fi

# 1. Enable maintenance mode
echo "Enabling maintenance mode..."
php artisan down || true
print_success "Maintenance mode enabled"

# 2. Pull latest code
echo "Pulling latest code from Git..."
git pull origin main
print_success "Code updated"

# 3. Install/Update dependencies
echo "Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction
print_success "Composer dependencies installed"

echo "Installing NPM dependencies..."
npm ci
print_success "NPM dependencies installed"

# 4. Build frontend assets
echo "Building frontend assets..."
npm run build
print_success "Assets built"

# 5. Clear caches
echo "Clearing caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear
print_success "Caches cleared"

# 6. Run migrations
echo "Running database migrations..."
php artisan migrate --force
print_success "Migrations completed"

# 7. Optimize Laravel
echo "Optimizing Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
print_success "Laravel optimized"

# 8. Set permissions
echo "Setting permissions..."
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
print_success "Permissions set"

# 9. Restart services
echo "Restarting services..."
if command -v supervisorctl &> /dev/null; then
    supervisorctl restart all
    print_success "Supervisor restarted"
fi

# 10. Disable maintenance mode
echo "Disabling maintenance mode..."
php artisan up
print_success "Maintenance mode disabled"

# 11. Health check
echo "Running health check..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$response" == "200" ]; then
    print_success "Health check passed (HTTP $response)"
else
    print_warning "Health check returned HTTP $response"
fi

echo ""
print_success "🎉 Deployment to $ENVIRONMENT completed successfully!"
echo ""
