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
            'legal_name' => ['nullable', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:5000'],
            'tagline' => ['nullable', 'string', 'max:255'],

            // Contact Information
            'email' => ['nullable', 'email', 'max:255'],
            'phone' => ['nullable', 'string', 'max:50'],
            'fax' => ['nullable', 'string', 'max:50'],
            'website' => ['nullable', 'url', 'max:255'],

            // Address
            'street' => ['nullable', 'string', 'max:255'],
            'street_2' => ['nullable', 'string', 'max:255'],
            'city' => ['sometimes', 'required', 'string', 'in:'.implode(',', $iraqCities)],
            'state' => ['nullable', 'string', 'max:100'],
            'country' => ['nullable', 'string', 'max:100', 'in:Iraq'],
            'latitude' => ['nullable', 'numeric', 'between:-90,90'],
            'longitude' => ['nullable', 'numeric', 'between:-180,180'],

            // Business Information
            'industry' => ['sometimes', 'required', 'string', 'in:'.implode(',', $companyCategories)],
            'company_size' => ['nullable', 'string', 'max:50'],
            'company_type' => ['nullable', 'in:startup,small_business,mid_market,enterprise,nonprofit,government,agency'],
            'founded_date' => ['nullable', 'date', 'before:today'],
            'registration_number' => ['nullable', 'string', 'max:100'],
            'tax_id' => ['nullable', 'string', 'max:100'],

            // Social Media
            'linkedin' => ['nullable', 'url', 'max:255'],
            'twitter' => ['nullable', 'url', 'max:255'],
            'facebook' => ['nullable', 'url', 'max:255'],
            'instagram' => ['nullable', 'url', 'max:255'],
            'youtube' => ['nullable', 'url', 'max:255'],
            'github' => ['nullable', 'url', 'max:255'],

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
            'timezone' => ['nullable', 'string', 'max:50'],
            'languages' => ['nullable', 'array'],
            'languages.*' => ['string', 'max:50'],
            'locations' => ['nullable', 'array'],
            'why_work_here' => ['nullable', 'string', 'max:5000'],
            'funding_amount' => ['nullable', 'numeric', 'min:0'],
            'funding_currency' => ['nullable', 'string', 'size:3'],
            'total_employees' => ['nullable', 'integer', 'min:0'],

            // Status
            'is_hiring' => ['nullable', 'boolean'],

            // Image Upload
            'logo' => ['nullable', 'image', 'mimes:jpeg,png,jpg,gif,svg', 'max:2048'],
            'images' => ['nullable', 'array', 'max:10'],
            'images.*' => ['image', 'mimes:jpeg,png,jpg,gif,svg', 'max:2048'],
        ];
    }
}
