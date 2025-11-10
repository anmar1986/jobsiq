<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreJobRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        // Only company owners can post jobs
        if ($this->user()->user_type !== 'company_owner') {
            return false;
        }

        // Check if user owns the company
        $companyId = $this->input('company_id');
        if (! $companyId) {
            return false;
        }

        $company = \App\Models\Company::find($companyId);

        return $company && $this->user()->ownsCompany($company);
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
            'company_id' => ['required', 'exists:companies,id'],
            'title' => ['required', 'string', 'max:255'],
            'description' => ['required', 'string', 'max:10000'],
            'requirements' => ['nullable', 'string', 'max:10000'],
            'benefits' => ['nullable', 'string', 'max:10000'],
            'location' => ['required', 'string', 'max:255'],
            'city' => ['required', 'string', 'in:'.implode(',', $iraqCities)],
            'country' => ['required', 'string', 'in:Iraq'],
            'employment_type' => ['required', 'in:full-time,part-time,contract,freelance,internship'],
            'experience_level' => ['nullable', 'in:entry,junior,mid,senior,lead,executive'],
            'category' => ['required', 'string', function ($attribute, $value, $fail) {
                $jobCategories = config('job.categories');
                if (!in_array($value, $jobCategories, true)) {
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
            'expires_at' => ['nullable', 'date', 'after_or_equal:today'],
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'company_id.required' => 'Please select a company',
            'company_id.exists' => 'The selected company does not exist',
            'title.required' => 'Job title is required',
            'description.required' => 'Job description is required',
            'location.required' => 'Job location is required',
            'city.required' => 'City is required',
            'city.in' => 'Please select a valid Iraqi city',
            'country.required' => 'Country is required',
            'country.in' => 'Country must be Iraq',
            'employment_type.required' => 'Employment type is required',
            'employment_type.in' => 'Invalid employment type',
            'category.required' => 'Job category is required',
            'category.in' => 'Please select a valid category',
            'salary_max.gte' => 'Maximum salary must be greater than or equal to minimum salary',
            'expires_at.after' => 'Expiration date must be in the future',
        ];
    }
}
