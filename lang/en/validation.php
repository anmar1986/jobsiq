<?php

return [
    'custom' => [
        'title' => [
            'required' => 'Job title is required',
            'string' => 'Job title must be text',
            'max' => 'Job title cannot exceed :max characters',
        ],
        'description' => [
            'required' => 'Job description is required',
            'string' => 'Job description must be text',
            'max' => 'Job description cannot exceed :max characters',
        ],
        'location' => [
            'required' => 'Location is required',
            'string' => 'Location must be text',
            'max' => 'Location cannot exceed :max characters',
        ],
        'city' => [
            'required' => 'City is required',
            'in' => 'Please select a valid Iraqi city',
        ],
        'employment_type' => [
            'required' => 'Employment type is required',
            'in' => 'Please select a valid employment type',
        ],
        'experience_level' => [
            'in' => 'Please select a valid experience level',
        ],
        'category' => [
            'required' => 'Job category is required',
        ],
        'salary_min' => [
            'numeric' => 'Minimum salary must be a number',
            'min' => 'Minimum salary cannot be negative',
        ],
        'salary_max' => [
            'numeric' => 'Maximum salary must be a number',
            'min' => 'Maximum salary cannot be negative',
            'gte' => 'Maximum salary must be greater than or equal to minimum salary',
        ],

        // CV Validation Messages
        'profile_image.file' => 'The profile image must be a valid file. Please check your internet connection and try again.',
        'profile_image.mimes' => 'The profile image must be a file of type: jpeg, jpg, png, webp, gif',
        'profile_image.max' => 'The profile image must not be larger than 2MB. Please resize or compress your image.',

        'work_experience.*.position.required' => 'Work Experience: Position is required',
        'work_experience.*.company.required' => 'Work Experience: Company name is required',
        'work_experience.*.start_date.required' => 'Work Experience: Start date is required',
        'work_experience.*.end_date.after_or_equal' => 'Work Experience: End date must be after or equal to start date',

        'education.*.degree.required' => 'Education: Degree is required',
        'education.*.field.required' => 'Education: Field of study is required',
        'education.*.institution.required' => 'Education: Institution is required',
        'education.*.start_date.required' => 'Education: Start date is required',
        'education.*.end_date.after_or_equal' => 'Education: End date must be after or equal to start date',

        'certifications.*.name.required' => 'Certifications: Certification name is required',
        'certifications.*.issuer.required' => 'Certifications: Issuer is required',
        'certifications.*.date.required' => 'Certifications: Issue date is required',
        'certifications.*.expiry_date.after_or_equal' => 'Certifications: Expiry date must be after or equal to issue date',

        'volunteer_work.*.organization.required' => 'Volunteer Work: Organization name is required',
        'volunteer_work.*.role.required' => 'Volunteer Work: Role is required',
        'volunteer_work.*.start_date.required' => 'Volunteer Work: Start date is required',
        'volunteer_work.*.end_date.after_or_equal' => 'Volunteer Work: End date must be after or equal to start date',

        'languages.*.language.required' => 'Languages: Language name is required',
        'languages.*.proficiency.required' => 'Languages: Proficiency level is required',
        'languages.*.proficiency.in' => 'Languages: Proficiency must be one of: basic, conversational, fluent, native',
    ],
];
