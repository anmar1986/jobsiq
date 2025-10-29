<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Log;

class StoreCompanyRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        // Only company owners can create companies
        return $this->user() && $this->user()->user_type === 'company_owner';
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        // Log file info for debugging
        if ($this->hasFile('logo')) {
            $file = $this->file('logo');
            Log::info('Logo file received', [
                'name' => $file->getClientOriginalName(),
                'size' => $file->getSize(),
                'mime' => $file->getMimeType(),
                'extension' => $file->getClientOriginalExtension(),
                'is_valid' => $file->isValid(),
                'error' => $file->getError(),
                'error_message' => $file->getErrorMessage(),
            ]);
        } else {
            Log::info('No logo file in request', [
                'has_file' => $this->hasFile('logo'),
                'all_files' => array_keys($this->allFiles()),
            ]);
        }

        $companyCategories = config('company.categories');
        $iraqCities = config('company.iraq_cities');

        return [
            // Basic Information
            'name' => ['required', 'string', 'max:255', 'unique:companies,name'],
            'description' => ['nullable', 'string', 'max:5000'],
            'tagline' => ['nullable', 'string', 'max:255'],

            // Contact Information
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'website' => ['nullable', 'url', 'max:255'],

            // Address
            'street' => ['nullable', 'string', 'max:255'],
            'city' => ['required', 'string', 'in:'.implode(',', $iraqCities)],
            'country' => ['nullable', 'string', 'max:100', 'in:Iraq'],

            // Business Information
            'industry' => ['required', 'string', 'in:'.implode(',', $companyCategories)],
            'company_size' => ['nullable', 'string', 'max:50'],
            'company_type' => ['nullable', 'in:startup,small_business,mid_market,enterprise,nonprofit,government,agency'],
            'founded_date' => ['nullable', 'date', 'before:today'],

            // Social Media
            'linkedin' => ['nullable', 'url', 'max:255'],
            'twitter' => ['nullable', 'url', 'max:255'],
            'facebook' => ['nullable', 'url', 'max:255'],
            'instagram' => ['nullable', 'url', 'max:255'],
            'youtube' => ['nullable', 'url', 'max:255'],

            // Company Culture
            'benefits' => ['nullable', 'array'],
            'benefits.*' => ['string', 'max:255'],
            'values' => ['nullable', 'array'],
            'values.*' => ['string', 'max:255'],
            'perks' => ['nullable', 'array'],
            'perks.*' => ['string', 'max:255'],
            'culture_description' => ['nullable', 'string', 'max:5000'],

            // SEO
            'meta_title' => ['nullable', 'string', 'max:60'],
            'meta_description' => ['nullable', 'string', 'max:160'],
            'keywords' => ['nullable', 'array'],
            'keywords.*' => ['string', 'max:50'],

            // Additional
            'total_employees' => ['nullable', 'integer', 'min:0'],

            // Status
            'is_hiring' => ['nullable', 'boolean'],

            // Image Upload
            'logo' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif,svg', 'max:2048'],
            'images' => ['nullable', 'array', 'max:10'],
            'images.*' => ['image', 'mimes:jpeg,png,jpg,gif,svg', 'max:2048'],
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Company name is required',
            'name.unique' => 'A company with this name already exists',
            'industry.required' => 'Company category is required',
            'industry.in' => 'Please select a valid category',
            'city.required' => 'City is required',
            'city.in' => 'Please select a valid Iraqi city',
            'country.in' => 'Country must be Iraq',
            'email.unique' => 'A company with this email already exists',
            'website.url' => 'Please enter a valid URL',
            'logo.image' => 'Logo must be an image file',
            'logo.max' => 'Logo size must not exceed 2MB',
        ];
    }

    /**
     * Handle a failed validation attempt.
     */
    protected function failedValidation(\Illuminate\Contracts\Validation\Validator $validator)
    {
        Log::error('Company validation failed', [
            'errors' => $validator->errors()->toArray(),
            'input' => $this->except(['logo']),
        ]);

        parent::failedValidation($validator);
    }
}
