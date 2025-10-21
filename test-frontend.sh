#!/bin/bash

# Frontend Testing Helper Script
# Usage: ./test-frontend.sh [quick|full]

echo "🧪 JobsIQ Frontend Testing"
echo "=========================="
echo ""

TEST_TYPE=${1:-full}

if [ "$TEST_TYPE" = "quick" ]; then
  echo "⚡ Running quick tests (type check only)..."
  npm run test:quick
elif [ "$TEST_TYPE" = "full" ]; then
  echo "🔍 Running full tests (type check + lint)..."
  npm run test
else
  echo "❌ Unknown test type: $TEST_TYPE"
  echo "Usage: ./test-frontend.sh [quick|full]"
  exit 1
fi

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ All tests passed!"
  exit 0
else
  echo ""
  echo "❌ Tests failed. Please fix the errors above."
  exit 1
fi
