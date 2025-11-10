<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'user_type',
        'profile_photo',
        'headline',
        'gender',
        'date_of_birth',
        'nationality',
        'city',
        'country',
        'address',
        'phone_number',
        'linkedin_url',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'date_of_birth' => 'date',
        ];
    }

    /**
     * Boot the model.
     */
    protected static function boot()
    {
        parent::boot();

        static::deleting(function ($user) {
            // Delete profile photo if exists
            if ($user->profile_photo) {
                Storage::disk('public')->delete($user->profile_photo);
            }

            // For company owners: Handle company and related data deletion
            if ($user->user_type === 'company_owner') {
                // Load companies with their relationships
                $companies = $user->ownedCompanies()->with('images')->get();

                foreach ($companies as $company) {
                    // Check if this user is the only owner
                    $ownerCount = $company->owners()->count();

                    if ($ownerCount === 1) {
                        // First, delete all company images from storage
                        foreach ($company->images as $image) {
                            if ($image->path) {
                                Storage::disk('public')->delete($image->path);
                            }
                            $image->delete();
                        }

                        // Then delete the company (this will cascade delete jobs, job_applications, etc.)
                        $company->delete();
                    }
                    // If there are multiple owners, the pivot table entry will be
                    // automatically deleted by the cascade constraint when user is deleted
                }
            }

            // For job seekers: Delete CVs and associated files
            if ($user->user_type === 'job_seeker') {
                foreach ($user->cvs as $cv) {
                    if ($cv->profile_image_path) {
                        Storage::disk('public')->delete($cv->profile_image_path);
                    }
                    // CV deletion will cascade delete related CV entries
                    $cv->delete();
                }
            }

            // Delete user's authentication tokens
            $user->tokens()->delete();

            // Note: The following will be automatically cascade deleted by database constraints:
            // - company_owners entries
            // - job_applications
            // - saved_jobs
            // - search_history
            // - user_cvs (if not already deleted above)
        });
    }

    /**
     * Get the jobs posted by this user.
     */
    public function jobs(): HasMany
    {
        return $this->hasMany(Job::class);
    }

    /**
     * Get the companies owned by this user.
     */
    public function ownedCompanies(): BelongsToMany
    {
        return $this->belongsToMany(Company::class, 'company_owners')
            ->withPivot('is_primary')
            ->withTimestamps();
    }

    /**
     * Get the search history for this user.
     */
    public function searchHistory(): HasMany
    {
        return $this->hasMany(SearchHistory::class);
    }

    /**
     * Get the CVs created by this user.
     */
    public function cvs(): HasMany
    {
        return $this->hasMany(UserCv::class);
    }

    /**
     * Get the primary CV for this user.
     */
    public function primaryCv(): HasOne
    {
        return $this->hasOne(UserCv::class)->where('is_primary', true);
    }

    /**
     * Get the jobs saved by this user.
     */
    public function savedJobs(): BelongsToMany
    {
        return $this->belongsToMany(Job::class, 'saved_jobs')
            ->withTimestamps();
    }

    /**
     * Check if user owns a specific company.
     */
    public function ownsCompany(Company $company): bool
    {
        return $this->ownedCompanies()->where('company_id', $company->id)->exists();
    }
}
