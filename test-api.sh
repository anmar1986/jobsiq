#!/bin/bash

# Quick API Test for Job Applications
# This script helps you test the job application endpoints

echo "========================================="
echo "JobsIQ - Application API Test"
echo "========================================="
echo ""

# Configuration
API_URL="http://localhost:8000/api"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check if server is running
echo "Checking if API server is running..."
if curl -s "$API_URL" > /dev/null 2>&1; then
    print_success "API server is running at $API_URL"
else
    print_error "API server is not running!"
    echo ""
    echo "Please start the server first:"
    echo "  php artisan serve"
    exit 1
fi

echo ""
echo "========================================="
echo "Step 1: Login to get authentication token"
echo "========================================="
echo ""

read -p "Enter your email: " USER_EMAIL
read -sp "Enter your password: " USER_PASSWORD
echo ""

LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{\"email\":\"$USER_EMAIL\",\"password\":\"$USER_PASSWORD\"}")

# Check if login was successful
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | sed 's/"token":"//')

if [ -z "$TOKEN" ]; then
    print_error "Login failed!"
    echo ""
    echo "Response:"
    echo $LOGIN_RESPONSE | python3 -m json.tool 2>/dev/null || echo $LOGIN_RESPONSE
    exit 1
fi

print_success "Login successful! Token obtained."
echo ""

# Show user info
USER_NAME=$(echo $LOGIN_RESPONSE | grep -o '"name":"[^"]*' | sed 's/"name":"//')
USER_TYPE=$(echo $LOGIN_RESPONSE | grep -o '"user_type":"[^"]*' | sed 's/"user_type":"//')

echo "Logged in as: $USER_NAME ($USER_TYPE)"
echo ""

echo "========================================="
echo "Step 2: Fetch your applications"
echo "========================================="
echo ""

APPS_RESPONSE=$(curl -s -X GET "$API_URL/my-applications" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

# Check if request was successful
SUCCESS=$(echo $APPS_RESPONSE | grep -o '"success":true')

if [ -z "$SUCCESS" ]; then
    print_error "Failed to fetch applications!"
    echo ""
    echo "Response:"
    echo $APPS_RESPONSE | python3 -m json.tool 2>/dev/null || echo $APPS_RESPONSE
else
    print_success "Applications fetched successfully!"
    echo ""
    
    # Count applications
    TOTAL=$(echo $APPS_RESPONSE | grep -o '"total":[0-9]*' | sed 's/"total"://')
    
    if [ "$TOTAL" = "0" ]; then
        print_info "You have no applications yet."
        echo ""
        echo "To submit an application, visit the job listing page and click 'Apply Now'"
    else
        print_success "You have $TOTAL application(s)"
        echo ""
        echo "Applications:"
        echo $APPS_RESPONSE | python3 -m json.tool 2>/dev/null || echo $APPS_RESPONSE
    fi
fi

echo ""
echo "========================================="
echo "Step 3: Test submitting an application"
echo "========================================="
echo ""

read -p "Do you want to test submitting an application? (yes/no): " TEST_SUBMIT

if [ "$TEST_SUBMIT" = "yes" ] || [ "$TEST_SUBMIT" = "y" ]; then
    echo ""
    
    # Get available jobs
    print_info "Fetching available jobs..."
    JOBS_RESPONSE=$(curl -s -X GET "$API_URL/jobs?per_page=5" \
      -H "Accept: application/json")
    
    # Extract first job slug
    JOB_SLUG=$(echo $JOBS_RESPONSE | grep -o '"slug":"[^"]*' | head -1 | sed 's/"slug":"//')
    JOB_TITLE=$(echo $JOBS_RESPONSE | grep -o '"title":"[^"]*' | head -1 | sed 's/"title":"//')
    
    if [ -z "$JOB_SLUG" ]; then
        print_error "No jobs available to apply to!"
        exit 1
    fi
    
    echo "Sample job found: $JOB_TITLE"
    echo "Job slug: $JOB_SLUG"
    echo ""
    
    read -p "Enter cover letter (or press Enter to skip): " COVER_LETTER
    
    if [ -z "$COVER_LETTER" ]; then
        COVER_LETTER="This is a test application submitted via API test script."
    fi
    
    echo ""
    print_info "Submitting application..."
    
    APPLY_RESPONSE=$(curl -s -X POST "$API_URL/jobs/$JOB_SLUG/apply" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -d "{\"cv_id\":null,\"cover_letter\":\"$COVER_LETTER\"}")
    
    # Check if application was successful
    APPLY_SUCCESS=$(echo $APPLY_RESPONSE | grep -o '"success":true')
    
    if [ -z "$APPLY_SUCCESS" ]; then
        print_error "Application submission failed!"
        echo ""
        echo "Response:"
        echo $APPLY_RESPONSE | python3 -m json.tool 2>/dev/null || echo $APPLY_RESPONSE
    else
        print_success "Application submitted successfully!"
        echo ""
        echo "Response:"
        echo $APPLY_RESPONSE | python3 -m json.tool 2>/dev/null || echo $APPLY_RESPONSE
        echo ""
        print_info "You can now view this application in your dashboard at /my-applications"
    fi
fi

echo ""
echo "========================================="
echo "Test completed!"
echo "========================================="
echo ""
echo "Saved token for future use:"
echo "Bearer $TOKEN"
echo ""
echo "You can use this token to test other API endpoints:"
echo ""
echo "GET  $API_URL/my-applications"
echo "GET  $API_URL/jobs/{slug}/check-application"
echo "POST $API_URL/jobs/{slug}/apply"
echo ""
