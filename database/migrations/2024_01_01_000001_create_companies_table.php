<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('companies', function (Blueprint $table) {
            $table->id();

            // Basic Information
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('legal_name')->nullable(); // Official registered name
            $table->text('about')->nullable(); // Brief overview of the company
            $table->text('description')->nullable();
            $table->text('tagline')->nullable(); // Short company tagline/slogan

            // Contact Information
            $table->string('email')->nullable();
            $table->string('phone')->nullable();
            $table->string('fax')->nullable();
            $table->string('website')->nullable();

            // Address
            $table->string('street')->nullable();
            $table->string('street_2')->nullable(); // Additional address line
            $table->string('city')->nullable();
            $table->string('state')->nullable(); // State/Province
            $table->string('country')->nullable();
            $table->string('postal_code')->nullable();
            $table->decimal('latitude', 10, 8)->nullable(); // For map location
            $table->decimal('longitude', 11, 8)->nullable();

            // Business Information
            $table->string('industry')->nullable(); // Tech, Finance, Healthcare, etc.
            $table->string('company_size')->nullable(); // 1-10, 11-50, 51-200, 201-500, 501-1000, 1001-5000, 5001+
            $table->enum('company_type', ['startup', 'small_business', 'mid_market', 'enterprise', 'nonprofit', 'government', 'agency'])->nullable();
            $table->date('founded_date')->nullable();
            $table->string('registration_number')->nullable(); // Business registration number
            $table->string('tax_id')->nullable(); // Tax ID/VAT number

            // Social Media & Online Presence
            $table->string('linkedin')->nullable();
            $table->string('twitter')->nullable();
            $table->string('facebook')->nullable();
            $table->string('instagram')->nullable();
            $table->string('youtube')->nullable();
            $table->string('github')->nullable();

            // Company Culture & Benefits
            $table->json('benefits')->nullable(); // Array of benefits offered
            $table->json('values')->nullable(); // Company values/mission
            $table->json('perks')->nullable(); // Office perks
            $table->text('culture_description')->nullable();

            // Verification & Status
            $table->boolean('is_verified')->default(false); // Verified company
            $table->boolean('is_featured')->default(false); // Featured on homepage
            $table->boolean('is_active')->default(true);
            $table->boolean('is_hiring')->default(true); // Currently hiring

            // SEO & Marketing
            $table->string('meta_title')->nullable();
            $table->text('meta_description')->nullable();
            $table->json('keywords')->nullable(); // SEO keywords

            // Statistics (can be calculated but cached for performance)
            $table->integer('total_employees')->nullable();
            $table->integer('active_jobs_count')->default(0);
            $table->integer('total_jobs_posted')->default(0);
            $table->integer('profile_views')->default(0);

            // Additional Info
            $table->string('timezone')->nullable();
            $table->json('languages')->nullable(); // Languages used in company
            $table->json('locations')->nullable(); // Multiple office locations
            $table->text('why_work_here')->nullable(); // Why join this company
            $table->decimal('funding_amount', 15, 2)->nullable(); // Funding raised
            $table->string('funding_currency', 3)->default('USD');

            $table->timestamps();
            $table->softDeletes(); // Soft delete support

            // Indexes
            $table->index('slug');
            $table->index('is_active');
            $table->index('is_verified');
            $table->index('is_featured');
            $table->index('is_hiring');
            $table->index('industry');
            $table->index('company_size');

            // Only add fulltext index for MySQL
            if (config('database.default') === 'mysql') {
                $table->fullText(['name', 'description']);
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('companies');
    }
};
