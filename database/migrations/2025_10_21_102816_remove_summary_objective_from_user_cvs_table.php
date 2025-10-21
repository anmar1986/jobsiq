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
        Schema::table('user_cvs', function (Blueprint $table) {
            $table->dropColumn(['summary', 'objective']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('user_cvs', function (Blueprint $table) {
            $table->text('summary')->nullable();
            $table->text('objective')->nullable();
        });
    }
};
