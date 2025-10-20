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
            'address' => ['nullable', 'string', 'max:500'],
            'city' => ['nullable', 'string', 'max:255'],
            'country' => ['nullable', 'string', 'max:255'],
            
            // Profile Image - explicitly define MIME types
            'profile_image' => [
                'nullable',
                'file',
                'mimes:jpeg,jpg,png,webp,gif',
                'max:2048', // 2MB in kilobytes
            ],
            
            // Professional Summary
            'summary' => ['nullable', 'string', 'max:5000'],
            
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
            'education.*.field_of_study' => ['required', 'string', 'max:255'],
            'education.*.institution' => ['required', 'string', 'max:255'],
            'education.*.location' => ['nullable', 'string', 'max:255'],
            'education.*.start_date' => ['required', 'date'],
            'education.*.end_date' => ['nullable', 'date', 'after_or_equal:education.*.start_date'],
            'education.*.gpa' => ['nullable', 'string', 'max:10'],
            'education.*.description' => ['nullable', 'string', 'max:1000'],
            
            // Certifications
            'certifications' => ['nullable', 'array'],
            'certifications.*.name' => ['required', 'string', 'max:255'],
            'certifications.*.issuer' => ['required', 'string', 'max:255'],
            'certifications.*.issue_date' => ['required', 'date'],
            'certifications.*.expiry_date' => ['nullable', 'date', 'after_or_equal:certifications.*.issue_date'],
            'certifications.*.credential_id' => ['nullable', 'string', 'max:255'],
            'certifications.*.credential_url' => ['nullable', 'url', 'max:500'],
            
            // Languages
            'languages' => ['nullable', 'array'],
            'languages.*.language' => ['required', 'string', 'max:100'],
            'languages.*.proficiency' => ['required', 'string', 'in:basic,conversational,fluent,native'],
            
            // Social Links
            'website' => ['nullable', 'url', 'max:500'],
            'linkedin_url' => ['nullable', 'url', 'max:500'],
            'github_url' => ['nullable', 'url', 'max:500'],
            
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
            'profile_image.file' => 'The profile image must be a file',
            'profile_image.mimes' => 'The profile image must be a file of type: jpeg, jpg, png, webp, gif',
            'profile_image.max' => 'The profile image must not be larger than 2MB',
            
            'work_experience.*.position.required' => 'Position is required for work experience',
            'work_experience.*.company.required' => 'Company is required for work experience',
            'work_experience.*.start_date.required' => 'Start date is required for work experience',
            'work_experience.*.end_date.after_or_equal' => 'End date must be after or equal to start date',
            
            'education.*.degree.required' => 'Degree is required for education',
            'education.*.field_of_study.required' => 'Field of study is required for education',
            'education.*.institution.required' => 'Institution is required for education',
            'education.*.start_date.required' => 'Start date is required for education',
            'education.*.end_date.after_or_equal' => 'End date must be after or equal to start date',
            
            'certifications.*.name.required' => 'Certification name is required',
            'certifications.*.issuer.required' => 'Issuer is required for certification',
            'certifications.*.issue_date.required' => 'Issue date is required for certification',
            'certifications.*.expiry_date.after_or_equal' => 'Expiry date must be after or equal to issue date',
            
            'languages.*.language.required' => 'Language name is required',
            'languages.*.proficiency.required' => 'Proficiency level is required',
            'languages.*.proficiency.in' => 'Proficiency must be one of: basic, conversational, fluent, native',
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

        Log::info('StoreCvRequest - Before prepareForValidation', [
            'hasFile' => $this->hasFile('profile_image'),
            'files' => array_keys($this->allFiles()),
            'has_method' => $this->has('_method'),
            'method_value' => $this->input('_method'),
        ]);

        // Parse JSON strings if they come as strings (from FormData)
        // Skip 'profile_image' as it's a file upload
        $jsonFields = ['skills', 'work_experience', 'education', 'certifications', 'languages'];
        
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
            
            $processedSkills = array_map(function($skill) {
                // If skill is an object/array with 'name' property, extract the name
                if (is_array($skill) && isset($skill['name'])) {
                    return $skill['name'];
                }
                // If it's already a string, return as is
                return is_string($skill) ? $skill : '';
            }, $skills);
            
            // Filter out empty strings
            $processedSkills = array_filter($processedSkills, function($skill) {
                return !empty($skill);
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
        // Skip 'skills' since it's already been processed above
        $fieldsToClean = array_diff($jsonFields, ['skills']);
        
        foreach ($fieldsToClean as $field) {
            if ($this->has($field) && is_array($this->input($field))) {
                $fieldValue = $this->input($field);
                
                // If array is empty, remove it
                if (empty($fieldValue)) {
                    $this->offsetUnset($field);
                    continue;
                }
                
                // Filter out incomplete entries based on field type
                $cleaned = array_values(array_filter($fieldValue, function($item) use ($field) {
                    if (!is_array($item)) {
                        return false;
                    }
                    
                    // Check required fields for each type
                    switch ($field) {
                        case 'work_experience':
                            return !empty($item['position']) && !empty($item['company']) && !empty($item['start_date']);
                        case 'education':
                            return !empty($item['degree']) && !empty($item['field_of_study']) && !empty($item['institution']) && !empty($item['start_date']);
                        case 'certifications':
                            return !empty($item['name']) && !empty($item['issuer']) && !empty($item['issue_date']);
                        case 'languages':
                            return !empty($item['language']) && !empty($item['proficiency']);
                        default:
                            return true;
                    }
                }));
                
                // If after filtering the array is empty, remove the field
                if (empty($cleaned)) {
                    $this->offsetUnset($field);
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
