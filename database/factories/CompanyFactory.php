<?php

namespace Database\Factories;

use App\Models\Company;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Company>
 */
class CompanyFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = fake()->company();
        $industries = [
            'Technology', 'Healthcare', 'Finance', 'Education', 'Retail',
            'Manufacturing', 'Consulting', 'Marketing', 'Real Estate', 'Hospitality',
            'Media', 'Transportation', 'Energy', 'Telecommunications', 'Agriculture',
        ];

        $companySizes = ['1-10', '11-50', '51-200', '201-500', '501-1000', '1001-5000', '5001+'];

        $benefits = [
            'Health Insurance', 'Dental Insurance', 'Vision Insurance', '401(k) Matching',
            'Paid Time Off', 'Remote Work', 'Flexible Hours', 'Professional Development',
            'Gym Membership', 'Free Lunch', 'Stock Options', 'Parental Leave',
            'Life Insurance', 'Commuter Benefits', 'Tuition Reimbursement',
        ];

        $perks = [
            'Standing Desks', 'Free Snacks', 'Coffee Bar', 'Game Room',
            'Pet Friendly Office', 'Casual Dress Code', 'Team Events',
            'Onsite Gym', 'Ergonomic Chairs', 'Meditation Room',
        ];

        $values = [
            'Innovation', 'Integrity', 'Teamwork', 'Excellence',
            'Customer Focus', 'Diversity & Inclusion', 'Sustainability',
            'Transparency', 'Continuous Learning', 'Work-Life Balance',
        ];

        return [
            // Basic Information
            'name' => $name,
            'slug' => Str::slug($name),
            'legal_name' => $name.' Inc.',
            'description' => fake()->paragraphs(3, true),
            'tagline' => fake()->catchPhrase(),

            // Contact Information
            'email' => fake()->companyEmail(),
            'phone' => fake()->phoneNumber(),
            'fax' => fake()->boolean(30) ? fake()->phoneNumber() : null,
            'website' => fake()->url(),

            // Address
            'street' => fake()->streetAddress(),
            'street_2' => fake()->boolean(20) ? fake()->secondaryAddress() : null,
            'city' => fake()->city(),
            'state' => fake()->state(),
            'country' => fake()->country(),
            'postal_code' => fake()->postcode(),
            'latitude' => fake()->latitude(),
            'longitude' => fake()->longitude(),

            // Business Information
            'industry' => fake()->randomElement($industries),
            'company_size' => fake()->randomElement($companySizes),
            'company_type' => fake()->randomElement(['startup', 'small_business', 'mid_market', 'enterprise']),
            'founded_date' => fake()->dateTimeBetween('-50 years', '-1 year'),
            'registration_number' => fake()->boolean(60) ? fake()->numerify('REG-#######') : null,
            'tax_id' => fake()->boolean(60) ? fake()->numerify('TAX-#########') : null,

            // Social Media
            'linkedin' => fake()->boolean(80) ? 'https://linkedin.com/company/'.Str::slug($name) : null,
            'twitter' => fake()->boolean(60) ? 'https://twitter.com/'.Str::slug($name) : null,
            'facebook' => fake()->boolean(50) ? 'https://facebook.com/'.Str::slug($name) : null,
            'instagram' => fake()->boolean(40) ? 'https://instagram.com/'.Str::slug($name) : null,
            'youtube' => fake()->boolean(30) ? 'https://youtube.com/@'.Str::slug($name) : null,
            'github' => fake()->boolean(50) ? 'https://github.com/'.Str::slug($name) : null,

            // Company Culture
            'benefits' => fake()->randomElements($benefits, fake()->numberBetween(5, 10)),
            'values' => fake()->randomElements($values, fake()->numberBetween(3, 6)),
            'perks' => fake()->randomElements($perks, fake()->numberBetween(3, 7)),
            'culture_description' => fake()->paragraphs(2, true),

            // Status
            'is_verified' => fake()->boolean(40),
            'is_featured' => fake()->boolean(20),
            'is_active' => true,
            'is_hiring' => fake()->boolean(80),

            // SEO
            'meta_title' => $name.' - Careers',
            'meta_description' => fake()->sentence(20),
            'keywords' => fake()->words(8),

            // Statistics
            'total_employees' => fake()->numberBetween(5, 5000),
            'active_jobs_count' => 0,
            'total_jobs_posted' => 0,
            'profile_views' => fake()->numberBetween(0, 10000),

            // Additional
            'timezone' => fake()->timezone(),
            'languages' => fake()->randomElements(['English', 'Spanish', 'French', 'German', 'Chinese'], fake()->numberBetween(1, 3)),
            'locations' => null, // Can be added later
            'why_work_here' => fake()->paragraphs(2, true),
            'funding_amount' => fake()->boolean(30) ? fake()->randomFloat(2, 100000, 50000000) : null,
            'funding_currency' => 'USD',
        ];
    }
}
