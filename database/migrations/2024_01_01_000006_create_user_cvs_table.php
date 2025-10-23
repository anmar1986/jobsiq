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
        Schema::create('user_cvs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('title')->default('My CV'); // CV title
            $table->string('slug')->unique();

            // Personal Information
            $table->string('full_name');
            $table->string('email');
            $table->string('phone')->nullable();
            $table->string('website')->nullable();
            $table->string('linkedin')->nullable();
            $table->string('github')->nullable();
            $table->string('profile_image_path')->nullable();
            $table->text('address')->nullable();
            $table->string('city')->nullable();
            $table->string('country')->nullable();
            $table->string('postal_code')->nullable();

            // Professional Summary
            $table->text('summary')->nullable();
            $table->text('objective')->nullable();

            // Work Experience (JSON array)
            $table->json('work_experience')->nullable();
            // Structure: [{company, position, location, start_date, end_date, current, description, achievements: []}]

            // Education (JSON array)
            $table->json('education')->nullable();
            // Structure: [{institution, degree, field, location, start_date, end_date, gpa, description}]

            // Skills (JSON array)
            $table->json('skills')->nullable();
            // Structure: [{name, level, category}] or simple array

            // Languages (JSON array)
            $table->json('languages')->nullable();
            // Structure: [{language, proficiency}]

            // Certifications (JSON array)
            $table->json('certifications')->nullable();
            // Structure: [{name, issuer, date, expiry_date, credential_id, url}]

            // Projects (JSON array)
            $table->json('projects')->nullable();
            // Structure: [{title, description, technologies, url, start_date, end_date}]

            // References (JSON array)
            $table->json('references')->nullable();
            // Structure: [{name, position, company, email, phone, relationship}]

            // Additional Sections
            $table->json('awards')->nullable();
            $table->json('publications')->nullable();
            $table->json('volunteer_work')->nullable();
            $table->json('hobbies')->nullable();

            // Settings
            $table->boolean('is_public')->default(false);
            $table->boolean('is_primary')->default(false); // User's main CV
            $table->string('template')->default('default'); // CV template/theme
            $table->json('settings')->nullable(); // Color scheme, font, layout preferences

            $table->timestamps();

            $table->index('user_id');
            $table->index('slug');
            $table->index('is_public');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_cvs');
    }
};
