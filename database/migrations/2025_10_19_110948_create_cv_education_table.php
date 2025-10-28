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
        Schema::create('cv_education', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_cv_id')->constrained('user_cvs')->onDelete('cascade');
            $table->string('degree');
            $table->string('field');
            $table->string('institution');
            $table->string('location')->nullable();
            $table->string('start_date'); // YYYY-MM format
            $table->string('end_date')->nullable(); // YYYY-MM format
            $table->text('description')->nullable();
            $table->integer('order')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cv_education');
    }
};
