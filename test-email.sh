#!/bin/bash

# Test Email Configuration Script for JobsIQ
# This script helps test the email notification system

echo "==================================================="
echo "JobsIQ - Email Notification Test Script"
echo "==================================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please copy .env.example to .env first."
    exit 1
fi

echo "✓ .env file found"
echo ""

# Check email configuration in .env
echo "Current email configuration:"
echo "---------------------------------------------------"
grep -E "^MAIL_" .env || echo "No MAIL_ configuration found"
echo "---------------------------------------------------"
echo ""

# Prompt user to update configuration
read -p "Do you want to set email to log mode for testing? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Update .env to use log mailer
    if grep -q "^MAIL_MAILER=" .env; then
        sed -i 's/^MAIL_MAILER=.*/MAIL_MAILER=log/' .env
        echo "✓ Updated MAIL_MAILER to log"
    else
        echo "MAIL_MAILER=log" >> .env
        echo "✓ Added MAIL_MAILER=log to .env"
    fi

    if grep -q "^MAIL_FROM_ADDRESS=" .env; then
        sed -i 's/^MAIL_FROM_ADDRESS=.*/MAIL_FROM_ADDRESS=noreply@jobsiq.com/' .env
    else
        echo "MAIL_FROM_ADDRESS=noreply@jobsiq.com" >> .env
    fi

    if grep -q "^MAIL_FROM_NAME=" .env; then
        sed -i 's/^MAIL_FROM_NAME=.*/MAIL_FROM_NAME="JobsIQ Platform"/' .env
    else
        echo 'MAIL_FROM_NAME="JobsIQ Platform"' >> .env
    fi

    echo "✓ Email configuration updated"
    echo ""
fi

# Clear configuration cache
echo "Clearing configuration cache..."
php artisan config:clear
echo "✓ Configuration cache cleared"
echo ""

# Show instructions
echo "==================================================="
echo "Testing Instructions:"
echo "==================================================="
echo ""
echo "1. Make sure you have at least one company with an email address"
echo "2. Make sure you have at least one job posted by that company"
echo "3. Submit a job application through the application"
echo "4. Check the log file for the email:"
echo ""
echo "   tail -f storage/logs/laravel.log"
echo ""
echo "5. You should see the email content in the log file"
echo ""
echo "==================================================="
echo "Optional: View Recent Logs"
echo "==================================================="
echo ""

read -p "Do you want to view the recent logs now? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ -f storage/logs/laravel.log ]; then
        echo "Showing last 50 lines of laravel.log:"
        echo "---------------------------------------------------"
        tail -n 50 storage/logs/laravel.log
        echo "---------------------------------------------------"
    else
        echo "No log file found yet. Submit an application to generate logs."
    fi
fi

echo ""
echo "✓ Email test setup complete!"
echo ""
