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
        Schema::create('cv_certifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_cv_id')->constrained('user_cvs')->onDelete('cascade');
            $table->string('name');
            $table->string('issuer');
            $table->string('date'); // YYYY-MM format
            $table->string('expiry_date')->nullable(); // YYYY-MM format
            $table->string('credential_id')->nullable();
            $table->string('url', 500)->nullable();
            $table->integer('order')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cv_certifications');
    }
};
