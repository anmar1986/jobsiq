<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\UserCv>
 */
class UserCvFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $skills = [
            'PHP', 'Laravel', 'JavaScript', 'Vue.js', 'React', 'Node.js',
            'Python', 'Django', 'Java', 'Spring Boot', 'SQL', 'MongoDB',
            'Docker', 'AWS', 'Git', 'REST APIs', 'GraphQL', 'TypeScript',
            'HTML', 'CSS', 'Tailwind CSS', 'Bootstrap', 'Redux', 'Jest'
        ];

        $languages = [
            ['language' => 'English', 'proficiency' => 'Native'],
            ['language' => 'Spanish', 'proficiency' => 'Professional'],
            ['language' => 'French', 'proficiency' => 'Intermediate'],
        ];

        $categories = [
            'Frontend', 'Backend', 'Full Stack', 'DevOps', 'Mobile',
            'Data Science', 'Machine Learning', 'UI/UX Design'
        ];

        // Generate 2-5 work experiences
        $workExperiences = [];
        $numExperiences = fake()->numberBetween(2, 5);
        for ($i = 0; $i < $numExperiences; $i++) {
            $startDate = fake()->dateTimeBetween('-10 years', '-1 year');
            $isCurrent = $i === 0 ? fake()->boolean(30) : false;
            $endDate = $isCurrent ? null : fake()->dateTimeBetween($startDate, 'now');

            $workExperiences[] = [
                'company' => fake()->company(),
                'position' => fake()->jobTitle(),
                'location' => fake()->city() . ', ' . fake()->country(),
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate ? $endDate->format('Y-m-d') : null,
                'current' => $isCurrent,
                'description' => fake()->paragraphs(2, true),
                'achievements' => [
                    fake()->sentence(),
                    fake()->sentence(),
                    fake()->sentence(),
                ],
            ];
        }

        // Generate 1-3 education entries
        $education = [];
        $numEducation = fake()->numberBetween(1, 3);
        for ($i = 0; $i < $numEducation; $i++) {
            $startDate = fake()->dateTimeBetween('-15 years', '-5 years');
            $endDate = fake()->dateTimeBetween($startDate, '-1 year');

            $education[] = [
                'institution' => fake()->company() . ' University',
                'degree' => fake()->randomElement(['Bachelor', 'Master', 'PhD']),
                'field' => fake()->randomElement(['Computer Science', 'Software Engineering', 'Information Technology', 'Web Development']),
                'location' => fake()->city() . ', ' . fake()->country(),
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'gpa' => fake()->randomFloat(2, 3.0, 4.0),
                'description' => fake()->sentence(),
            ];
        }

        // Generate skills with levels
        $selectedSkills = fake()->randomElements($skills, fake()->numberBetween(5, 12));
        $skillsArray = array_map(function($skill) use ($categories) {
            return [
                'name' => $skill,
                'level' => fake()->randomElement(['Beginner', 'Intermediate', 'Advanced', 'Expert']),
                'category' => fake()->randomElement($categories),
            ];
        }, $selectedSkills);

        // Generate certifications
        $certifications = [];
        $numCerts = fake()->numberBetween(1, 4);
        for ($i = 0; $i < $numCerts; $i++) {
            $certifications[] = [
                'name' => fake()->randomElement(['AWS Certified', 'Google Cloud Certified', 'Microsoft Certified', 'Oracle Certified']),
                'issuer' => fake()->randomElement(['AWS', 'Google', 'Microsoft', 'Oracle']),
                'date' => fake()->dateTimeBetween('-5 years', 'now')->format('Y-m-d'),
                'expiry_date' => fake()->boolean(50) ? fake()->dateTimeBetween('now', '+5 years')->format('Y-m-d') : null,
                'credential_id' => fake()->uuid(),
                'url' => fake()->url(),
            ];
        }

        return [
            'user_id' => User::factory(),
            'title' => fake()->randomElement(['Professional CV', 'Software Engineer CV', 'Developer Resume', 'My CV']),
            'full_name' => fake()->name(),
            'email' => fake()->safeEmail(),
            'phone' => fake()->phoneNumber(),
            'website' => fake()->boolean(60) ? fake()->url() : null,
            'linkedin' => fake()->boolean(70) ? 'https://linkedin.com/in/' . fake()->userName() : null,
            'github' => fake()->boolean(70) ? 'https://github.com/' . fake()->userName() : null,
            'address' => fake()->streetAddress(),
            'city' => fake()->city(),
            'country' => fake()->country(),
            'postal_code' => fake()->postcode(),
            'summary' => fake()->paragraphs(2, true),
            'objective' => fake()->boolean(60) ? fake()->paragraph() : null,
            'work_experience' => $workExperiences,
            'education' => $education,
            'skills' => $skillsArray,
            'languages' => fake()->randomElements($languages, fake()->numberBetween(1, 3)),
            'certifications' => $certifications,
            'projects' => [],
            'references' => [],
            'awards' => [],
            'publications' => [],
            'volunteer_work' => [],
            'hobbies' => fake()->randomElements(['Reading', 'Hiking', 'Photography', 'Gaming', 'Cooking', 'Travel'], fake()->numberBetween(2, 4)),
            'is_public' => fake()->boolean(60),
            'is_primary' => false,
            'template' => fake()->randomElement(['default', 'modern', 'classic', 'creative']),
            'settings' => [
                'color_scheme' => fake()->randomElement(['blue', 'green', 'purple', 'red']),
                'font' => fake()->randomElement(['sans-serif', 'serif', 'monospace']),
            ],
        ];
    }
}
