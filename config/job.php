<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Default Job Expiration Period
    |--------------------------------------------------------------------------
    |
    | The default number of days after which a job posting will expire if
    | no expiration date is explicitly set. This can be overridden when
    | creating individual job postings.
    |
    */

    'default_expiration_days' => env('JOB_DEFAULT_EXPIRATION_DAYS', 30),

    /*
    |--------------------------------------------------------------------------
    | Job Categories
    |--------------------------------------------------------------------------
    |
    | List of valid job categories for the JobsIQ platform.
    | These categories are used for job posting and filtering.
    |
    */

    'categories' => [
        'Information Technology (IT) & Software',
        'Engineering & Technical',
        'Construction & Architecture',
        'Oil, Gas & Energy',
        'Accounting & Finance',
        'Sales, Marketing & Retail',
        'Administration & Office Support',
        'Human Resources (HR)',
        'Education & Training',
        'Healthcare & Medical',
        'Banking & Insurance',
        'Customer Service & Call Center',
        'Transport & Logistics',
        'Procurement & Supply Chain',
        'Manufacturing & Production',
        'Media, Design & Creative',
        'Legal & Compliance',
        'Security & Safety',
        'Hospitality & Tourism',
        'NGO & Humanitarian Work',
        'Government & Public Sector',
        'Telecommunications',
        'Agriculture & Environment',
        'Real Estate & Property',
        'Maintenance & Repair',
        'Mechanic & Automotive',
        'Cleaning & Housekeeping',
        'Fashion & Beauty',
        'Science & Research',
        'Writing, Editing & Translation',
        'Internships & Entry-Level Jobs',
        'Other / Miscellaneous',
    ],
];
