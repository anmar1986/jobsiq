<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rules\File;

class StoreCvRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true; // Authorization is handled by auth:sanctum middleware
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
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        // Log raw request info for debugging
        Log::info('StoreCvRequest - RAW REQUEST INFO', [
            'content_type' => $this->header('Content-Type'),
            'method' => $this->method(),
            'hasFile_check' => $this->hasFile('profile_image'),
            'files_array' => array_keys($this->allFiles()),
            'input_keys' => array_keys($this->all()),
        ]);

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

        // Always set country to Iraq
        $this->merge(['country' => 'Iraq']);

        // Remove postal_code if present
        if ($this->has('postal_code')) {
            $input = $this->all();
            unset($input['postal_code']);
            $this->replace($input);
        }

        Log::info('StoreCvRequest - Before prepareForValidation', [
            'hasFile' => $this->hasFile('profile_image'),
            'files' => array_keys($this->allFiles()),
            'has_method' => $this->has('_method'),
            'method_value' => $this->input('_method'),
            'profile_image_input' => $this->has('profile_image'),
            'profile_image_upload_error' => isset($_FILES['profile_image']) ? $_FILES['profile_image']['error'] ?? 'no error key' : 'not in $_FILES',
        ]);

        // Check for PHP file upload errors and provide better error messages
        if (isset($_FILES['profile_image']) && isset($_FILES['profile_image']['error'])) {
            $uploadError = $_FILES['profile_image']['error'];

            Log::info('Profile image upload error code', [
                'error_code' => $uploadError,
                'file_size' => $_FILES['profile_image']['size'] ?? 'unknown',
                'file_name' => $_FILES['profile_image']['name'] ?? 'unknown',
            ]);

            if ($uploadError !== UPLOAD_ERR_OK) {
                $errorMessages = [
                    UPLOAD_ERR_INI_SIZE => 'The uploaded file exceeds the upload_max_filesize directive in php.ini',
                    UPLOAD_ERR_FORM_SIZE => 'The uploaded file exceeds the MAX_FILE_SIZE directive in the HTML form',
                    UPLOAD_ERR_PARTIAL => 'The uploaded file was only partially uploaded',
                    UPLOAD_ERR_NO_FILE => 'No file was uploaded',
                    UPLOAD_ERR_NO_TMP_DIR => 'Missing a temporary folder',
                    UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
                    UPLOAD_ERR_EXTENSION => 'A PHP extension stopped the file upload',
                ];

                Log::error('Profile image upload failed', [
                    'error_code' => $uploadError,
                    'error_message' => $errorMessages[$uploadError] ?? 'Unknown error',
                    'php_upload_max_filesize' => ini_get('upload_max_filesize'),
                    'php_post_max_size' => ini_get('post_max_size'),
                ]);
            }
        }

        // Parse JSON strings if they come as strings (from FormData)
        // Skip 'profile_image' as it's a file upload
        $jsonFields = ['skills', 'work_experience', 'education', 'certifications', 'languages', 'references', 'volunteer_work', 'hobbies'];

        Log::info('StoreCvRequest - Before JSON parsing', [
            'skills_raw' => $this->input('skills'),
            'skills_has' => $this->has('skills'),
            'skills_type' => gettype($this->input('skills')),
        ]);

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

            Log::info('StoreCvRequest - Processing skills', [
                'raw_skills' => $skills,
                'skills_count' => count($skills),
            ]);

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

            Log::info('StoreCvRequest - Processed skills', [
                'processed_skills' => $processedSkills,
                'count' => count($processedSkills),
            ]);

            $this->merge(['skills' => $processedSkills]);
        } else {
            Log::info('StoreCvRequest - No skills to process', [
                'has_skills' => $this->has('skills'),
                'is_array' => $this->has('skills') ? is_array($this->input('skills')) : false,
                'skills_value' => $this->has('skills') ? $this->input('skills') : 'not set',
            ]);
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

        Log::info('StoreCvRequest - Final data for validation', [
            'hasFile' => $this->hasFile('profile_image'),
            'files' => array_keys($this->allFiles()),
            'skills' => $this->has('skills') ? $this->input('skills') : 'not set',
            'work_experience' => $this->has('work_experience') ? (is_array($this->input('work_experience')) ? $this->input('work_experience') : 'not array') : 'not set',
            'education' => $this->has('education') ? (is_array($this->input('education')) ? $this->input('education') : 'not array') : 'not set',
            'certifications' => $this->has('certifications') ? (is_array($this->input('certifications')) ? $this->input('certifications') : 'not array') : 'not set',
            'languages' => $this->has('languages') ? (is_array($this->input('languages')) ? 'array' : 'not array') : 'not set',
            'all_keys' => array_keys($this->all()),
        ]);
    }

    /**
     * Handle a failed validation attempt.
     */
    protected function failedValidation(\Illuminate\Contracts\Validation\Validator $validator)
    {
        Log::error('StoreCvRequest - Validation failed', [
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
}
