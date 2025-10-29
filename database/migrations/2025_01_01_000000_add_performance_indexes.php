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
        // Add missing composite indexes for better query performance

        // Jobs table - composite indexes for common queries
        Schema::table('jobs', function (Blueprint $table) {
            // For filtering active jobs by location
            $table->index(['is_active', 'location'], 'idx_jobs_active_location');
            // For filtering active jobs by employment type
            $table->index(['is_active', 'employment_type'], 'idx_jobs_active_type');
            // For featured and active jobs
            $table->index(['is_featured', 'is_active'], 'idx_jobs_featured_active');
            // For expiry date queries
            $table->index('expires_at', 'idx_jobs_expires_at');
        });

        // Companies table - additional useful indexes
        Schema::table('companies', function (Blueprint $table) {
            // For active and verified companies
            $table->index(['is_active', 'is_verified'], 'idx_companies_active_verified');
            // For hiring companies
            $table->index(['is_hiring', 'is_active'], 'idx_companies_hiring_active');
        });

        // Job applications table - indexes for user and job queries
        if (Schema::hasTable('job_applications')) {
            Schema::table('job_applications', function (Blueprint $table) {
                // Check if columns exist before adding indexes
                if (Schema::hasColumn('job_applications', 'user_id')) {
                    $table->index('user_id', 'idx_job_applications_user_id');
                }
                if (Schema::hasColumn('job_applications', 'job_id')) {
                    $table->index('job_id', 'idx_job_applications_job_id');
                }
                if (Schema::hasColumn('job_applications', 'status')) {
                    $table->index('status', 'idx_job_applications_status');
                }
                if (Schema::hasColumn('job_applications', 'created_at')) {
                    $table->index('created_at', 'idx_job_applications_created_at');
                }
            });
        }

        // Saved jobs table
        if (Schema::hasTable('saved_jobs')) {
            Schema::table('saved_jobs', function (Blueprint $table) {
                if (Schema::hasColumn('saved_jobs', 'user_id')) {
                    $table->index('user_id', 'idx_saved_jobs_user_id');
                }
                if (Schema::hasColumn('saved_jobs', 'job_id')) {
                    $table->index('job_id', 'idx_saved_jobs_job_id');
                }
            });
        }

        // User CVs table
        if (Schema::hasTable('user_cvs')) {
            Schema::table('user_cvs', function (Blueprint $table) {
                if (Schema::hasColumn('user_cvs', 'user_id')) {
                    $table->index('user_id', 'idx_user_cvs_user_id');
                }
                if (Schema::hasColumn('user_cvs', 'is_public')) {
                    $table->index('is_public', 'idx_user_cvs_is_public');
                }
                if (Schema::hasColumn('user_cvs', 'created_at')) {
                    $table->index('created_at', 'idx_user_cvs_created_at');
                }
            });
        }

        // Users table
        Schema::table('users', function (Blueprint $table) {
            if (Schema::hasColumn('users', 'user_type')) {
                $table->index('user_type', 'idx_users_user_type');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Jobs table
        Schema::table('jobs', function (Blueprint $table) {
            $table->dropIndex('idx_jobs_active_location');
            $table->dropIndex('idx_jobs_active_type');
            $table->dropIndex('idx_jobs_featured_active');
            $table->dropIndex('idx_jobs_expires_at');
        });

        // Companies table
        Schema::table('companies', function (Blueprint $table) {
            $table->dropIndex('idx_companies_active_verified');
            $table->dropIndex('idx_companies_hiring_active');
        });

        // Job applications table
        if (Schema::hasTable('job_applications')) {
            Schema::table('job_applications', function (Blueprint $table) {
                $table->dropIndex('idx_job_applications_user_id');
                $table->dropIndex('idx_job_applications_job_id');
                $table->dropIndex('idx_job_applications_status');
                $table->dropIndex('idx_job_applications_created_at');
            });
        }

        // Saved jobs table
        if (Schema::hasTable('saved_jobs')) {
            Schema::table('saved_jobs', function (Blueprint $table) {
                $table->dropIndex('idx_saved_jobs_user_id');
                $table->dropIndex('idx_saved_jobs_job_id');
            });
        }

        // User CVs table
        if (Schema::hasTable('user_cvs')) {
            Schema::table('user_cvs', function (Blueprint $table) {
                $table->dropIndex('idx_user_cvs_user_id');
                $table->dropIndex('idx_user_cvs_is_public');
                $table->dropIndex('idx_user_cvs_created_at');
            });
        }

        // Users table
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex('idx_users_user_type');
        });
    }
};
