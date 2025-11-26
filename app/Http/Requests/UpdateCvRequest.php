<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCvRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // Authorization is handled in the controller
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            // Personal Information
            'full_name' => ['nullable', 'string', 'max:255'],
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'title' => ['nullable', 'string', 'max:255'],
            'city' => ['nullable', 'string', 'max:255'],
            'country' => ['nullable', 'string', 'in:Iraq'],

            // Profile Image - explicitly define MIME types
            'profile_image' => [
                'nullable',
                'file',
                'mimes:jpeg,jpg,png,webp,gif',
                'max:2048', // 2MB in kilobytes
            ],

            // Skills
            'skills' => ['nullable', 'array'],
            'skills.*' => ['string', 'max:100'],

            // Work Experience
            'work_experience' => ['nullable', 'array'],
            'work_experience.*.position' => ['required', 'string', 'max:255'],
            'work_experience.*.company' => ['required', 'string', 'max:255'],
            'work_experience.*.location' => ['nullable', 'string', 'max:255'],
            'work_experience.*.start_date' => ['required', 'date'],
            'work_experience.*.end_date' => ['nullable', 'date', 'after_or_equal:work_experience.*.start_date'],
            'work_experience.*.is_current' => ['nullable', 'boolean'],
            'work_experience.*.description' => ['nullable', 'string', 'max:2000'],

            // Education
            'education' => ['nullable', 'array'],
            'education.*.degree' => ['required', 'string', 'max:255'],
            'education.*.field' => ['required', 'string', 'max:255'],
            'education.*.institution' => ['required', 'string', 'max:255'],
            'education.*.location' => ['nullable', 'string', 'max:255'],
            'education.*.start_date' => ['required', 'date'],
            'education.*.end_date' => ['nullable', 'date', 'after_or_equal:education.*.start_date'],
            'education.*.description' => ['nullable', 'string', 'max:1000'],

            // Certifications
            'certifications' => ['nullable', 'array'],
            'certifications.*.name' => ['required', 'string', 'max:255'],
            'certifications.*.issuer' => ['required', 'string', 'max:255'],
            'certifications.*.date' => ['required', 'date'],
            'certifications.*.expiry_date' => ['nullable', 'date', 'after_or_equal:certifications.*.date'],
            'certifications.*.credential_id' => ['nullable', 'string', 'max:255'],
            'certifications.*.url' => ['nullable', 'url', 'max:500'],

            // Languages
            'languages' => ['nullable', 'array'],
            'languages.*.language' => ['required', 'string', 'max:100'],
            'languages.*.proficiency' => ['required', 'string', 'in:basic,conversational,fluent,native'],

            // References
            'references' => ['nullable', 'array'],
            'references.*.name' => ['required', 'string', 'max:255'],
            'references.*.position' => ['required', 'string', 'max:255'],
            'references.*.company' => ['required', 'string', 'max:255'],
            'references.*.email' => ['nullable', 'email', 'max:255'],
            'references.*.phone' => ['nullable', 'string', 'max:50'],
            'references.*.relationship' => ['required', 'string', 'max:255'],

            // Volunteer Work
            'volunteer_work' => ['nullable', 'array'],
            'volunteer_work.*.organization' => ['required', 'string', 'max:255'],
            'volunteer_work.*.role' => ['required', 'string', 'max:255'],
            'volunteer_work.*.start_date' => ['required', 'date'],
            'volunteer_work.*.end_date' => ['nullable', 'date', 'after_or_equal:volunteer_work.*.start_date'],
            'volunteer_work.*.description' => ['nullable', 'string', 'max:2000'],

            // Hobbies
            'hobbies' => ['nullable', 'array'],
            'hobbies.*' => ['string', 'max:100'],

            // Social Links
            'website' => ['nullable', 'url', 'max:500'],
            'linkedin' => ['nullable', 'url', 'max:500'],
            'github' => ['nullable', 'url', 'max:500'],

            // Settings
            'is_public' => ['boolean'],
            'is_primary' => ['boolean'],
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'profile_image.file' => __('validation.custom.profile_image.file'),
            'profile_image.mimes' => __('validation.custom.profile_image.mimes'),
            'profile_image.max' => __('validation.custom.profile_image.max'),

            'work_experience.*.position.required' => __('validation.custom.work_experience.*.position.required'),
            'work_experience.*.company.required' => __('validation.custom.work_experience.*.company.required'),
            'work_experience.*.start_date.required' => __('validation.custom.work_experience.*.start_date.required'),
            'work_experience.*.end_date.after_or_equal' => __('validation.custom.work_experience.*.end_date.after_or_equal'),

            'education.*.degree.required' => __('validation.custom.education.*.degree.required'),
            'education.*.field.required' => __('validation.custom.education.*.field.required'),
            'education.*.institution.required' => __('validation.custom.education.*.institution.required'),
            'education.*.start_date.required' => __('validation.custom.education.*.start_date.required'),
            'education.*.end_date.after_or_equal' => __('validation.custom.education.*.end_date.after_or_equal'),

            'certifications.*.name.required' => __('validation.custom.certifications.*.name.required'),
            'certifications.*.issuer.required' => __('validation.custom.certifications.*.issuer.required'),
            'certifications.*.date.required' => __('validation.custom.certifications.*.date.required'),
            'certifications.*.expiry_date.after_or_equal' => __('validation.custom.certifications.*.expiry_date.after_or_equal'),

            'volunteer_work.*.organization.required' => __('validation.custom.volunteer_work.*.organization.required'),
            'volunteer_work.*.role.required' => __('validation.custom.volunteer_work.*.role.required'),
            'volunteer_work.*.start_date.required' => __('validation.custom.volunteer_work.*.start_date.required'),
            'volunteer_work.*.end_date.after_or_equal' => __('validation.custom.volunteer_work.*.end_date.after_or_equal'),

            'languages.*.language.required' => __('validation.custom.languages.*.language.required'),
            'languages.*.proficiency.required' => __('validation.custom.languages.*.proficiency.required'),
            'languages.*.proficiency.in' => __('validation.custom.languages.*.proficiency.in'),
        ];
    }

    /**
     * Handle a failed validation attempt.
     */
    protected function failedValidation(\Illuminate\Contracts\Validation\Validator $validator)
    {
        \Illuminate\Support\Facades\Log::error('UpdateCvRequest - Validation failed', [
            'errors' => $validator->errors()->toArray(),
            'hasFile' => $this->hasFile('profile_image'),
            'profile_image_info' => $this->hasFile('profile_image') ? [
                'size' => $this->file('profile_image')->getSize(),
                'mime' => $this->file('profile_image')->getMimeType(),
                'original' => $this->file('profile_image')->getClientOriginalName(),
            ] : null,
        ]);

        parent::failedValidation($validator);
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        // Convert empty strings to null for URL fields to allow clearing them
        $urlFields = ['website', 'linkedin', 'github'];
        $urlData = [];

        foreach ($urlFields as $field) {
            if ($this->has($field) && $this->input($field) === '') {
                $urlData[$field] = null;
            }
        }

        if (! empty($urlData)) {
            $this->merge($urlData);
        }

        // Convert string 'true'/'false' to boolean for is_public and is_primary
        if ($this->has('is_public') && is_string($this->is_public)) {
            $this->merge([
                'is_public' => filter_var($this->is_public, FILTER_VALIDATE_BOOLEAN),
            ]);
        }

        if ($this->has('is_primary') && is_string($this->is_primary)) {
            $this->merge([
                'is_primary' => filter_var($this->is_primary, FILTER_VALIDATE_BOOLEAN),
            ]);
        }

        // Always ensure country is Iraq
        $this->merge(['country' => 'Iraq']);

        // Remove postal_code if present
        if ($this->has('postal_code')) {
            $input = $this->all();
            unset($input['postal_code']);
            $this->replace($input);
        }

        // Parse JSON strings if they come as strings (from FormData)
        $jsonFields = ['skills', 'work_experience', 'education', 'certifications', 'languages', 'references', 'volunteer_work', 'hobbies'];

        foreach ($jsonFields as $field) {
            if ($this->has($field)) {
                $value = $this->input($field);

                // If it's a string, try to parse as JSON
                if (is_string($value)) {
                    $decoded = json_decode($value, true);

                    // If JSON parsing was successful, use the decoded value
                    if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                        $this->merge([$field => $decoded]);
                    } else {
                        // If JSON parsing failed, set as empty array to avoid validation error
                        $this->merge([$field => []]);
                    }
                }
            }
        }

        // Convert skills from objects to simple strings if needed
        if ($this->has('skills') && is_array($this->input('skills'))) {
            $skills = $this->input('skills');
            $processedSkills = array_map(function ($skill) {
                // If skill is an object/array with 'name' property, extract the name
                if (is_array($skill) && isset($skill['name'])) {
                    return $skill['name'];
                }

                // If it's already a string, return as is
                return is_string($skill) ? $skill : '';
            }, $skills);

            // Filter out empty strings
            $processedSkills = array_filter($processedSkills, function ($skill) {
                return ! empty($skill);
            });

            // Reindex array
            $processedSkills = array_values($processedSkills);

            $this->merge(['skills' => $processedSkills]);
        }

        // Clean up arrays - remove empty arrays and filter out incomplete entries
        // Skip 'skills' and 'hobbies' since they're simple arrays, not arrays of objects
        $fieldsToClean = array_diff($jsonFields, ['skills', 'hobbies']);

        foreach ($fieldsToClean as $field) {
            if ($this->has($field) && is_array($this->input($field))) {
                $fieldValue = $this->input($field);

                // If array is empty, set it to empty array (don't remove it)
                // This ensures the database field gets updated even if empty
                if (empty($fieldValue)) {
                    $this->merge([$field => []]);

                    continue;
                }

                // Filter out incomplete entries based on field type
                $cleaned = array_values(array_filter($fieldValue, function ($item) use ($field) {
                    if (! is_array($item)) {
                        return false;
                    }

                    // Check required fields for each type
                    switch ($field) {
                        case 'work_experience':
                            return ! empty($item['position']) && ! empty($item['company']) && ! empty($item['start_date']);
                        case 'education':
                            return ! empty($item['degree']) && ! empty($item['field']) && ! empty($item['institution']) && ! empty($item['start_date']);
                        case 'certifications':
                            return ! empty($item['name']) && ! empty($item['issuer']) && ! empty($item['date']);
                        case 'languages':
                            return ! empty($item['language']) && ! empty($item['proficiency']);
                        case 'references':
                            return ! empty($item['name']) && ! empty($item['position']) && ! empty($item['company']) && ! empty($item['relationship']);
                        case 'volunteer_work':
                            return ! empty($item['organization']) && ! empty($item['role']) && ! empty($item['start_date']);
                        default:
                            return true;
                    }
                }));

                // If after filtering the array is empty, set it to empty array
                // Don't remove it so the database field gets updated
                if (empty($cleaned)) {
                    $this->merge([$field => []]);
                } else {
                    $this->merge([$field => $cleaned]);
                }
            }
        }
    }
}
