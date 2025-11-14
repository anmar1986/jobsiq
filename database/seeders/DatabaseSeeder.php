<?php

namespace Database\Seeders;

use App\Models\Company;
use App\Models\Job;
use App\Models\User;
use App\Models\UserCv;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create test users (or get existing)
        $testUser = User::firstOrCreate(
            ['email' => 'test@example.com'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password'),
            ]
        );

        $john = User::firstOrCreate(
            ['email' => 'john@example.com'],
            [
                'name' => 'John Doe',
                'password' => bcrypt('password'),
            ]
        );

        $jane = User::firstOrCreate(
            ['email' => 'jane@example.com'],
            [
                'name' => 'Jane Smith',
                'password' => bcrypt('password'),
            ]
        );

        // Create additional random users
        $randomUsers = User::factory(10)->create();
        $allUsers = collect([$testUser, $john, $jane])->concat($randomUsers);

        // Create companies with owners
        $companies = collect();

        foreach ($allUsers->take(8) as $user) {
            /** @var User $user */
            $company = Company::factory()->create();

            // Attach user as primary owner
            $company->owners()->attach($user->id, ['is_primary' => true]);

            // Randomly add secondary owners
            if (fake()->boolean(30)) {
                /** @var User $secondaryOwner */
                $secondaryOwner = $allUsers->where('id', '!=', $user->id)->random();
                $company->owners()->attach($secondaryOwner->id, ['is_primary' => false]);
            }

            $companies->push($company);
        }

        // Create jobs for each company
        foreach ($companies as $company) {
            /** @var Company $company */
            /** @var User|null $owner */
            $owner = $company->owners()->wherePivot('is_primary', true)->first();

            if (! $owner) {
                continue;
            }

            // Create 3-8 jobs per company
            Job::factory()
                ->count(fake()->numberBetween(3, 8))
                ->create([
                    'company_id' => $company->id,
                    'user_id' => $owner->id,
                ]);
        }

        // Create CVs for users
        // Test user gets 2 CVs (one primary)
        UserCv::factory()
            ->count(2)
            ->create(['user_id' => $testUser->id])
            ->first()
            ->update(['is_primary' => true]);

        // John gets 1 CV (primary)
        UserCv::factory()
            ->create([
                'user_id' => $john->id,
                'is_primary' => true,
                'is_public' => true,
            ]);

        // Jane gets 3 CVs (one primary, two public)
        UserCv::factory()
            ->count(3)
            ->create(['user_id' => $jane->id])
            ->first()
            ->update(['is_primary' => true, 'is_public' => true]);

        // Random users get 0-2 CVs each
        foreach ($randomUsers as $user) {
            $cvCount = rand(0, 2);
            if ($cvCount > 0) {
                $cvs = UserCv::factory()
                    ->count($cvCount)
                    ->create(['user_id' => $user->id]);

                // Set first CV as primary
                if ($cvs->count() > 0) {
                    $cvs->first()->update(['is_primary' => true]);
                }
            }
        }

        $this->command->info('Database seeded successfully!');
        $this->command->info('Test credentials:');
        $this->command->info('Email: test@example.com');
        $this->command->info('Password: password');
    }
}
