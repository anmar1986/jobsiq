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
        return [
            'title' => ['sometimes', 'string', 'max:255'],
            'description' => ['sometimes', 'string', 'max:10000'],
            'requirements' => ['nullable', 'string', 'max:10000'],
            'location' => ['sometimes', 'string', 'max:255'],
            'city' => ['nullable', 'string', 'max:255'],
            'country' => ['nullable', 'string', 'max:255'],
            'employment_type' => ['sometimes', 'in:full-time,part-time,contract,freelance,internship'],
            'experience_level' => ['nullable', 'in:entry,junior,mid,senior,lead'],
            'category' => ['nullable', 'string', 'max:255'],
            'salary_min' => ['nullable', 'numeric', 'min:0'],
            'salary_max' => ['nullable', 'numeric', 'min:0', 'gte:salary_min'],
            'salary_currency' => ['nullable', 'string', 'size:3'],
            'salary_period' => ['nullable', 'in:hourly,monthly,yearly'],
            'is_remote' => ['boolean'],
            'is_featured' => ['boolean'],
            'is_active' => ['boolean'],
            'skills' => ['nullable', 'array'],
            'skills.*' => ['string', 'max:100'],
            'expires_at' => ['nullable', 'date'],
        ];
    }
}
