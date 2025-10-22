<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Blog>
 */
class BlogFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $categories = ['Career Tips', 'Interview Advice', 'Resume Tips', 'Industry News', 'Job Search'];
        $tags = ['jobs', 'career', 'interview', 'resume', 'hiring', 'workplace', 'productivity', 'skills'];
        
        return [
            'user_id' => \App\Models\User::factory(),
            'title' => fake()->sentence(6),
            'excerpt' => fake()->paragraph(2),
            'content' => fake()->paragraphs(8, true),
            'category' => fake()->randomElement($categories),
            'tags' => fake()->randomElements($tags, rand(2, 4)),
            'status' => fake()->randomElement(['published', 'published', 'published', 'draft']),
            'published_at' => fake()->dateTimeBetween('-6 months', 'now'),
            'views' => fake()->numberBetween(0, 5000),
        ];
    }

    /**
     * Indicate that the blog is published.
     */
    public function published(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'published',
            'published_at' => now(),
        ]);
    }

    /**
     * Indicate that the blog is a draft.
     */
    public function draft(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'draft',
            'published_at' => null,
        ]);
    }
}
