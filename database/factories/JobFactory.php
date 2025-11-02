<?php

namespace Database\Factories;

use App\Models\Company;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Job>
 */
class JobFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $title = fake()->jobTitle();
        $employmentTypes = ['full-time', 'part-time', 'contract', 'freelance', 'internship'];
        $experienceLevels = ['entry', 'junior', 'mid', 'senior', 'lead'];
        $categories = ['Engineering', 'Design', 'Marketing', 'Sales', 'Finance', 'HR', 'Customer Service', 'Operations'];
        $skills = ['JavaScript', 'Python', 'React', 'Vue.js', 'Laravel', 'Node.js', 'TypeScript', 'PHP', 'Java', 'C#', 'AWS', 'Docker', 'Kubernetes'];
        $iraqCities = config('company.iraq_cities');

        $salaryMin = fake()->numberBetween(40000, 100000);
        $salaryMax = $salaryMin + fake()->numberBetween(20000, 80000);
        $city = fake()->randomElement($iraqCities);

        return [
            'company_id' => Company::factory(),
            'user_id' => User::factory(),
            'title' => $title,
            'slug' => Str::slug($title.'-'.Str::random(6)),
            'description' => fake()->paragraphs(5, true),
            'requirements' => fake()->paragraphs(3, true),
            'benefits' => fake()->optional(0.7)->paragraphs(2, true), // 70% chance of having benefits
            'location' => $city.', Iraq',
            'city' => $city,
            'country' => 'Iraq',
            'employment_type' => fake()->randomElement($employmentTypes),
            'experience_level' => fake()->randomElement($experienceLevels),
            'category' => fake()->randomElement($categories),
            'salary_min' => $salaryMin,
            'salary_max' => $salaryMax,
            'salary_currency' => 'USD',
            'salary_period' => 'yearly',
            'is_remote' => fake()->boolean(40),
            'is_featured' => fake()->boolean(20),
            'is_active' => true,
            'skills' => fake()->randomElements($skills, fake()->numberBetween(3, 6)),
            'expires_at' => fake()->dateTimeBetween('now', '+3 months'),
            'published_at' => fake()->dateTimeBetween('-1 month', 'now'),
        ];
    }
}
