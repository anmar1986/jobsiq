<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    use RefreshDatabase;

    public function test_returns_a_successful_response()
    {
        // Test a public API endpoint that doesn't require authentication
        $response = $this->get('/api/cvs');

        $response->assertStatus(200);
    }
}
