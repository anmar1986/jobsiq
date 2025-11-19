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
    ],
];
