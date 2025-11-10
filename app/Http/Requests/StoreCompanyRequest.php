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
        if (! $this->user() || $this->user()->user_type !== 'company_owner') {
            return false;
        }

        // Check if user already has a company
        if ($this->user()->ownedCompanies()->exists()) {
            return false;
        }

        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $companyCategories = config('company.categories');
        $iraqCities = config('company.iraq_cities');

        return [
            // Basic Information
            'name' => ['required', 'string', 'max:255', 'unique:companies,name'],
            'about' => ['nullable', 'string', 'max:1000'],
            'description' => ['nullable', 'string', 'max:5000'],
            'tagline' => ['nullable', 'string', 'max:255'],

            // Contact Information
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'website' => ['nullable', 'url', 'max:255'],

            // Address
            'street' => ['nullable', 'string', 'max:255'],
            'city' => ['required', 'string', 'in:'.implode(',', $iraqCities)],
            'country' => ['required', 'in:Iraq'],

            // Business Information
            'industry' => ['required', 'string', function ($attribute, $value, $fail) {
                $companyCategories = config('company.categories');
                if (!in_array($value, $companyCategories, true)) {
                    $fail('Please select a valid company category.');
                }
            }],
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
            'is_active' => ['nullable', 'boolean'],

            // Image Upload (accepts both file uploads and base64 strings)
            'logo' => ['nullable', function ($attribute, $value, $fail) {
                // Skip validation if value is null or empty string
                if ($value === null || $value === '') {
                    return;
                }

                // If it's a file upload
                if ($value instanceof \Illuminate\Http\UploadedFile) {
                    if (! in_array($value->getMimeType(), ['image/jpeg', 'image/png', 'image/jpg', 'image/gif', 'image/svg+xml'])) {
                        $fail('The logo must be an image file.');
                    }
                    if ($value->getSize() > 2048 * 1024) {
                        $fail('The logo size must not exceed 2MB.');
                    }
                }
                // If it's a base64 string
                elseif (is_string($value) && preg_match('/^data:image\/(jpeg|png|jpg|gif|svg\+xml);base64,/', $value)) {
                    // Validate base64 size (rough estimation)
                    $size = (strlen($value) * 3) / 4;
                    if ($size > 2048 * 1024) {
                        $fail('The logo size must not exceed 2MB.');
                    }
                } else {
                    $fail('The logo must be a valid image file or base64 encoded image.');
                }
            }],
            'cover' => ['nullable', function ($attribute, $value, $fail) {
                // Skip validation if value is null or empty string
                if ($value === null || $value === '') {
                    return;
                }

                // If it's a file upload
                if ($value instanceof \Illuminate\Http\UploadedFile) {
                    if (! in_array($value->getMimeType(), ['image/jpeg', 'image/png', 'image/jpg', 'image/gif', 'image/svg+xml'])) {
                        $fail('The cover must be an image file.');
                    }
                    if ($value->getSize() > 2048 * 1024) {
                        $fail('The cover size must not exceed 2MB.');
                    }
                }
                // If it's a base64 string
                elseif (is_string($value) && preg_match('/^data:image\/(jpeg|png|jpg|gif|svg\+xml);base64,/', $value)) {
                    // Validate base64 size (rough estimation)
                    $size = (strlen($value) * 3) / 4;
                    if ($size > 2048 * 1024) {
                        $fail('The cover size must not exceed 2MB.');
                    }
                } else {
                    $fail('The cover must be a valid image file or base64 encoded image.');
                }
            }],
            'images' => ['nullable', 'array', 'max:10'],
            'images.*' => ['nullable', function ($attribute, $value, $fail) {
                // Skip validation if value is null or empty string
                if ($value === null || $value === '') {
                    return;
                }

                // If it's a file upload
                if ($value instanceof \Illuminate\Http\UploadedFile) {
                    if (! in_array($value->getMimeType(), ['image/jpeg', 'image/png', 'image/jpg', 'image/gif', 'image/svg+xml'])) {
                        $fail('Each image must be an image file.');
                    }
                    if ($value->getSize() > 2048 * 1024) {
                        $fail('Each image size must not exceed 2MB.');
                    }
                }
                // If it's a base64 string
                elseif (is_string($value) && preg_match('/^data:image\/(jpeg|png|jpg|gif|svg\+xml);base64,/', $value)) {
                    // Validate base64 size (rough estimation)
                    $size = (strlen($value) * 3) / 4;
                    if ($size > 2048 * 1024) {
                        $fail('Each image size must not exceed 2MB.');
                    }
                } else {
                    $fail('Each image must be a valid image file or base64 encoded image.');
                }
            }],
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
     * Handle a failed authorization attempt.
     */
    protected function failedAuthorization()
    {
        // Check if the failure is due to already having a company
        if ($this->user() && $this->user()->ownedCompanies()->exists()) {
            throw new \Illuminate\Auth\Access\AuthorizationException('You can only create one company. To manage your existing company, visit the My Company page from your dashboard.');
        }

        throw new \Illuminate\Auth\Access\AuthorizationException('You are not authorized to create a company.');
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
