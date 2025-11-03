# Email Configuration Guide for JobsIQ

## Overview
This document explains how to configure email notifications for job applications in JobsIQ.

## What Was Implemented

When a job seeker submits an application, the system now automatically sends an email notification to the company's registered email address.

### Email Features:
- **Professional design** with JobsIQ branding
- **Company-specific greeting** (Dear [Company Name])
- **Application details** including:
  - Job position
  - Applicant name
  - Application date/time
  - CV and cover letter status
- **CTA button** that links directly to the job seeker's profile
- **Responsive HTML design**

## Email Configuration

### For Development (Testing)

Add these lines to your `.env` file:

```env
# Email Configuration
MAIL_MAILER=log
MAIL_FROM_ADDRESS=noreply@jobsiq.com
MAIL_FROM_NAME="JobsIQ Platform"
```

With `MAIL_MAILER=log`, emails will be saved to `storage/logs/laravel.log` instead of being sent. This is perfect for testing.

### For Production (Real Emails)

#### Option 1: Using Gmail SMTP

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-specific-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@jobsiq.com
MAIL_FROM_NAME="JobsIQ Platform"
```

**Note:** For Gmail, you need to create an "App Password" from your Google Account settings.

#### Option 2: Using Mailtrap (Testing)

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your-mailtrap-username
MAIL_PASSWORD=your-mailtrap-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@jobsiq.com
MAIL_FROM_NAME="JobsIQ Platform"
```

#### Option 3: Using Amazon SES

```env
MAIL_MAILER=ses
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_DEFAULT_REGION=us-east-1
MAIL_FROM_ADDRESS=noreply@jobsiq.com
MAIL_FROM_NAME="JobsIQ Platform"
```

## How to Test

### 1. Check Email Logs (Development Mode)

When using `MAIL_MAILER=log`, submit a job application and then check:

```bash
tail -f storage/logs/laravel.log
```

You should see the email content logged there.

### 2. Using Mailtrap

1. Sign up for free at https://mailtrap.io
2. Get your SMTP credentials
3. Update your `.env` file
4. Submit a job application
5. Check your Mailtrap inbox to see the email

### 3. Test Email Command

Create a test command to send a test email:

```bash
php artisan make:command TestJobApplicationEmail
```

## Important Notes

1. **Company Email Required:** Make sure companies have email addresses in the database
2. **Error Handling:** The system logs email errors but doesn't fail the application submission
3. **Profile URL:** The email includes a link to view the applicant's profile at `/job-seeker/{user_id}`

## Files Created/Modified

### New Files:
- `app/Mail/JobApplicationSubmitted.php` - Mailable class with inline HTML template (no Blade dependency)

### Modified Files:
- `app/Http/Controllers/Api/JobApplicationController.php` - Added email sending logic

### Architecture Note:
Since this is a full API application with Vue.js frontend, the email template uses inline HTML generation instead of Blade views. This keeps the email system independent of the view layer and maintains the API-only architecture.

## Troubleshooting

### Email Not Sending?

1. Check your `.env` configuration
2. Clear config cache: `php artisan config:clear`
3. Check logs: `storage/logs/laravel.log`
4. Verify company has an email address in database

### Email Goes to Spam?

1. Use a verified domain
2. Set up SPF and DKIM records
3. Use a professional email service (SendGrid, Mailgun, SES)

## Future Enhancements

Consider adding:
- Email queue for better performance
- Email templates for other notifications
- Email preferences for companies
- Notification settings in user dashboard
