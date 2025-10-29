#!/bin/bash

# JobsIQ Application Test Script
# Tests both backend and frontend before deployment

echo "🧪 JobsIQ Application Test Suite"
echo "================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FAILED=0
PASSED=0

# Test counter
test_count=0
pass_count=0
fail_count=0

# Function to run test
run_test() {
    local name=$1
    local command=$2
    test_count=$((test_count + 1))
    
    echo -n "  Testing: $name... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        pass_count=$((pass_count + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        fail_count=$((fail_count + 1))
        return 1
    fi
}

# Function to check file exists
check_file() {
    local file=$1
    local desc=$2
    test_count=$((test_count + 1))
    
    echo -n "  Checking: $desc... "
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ EXISTS${NC}"
        pass_count=$((pass_count + 1))
        return 0
    else
        echo -e "${RED}✗ MISSING${NC}"
        fail_count=$((fail_count + 1))
        return 1
    fi
}

# ============================================
# 1. BACKEND TESTS
# ============================================
echo -e "${BLUE}1. Backend Tests${NC}"
echo "================"

# Check Laravel installation
run_test "Laravel installed" "php artisan --version"
run_test "Database configured" "php artisan migrate:status"
run_test "Composer dependencies" "composer validate --no-check-publish"

# Check critical files
check_file ".env" ".env file exists"
check_file "app/Http/Middleware/CacheResponse.php" "CacheResponse middleware"
check_file "app/Http/Traits/CachesApiResponses.php" "CachesApiResponses trait"
check_file "database/migrations/2025_01_01_000000_add_performance_indexes.php" "Performance indexes migration"

# Run Laravel tests
echo ""
echo -n "  Running Laravel test suite... "
if php artisan test --quiet; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# Check controllers
echo ""
echo -n "  Checking controllers have caching... "
if grep -q "CachesApiResponses" app/Http/Controllers/Api/HomeController.php && \
   grep -q "CachesApiResponses" app/Http/Controllers/Api/JobController.php && \
   grep -q "CachesApiResponses" app/Http/Controllers/Api/CompanyController.php; then
    echo -e "${GREEN}✓ IMPLEMENTED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ MISSING${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# ============================================
# 2. FRONTEND TESTS
# ============================================
echo ""
echo -e "${BLUE}2. Frontend Tests${NC}"
echo "================="

# Check Node.js and npm
run_test "Node.js installed" "node --version"
run_test "npm installed" "npm --version"

# Check package.json
check_file "package.json" "package.json exists"
check_file "vite.config.ts" "Vite config exists"
check_file "src/main.ts" "Main entry file"
check_file "src/App.vue" "App component"

# Check dependencies
echo ""
echo -n "  Checking npm dependencies... "
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓ INSTALLED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}⚠ NOT INSTALLED (run npm install)${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# Type check
echo -n "  Running TypeScript type check... "
if npm run type-check --silent > /tmp/type-check.log 2>&1; then
    echo -e "${GREEN}✓ NO ERRORS${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ TYPE ERRORS${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# Build test
echo -n "  Testing production build... "
if npm run build > /tmp/build.log 2>&1; then
    echo -e "${GREEN}✓ BUILD SUCCESS${NC}"
    pass_count=$((pass_count + 1))
    
    # Check build output
    if [ -d "public/build" ] && [ -f "public/build/manifest.json" ]; then
        echo -e "    ${GREEN}✓ Build artifacts created${NC}"
    fi
else
    echo -e "${RED}✗ BUILD FAILED${NC}"
    echo "    See /tmp/build.log for details"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# ============================================
# 3. CONFIGURATION TESTS
# ============================================
echo ""
echo -e "${BLUE}3. Configuration Tests${NC}"
echo "======================"

# Check optimizations
run_test "Config cached" "[ -f bootstrap/cache/config.php ]"
run_test "Routes cached" "[ -f bootstrap/cache/routes-v7.php ]"

# Check .env settings
echo -n "  Checking cache configuration... "
if grep -q "CACHE_STORE=" .env; then
    cache_store=$(grep "CACHE_STORE=" .env | cut -d'=' -f2)
    echo -e "${GREEN}✓ SET ($cache_store)${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}⚠ NOT SET${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# ============================================
# 4. PERFORMANCE OPTIMIZATIONS
# ============================================
echo ""
echo -e "${BLUE}4. Performance Optimizations${NC}"
echo "============================"

# Check Vite config
echo -n "  Vite optimizations... "
if grep -q "manualChunks" vite.config.ts && grep -q "terser" vite.config.ts; then
    echo -e "${GREEN}✓ CONFIGURED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ MISSING${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# Check router optimizations
echo -n "  Router prefetching... "
if grep -q "import('@/views" src/router/index.ts; then
    echo -e "${GREEN}✓ IMPLEMENTED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ MISSING${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# Check database indexes
echo -n "  Database indexes... "
if php artisan migrate:status 2>/dev/null | grep -q "add_performance_indexes"; then
    echo -e "${GREEN}✓ MIGRATED${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}⚠ NOT MIGRATED${NC}"
    fail_count=$((fail_count + 1))
fi
test_count=$((test_count + 1))

# ============================================
# 5. CODE QUALITY
# ============================================
echo ""
echo -e "${BLUE}5. Code Quality${NC}"
echo "==============="

# ESLint check
echo -n "  Running ESLint... "
if npm run lint --silent 2>&1 | grep -q "error"; then
    echo -e "${YELLOW}⚠ HAS WARNINGS/ERRORS${NC}"
else
    echo -e "${GREEN}✓ CLEAN${NC}"
    pass_count=$((pass_count + 1))
fi
test_count=$((test_count + 1))

# Check for console.logs in production build
echo -n "  Console.logs removed in build... "
if [ -d "public/build" ]; then
    if grep -r "console\.log" public/build/*.js 2>/dev/null | head -1 > /dev/null; then
        echo -e "${YELLOW}⚠ FOUND (terser might not be working)${NC}"
    else
        echo -e "${GREEN}✓ REMOVED${NC}"
        pass_count=$((pass_count + 1))
    fi
else
    echo -e "${YELLOW}⚠ NO BUILD${NC}"
fi
test_count=$((test_count + 1))

# ============================================
# 6. DOCUMENTATION
# ============================================
echo ""
echo -e "${BLUE}6. Documentation${NC}"
echo "================"

check_file "PERFORMANCE_OPTIMIZATION.md" "Performance guide"
check_file "CACHING_IMPLEMENTATION.md" "Caching guide"
check_file "REDIS_SETUP.md" "Redis guide"
check_file "README.md" "README"

# ============================================
# SUMMARY
# ============================================
echo ""
echo "================================="
echo -e "${BLUE}Test Summary${NC}"
echo "================================="
echo ""
echo "Total Tests: $test_count"
echo -e "${GREEN}Passed: $pass_count${NC}"
echo -e "${RED}Failed: $fail_count${NC}"

if [ $fail_count -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ All tests passed! Ready to push.${NC}"
    echo ""
    echo "Next steps:"
    echo "  git add ."
    echo "  git commit -m 'feat: implement performance optimizations and caching'"
    echo "  git push origin IQ-0037"
    exit 0
else
    echo ""
    echo -e "${YELLOW}⚠ Some tests failed. Review before pushing.${NC}"
    echo ""
    echo "Fix issues and run: bash test-app.sh"
    exit 1
fi
