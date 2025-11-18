<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateJobRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        $job = $this->route('job');

        return $this->user()->ownsCompany($job->company);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $jobCategories = config('job.categories');
        $iraqCities = config('company.iraq_cities');
        $allowedCurrencies = config('job.currencies');

        return [
            'title' => ['sometimes', 'string', 'max:255'],
            'description' => ['sometimes', 'string', 'max:10000'],
            'requirements' => ['nullable', 'string', 'max:10000'],
            'benefits' => ['nullable', 'string', 'max:10000'],
            'location' => ['sometimes', 'string', 'max:255'],
            'city' => ['sometimes', 'string', 'in:'.implode(',', $iraqCities)],
            'country' => ['sometimes', 'string', 'in:Iraq'],
            'employment_type' => ['sometimes', 'in:full-time,part-time,contract,freelance,internship'],
            'experience_level' => ['nullable', 'in:entry,junior,mid,senior,lead,executive'],
            'category' => ['sometimes', 'string', function ($attribute, $value, $fail) {
                $jobCategories = config('job.categories');
                if (! in_array($value, $jobCategories, true)) {
                    $fail('Please select a valid job category.');
                }
            }],
            'salary_min' => ['nullable', 'numeric', 'min:0'],
            'salary_max' => ['nullable', 'numeric', 'min:0', 'gte:salary_min'],
            'salary_currency' => ['nullable', 'string', 'in:'.implode(',', $allowedCurrencies)],
            'salary_period' => ['nullable', 'in:hourly,monthly,yearly'],
            'is_remote' => ['boolean'],
            'is_featured' => ['boolean'],
            'is_active' => ['boolean'],
            'skills' => ['nullable', 'array'],
            'skills.*' => ['string', 'max:100'],
            'expires_at' => ['nullable', 'date'],
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'title.string' => 'Job title must be text',
            'title.max' => 'Job title cannot exceed 255 characters',
            'description.string' => 'Job description must be text',
            'description.max' => 'Job description cannot exceed 10,000 characters',
            'requirements.max' => 'Requirements cannot exceed 10,000 characters',
            'benefits.max' => 'Benefits cannot exceed 10,000 characters',
            'location.string' => 'Location must be text',
            'location.max' => 'Location cannot exceed 255 characters',
            'city.in' => 'Please select a valid Iraqi city',
            'country.in' => 'Country must be Iraq',
            'employment_type.in' => 'Please select a valid employment type (Full Time, Part Time, Contract, Freelance, or Internship)',
            'experience_level.in' => 'Please select a valid experience level (Entry, Junior, Mid, Senior, Lead, or Executive)',
            'category.in' => 'Please select a valid job category',
            'salary_min.numeric' => 'Minimum salary must be a number',
            'salary_min.min' => 'Minimum salary cannot be negative',
            'salary_max.numeric' => 'Maximum salary must be a number',
            'salary_max.min' => 'Maximum salary cannot be negative',
            'salary_max.gte' => 'Maximum salary must be greater than or equal to minimum salary',
            'salary_currency.in' => 'Please select a valid currency',
            'salary_period.in' => 'Please select a valid salary period (Hourly, Monthly, or Yearly)',
            'skills.array' => 'Skills must be a list',
            'skills.*.string' => 'Each skill must be text',
            'skills.*.max' => 'Each skill cannot exceed 100 characters',
            'expires_at.date' => 'Expiration date must be a valid date',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     */
    public function attributes(): array
    {
        return [
            'title' => 'job title',
            'description' => 'job description',
            'requirements' => 'job requirements',
            'benefits' => 'job benefits',
            'location' => 'location',
            'city' => 'city',
            'country' => 'country',
            'employment_type' => 'employment type',
            'experience_level' => 'experience level',
            'category' => 'job category',
            'salary_min' => 'minimum salary',
            'salary_max' => 'maximum salary',
            'salary_currency' => 'salary currency',
            'salary_period' => 'salary period',
            'is_remote' => 'remote work option',
            'is_featured' => 'featured status',
            'is_active' => 'active status',
            'skills' => 'skills',
            'expires_at' => 'expiration date',
        ];
    }
}
