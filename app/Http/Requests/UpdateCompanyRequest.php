<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCompanyRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        $company = $this->route('company');

        return $this->user()->ownsCompany($company);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $companyId = $this->route('company')->id;
        $companyCategories = config('company.categories');
        $iraqCities = config('company.iraq_cities');

        return [
            // Basic Information
            'name' => ['sometimes', 'string', 'max:255', 'unique:companies,name,'.$companyId],
            'about' => ['nullable', 'string', 'max:1000'],
            'description' => ['nullable', 'string', 'max:5000'],
            'tagline' => ['nullable', 'string', 'max:255'],

            // Contact Information
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'website' => ['nullable', 'url', 'max:255'],

            // Address
            'street' => ['nullable', 'string', 'max:255'],
            'city' => ['sometimes', 'required', 'string', 'in:'.implode(',', $iraqCities)],
            'country' => ['nullable', 'string', 'max:100', 'in:Iraq'],

            // Business Information
            'industry' => ['sometimes', 'required', 'string', 'in:'.implode(',', $companyCategories)],
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
                    // Check if the file path is valid and not empty
                    if (! $value->isValid() || empty($value->getPathname())) {
                        return; // Skip validation for invalid/empty files
                    }

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
                    // Check if the file path is valid and not empty
                    if (! $value->isValid() || empty($value->getPathname())) {
                        return; // Skip validation for invalid/empty files
                    }

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
                } elseif (! empty($value)) {
                    $fail('Each image must be a valid image file or base64 encoded image.');
                }
            }],
        ];
    }
}
