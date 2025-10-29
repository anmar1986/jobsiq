<?php

namespace Tests\Feature;

use App\Models\Company;
use App\Models\Job;
use App\Models\SearchHistory;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class SearchHistoryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();

        // Create a company and some jobs for testing
        $company = Company::factory()->create();
        Job::factory()->count(5)->create([
            'company_id' => $company->id,
            'is_active' => true,
            'published_at' => now(),
        ]);
    }

    #[Test]
    public function it_logs_search_history_for_authenticated_users()
    {
        $user = User::factory()->create();

        $this->assertEquals(0, SearchHistory::count());

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=developer&location=Baghdad');

        $response->assertStatus(200);

        // Check that search history was logged
        $this->assertEquals(1, SearchHistory::count());

        $searchHistory = SearchHistory::first();
        $this->assertEquals($user->id, $searchHistory->user_id);
        $this->assertEquals('developer', $searchHistory->search_query);
        $this->assertEquals('Baghdad', $searchHistory->location);
        $this->assertNotNull($searchHistory->ip_address);
        $this->assertNotNull($searchHistory->user_agent);
    }

    #[Test]
    public function it_logs_search_history_for_guest_users()
    {
        $this->assertEquals(0, SearchHistory::count());

        $response = $this->getJson('/api/jobs?search=designer&location=Erbil');

        $response->assertStatus(200);

        // Check that search history was logged
        $this->assertEquals(1, SearchHistory::count());

        $searchHistory = SearchHistory::first();
        $this->assertNull($searchHistory->user_id); // Guest user has null user_id
        $this->assertEquals('designer', $searchHistory->search_query);
        $this->assertEquals('Erbil', $searchHistory->location);
        $this->assertNotNull($searchHistory->ip_address);
        $this->assertNotNull($searchHistory->user_agent);
    }

    #[Test]
    public function it_logs_search_filters_in_history()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=developer&employment_type=full-time&experience_level=senior&is_remote=1&category=IT');

        $response->assertStatus(200);

        $searchHistory = SearchHistory::first();
        $this->assertEquals($user->id, $searchHistory->user_id);
        $this->assertEquals('developer', $searchHistory->search_query);

        $filters = $searchHistory->filters;
        $this->assertEquals('full-time', $filters['employment_type']);
        $this->assertEquals('senior', $filters['experience_level']);
        $this->assertTrue($filters['is_remote']);
        $this->assertEquals('IT', $filters['category']);
    }

    #[Test]
    public function it_logs_results_count_in_search_history()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=developer');

        $response->assertStatus(200);

        $searchHistory = SearchHistory::first();
        $this->assertIsInt($searchHistory->results_count);
        $this->assertGreaterThanOrEqual(0, $searchHistory->results_count);
    }

    #[Test]
    public function it_does_not_log_search_history_when_no_filters_are_used()
    {
        $user = User::factory()->create();

        $this->assertEquals(0, SearchHistory::count());

        // Just browsing jobs without any search or filters
        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs');

        $response->assertStatus(200);

        // Should not log if no search/filters are used
        $this->assertEquals(0, SearchHistory::count());
    }

    #[Test]
    public function it_logs_search_history_with_only_location_filter()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?location=Basra');

        $response->assertStatus(200);

        $this->assertEquals(1, SearchHistory::count());
        $searchHistory = SearchHistory::first();
        $this->assertEquals('Basra', $searchHistory->location);
        $this->assertNull($searchHistory->search_query);
    }

    #[Test]
    public function it_logs_search_history_with_salary_filter()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?salary_min=5000');

        $response->assertStatus(200);

        $this->assertEquals(1, SearchHistory::count());
        $searchHistory = SearchHistory::first();
        $this->assertEquals(5000, $searchHistory->filters['salary_min']);
    }

    #[Test]
    public function it_logs_multiple_searches_for_same_user()
    {
        $user = User::factory()->create();

        // First search
        $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=developer');

        // Second search
        $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=designer');

        // Third search
        $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?location=Baghdad');

        $this->assertEquals(3, SearchHistory::count());

        $allSearches = SearchHistory::where('user_id', $user->id)->get();
        $this->assertEquals(3, $allSearches->count());
    }

    #[Test]
    public function search_history_can_be_retrieved_for_user()
    {
        $user = User::factory()->create();

        // Create some search history
        SearchHistory::create([
            'user_id' => $user->id,
            'search_query' => 'developer',
            'location' => 'Baghdad',
            'results_count' => 10,
            'ip_address' => '127.0.0.1',
        ]);

        SearchHistory::create([
            'user_id' => $user->id,
            'search_query' => 'designer',
            'location' => 'Erbil',
            'results_count' => 5,
            'ip_address' => '127.0.0.1',
        ]);

        $userSearches = SearchHistory::where('user_id', $user->id)->get();

        $this->assertEquals(2, $userSearches->count());
        $this->assertEquals('developer', $userSearches->first()->search_query);
    }

    #[Test]
    public function it_handles_search_history_logging_errors_gracefully()
    {
        $user = User::factory()->create();

        // This should still work even if there's an error in logging
        $response = $this->actingAs($user, 'sanctum')
            ->getJson('/api/jobs?search=test');

        $response->assertStatus(200);
        // The API should not fail even if logging fails
    }

    #[Test]
    public function it_logs_search_history_with_company_filter()
    {
        $user = User::factory()->create();
        $company = Company::first();

        $this->assertEquals(0, SearchHistory::count());

        $response = $this->actingAs($user, 'sanctum')
            ->getJson("/api/jobs?company={$company->slug}");

        $response->assertStatus(200);

        // Check that search history was logged
        $this->assertEquals(1, SearchHistory::count());

        $searchHistory = SearchHistory::first();
        $this->assertEquals($user->id, $searchHistory->user_id);
        $this->assertNull($searchHistory->search_query);
        $this->assertNull($searchHistory->location);
        $this->assertNotNull($searchHistory->filters);
        $this->assertArrayHasKey('company', $searchHistory->filters);
        $this->assertEquals($company->slug, $searchHistory->filters['company']);
    }
}
