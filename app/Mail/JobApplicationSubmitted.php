<?php

namespace App\Mail;

use App\Models\JobApplication;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class JobApplicationSubmitted extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     */
    public function __construct(
        public JobApplication $application
    ) {
        //
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        /** @var \App\Models\Job|null $job */
        $job = $this->application->job;

        if (! $job) {
            throw new \RuntimeException('Job application must have an associated job');
        }

        return new Envelope(
            subject: 'New Job Application Received - '.$job->title,
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            html: $this->buildHtmlContent(),
        );
    }

    /**
     * Build the HTML email content.
     */
    private function buildHtmlContent(): string
    {
        /** @var \App\Models\Job|null $job */
        $job = $this->application->job;
        /** @var \App\Models\Company|null $company */
        $company = $job?->company;
        /** @var \App\Models\User|null $applicant */
        $applicant = $this->application->user;

        if (! $job || ! $company || ! $applicant) {
            throw new \RuntimeException('Job application must have job, company, and user loaded');
        }

        // Escape HTML to prevent XSS
        $companyName = e($company->name);
        $jobTitle = e($job->title);
        $applicantName = e($applicant->name);
        $companySlug = urlencode($company->slug);

        $profileUrl = config('app.url').'/job-seeker/'.$applicant->id;
        $appliedAt = $this->application->applied_at->format('F d, Y \a\t h:i A');
        $currentYear = date('Y');
        $appUrl = config('app.url');

        return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Job Application</title>
</head>
<body style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f5f5f5;">
    <div style="background-color: #ffffff; border-radius: 8px; padding: 30px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);">
        <div style="text-align: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid #4f46e5;">
            <div style="font-size: 28px; font-weight: bold; color: #4f46e5; margin-bottom: 10px;">JobsIQ</div>
            <div style="color: #6b7280; font-size: 14px;">Your Intelligent Job Search Platform</div>
        </div>

        <h1 style="color: #1f2937; font-size: 24px; margin-bottom: 20px;">🎉 New Job Application Received!</h1>

        <div style="font-size: 16px; margin-bottom: 20px;">
            <strong>Dear {$companyName},</strong>
        </div>

        <div style="margin-bottom: 30px;">
            <p>Great news! You have received a new application for your job posting from our platform, <strong>JobsIQ</strong>.</p>

            <div style="background-color: #f9fafb; border-left: 4px solid #4f46e5; padding: 20px; margin: 20px 0;">
                <h3 style="margin-top: 0; color: #1f2937;">Application Details</h3>
                
                <div style="margin-bottom: 12px;">
                    <span style="font-weight: 600; color: #4b5563; display: inline-block; min-width: 120px;">Job Position:</span>
                    <span style="color: #1f2937;">{$jobTitle}</span>
                </div>
                
                <div style="margin-bottom: 12px;">
                    <span style="font-weight: 600; color: #4b5563; display: inline-block; min-width: 120px;">Applicant Name:</span>
                    <span style="color: #1f2937;">{$applicantName}</span>
                </div>
                
                <div style="margin-bottom: 12px;">
                    <span style="font-weight: 600; color: #4b5563; display: inline-block; min-width: 120px;">Applied On:</span>
                    <span style="color: #1f2937;">{$appliedAt}</span>
                </div>

                {$this->renderCvStatus()}

                {$this->renderCoverLetterStatus()}
            </div>

            <p>To review the complete profile of this job seeker and take further action on their application, please click the button below:</p>

            <div style="text-align: center; margin: 30px 0;">
                <a href="{$profileUrl}" style="display: inline-block; background-color: #4f46e5; color: #ffffff; padding: 14px 32px; text-decoration: none; border-radius: 6px; font-weight: 600;">
                    👤 View Job Seeker Profile
                </a>
            </div>

            <p style="color: #6b7280; font-size: 14px;">
                <em>Note: You can review their full CV, cover letter, work experience, education, and other qualifications by clicking the button above.</em>
            </p>
        </div>

        <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #e5e7eb; text-align: center; font-size: 12px; color: #6b7280;">
            <p>
                This email was sent from <strong>JobsIQ</strong> - Your Intelligent Job Search Platform
            </p>
            <p>
                &copy; {$currentYear} JobsIQ. All rights reserved.
            </p>
            <div style="margin-top: 10px;">
                <a href="{$appUrl}" style="color: #4f46e5; text-decoration: none; margin: 0 10px;">Visit JobsIQ</a>
                <a href="{$appUrl}/companies/{$companySlug}" style="color: #4f46e5; text-decoration: none; margin: 0 10px;">Your Company Profile</a>
            </div>
        </div>
    </div>
</body>
</html>
HTML;
    }

    /**
     * Render CV status.
     */
    private function renderCvStatus(): string
    {
        if ($this->application->cv) {
            return <<<'HTML'
                <div style="margin-bottom: 12px;">
                    <span style="font-weight: 600; color: #4b5563; display: inline-block; min-width: 120px;">CV Attached:</span>
                    <span style="color: #1f2937;">✓ Yes</span>
                </div>
HTML;
        }

        return '';
    }

    /**
     * Render cover letter status.
     */
    private function renderCoverLetterStatus(): string
    {
        if ($this->application->cover_letter) {
            return <<<'HTML'
                <div style="margin-bottom: 12px;">
                    <span style="font-weight: 600; color: #4b5563; display: inline-block; min-width: 120px;">Cover Letter:</span>
                    <span style="color: #1f2937;">✓ Included</span>
                </div>
HTML;
        }

        return '';
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
