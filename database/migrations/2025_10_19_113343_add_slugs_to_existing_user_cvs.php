<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Update existing user_cvs records that don't have a slug
        $cvs = DB::table('user_cvs')->whereNull('slug')->orWhere('slug', '')->get();
        
        foreach ($cvs as $cv) {
            $baseSlug = $cv->title ?: $cv->full_name;
            $slug = Str::slug($baseSlug) . '-' . Str::random(8);
            
            // Ensure uniqueness
            while (DB::table('user_cvs')->where('slug', $slug)->exists()) {
                $slug = Str::slug($baseSlug) . '-' . Str::random(8);
            }
            
            DB::table('user_cvs')
                ->where('id', $cv->id)
                ->update(['slug' => $slug]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // No need to reverse this
    }
};
