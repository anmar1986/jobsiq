<?php

namespace Tests\Feature;

use App\Models\Company;
use App\Models\Job;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    use RefreshDatabase;

    public function test_returns_a_successful_response()
    {
        // Create a user, company and job to ensure there's data
        $user = User::factory()->create();
        $company = Company::factory()->create();
        Job::factory()->create(['company_id' => $company->id, 'user_id' => $user->id]);

        // Test a public API endpoint that doesn't require authentication
        $response = $this->get('/api/jobs');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'data' => [
                        '*' => ['id', 'title', 'company_id']
                    ]
                ]
            ]);
    }
}
