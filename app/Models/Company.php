<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Support\Str;

class Company extends Model
{
    use HasFactory;

    protected $fillable = [
        // Basic Information
        'name',
        'slug',
        'about',
        'description',
        'tagline',

        // Contact Information
        'email',
        'phone',
        'website',

        // Address
        'street',
        'city',
        'country',
        'postal_code',

        // Business Information
        'industry',
        'company_size',
        'company_type',
        'founded_date',

        // Social Media
        'linkedin',
        'twitter',
        'facebook',
        'instagram',
        'youtube',

        // Company Culture
        'benefits',
        'values',
        'perks',
        'culture_description',

        // Status
        'is_verified',
        'is_featured',
        'is_active',
        'is_hiring',

        // SEO
        'meta_title',
        'meta_description',
        'keywords',

        // Statistics
        'total_employees',
        'active_jobs_count',
    ];

    protected $casts = [
        'benefits' => 'array',
        'values' => 'array',
        'perks' => 'array',
        'keywords' => 'array',
        'is_verified' => 'boolean',
        'is_featured' => 'boolean',
        'is_active' => 'boolean',
        'is_hiring' => 'boolean',
        'founded_date' => 'date',
        'total_employees' => 'integer',
        'active_jobs_count' => 'integer',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($company) {
            if (empty($company->slug)) {
                $company->slug = Str::slug($company->name);
            }
        });
    }

    /**
     * Get the jobs for this company.
     */
    public function jobs(): HasMany
    {
        return $this->hasMany(Job::class);
    }

    /**
     * Get the images for this company.
     */
    public function images(): HasMany
    {
        return $this->hasMany(CompanyImage::class);
    }

    /**
     * Get the primary logo for this company.
     */
    public function logo(): HasOne
    {
        return $this->hasOne(CompanyImage::class)
            ->where('type', 'logo')
            ->where('is_primary', true);
    }

    /**
     * Get the cover image for this company.
     */
    public function cover(): HasOne
    {
        return $this->hasOne(CompanyImage::class)
            ->where('type', 'cover')
            ->where('is_primary', true);
    }

    /**
     * Get the owners of this company.
     */
    public function owners(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'company_owners')
            ->withPivot('is_primary')
            ->withTimestamps();
    }

    /**
     * Get the primary owner of this company.
     */
    public function primaryOwner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id')
            ->whereHas('ownedCompanies', function ($query) {
                $query->where('company_id', $this->id)
                    ->where('is_primary', true);
            });
    }

    /**
     * Check if a user is an owner of this company.
     */
    public function isOwnedBy(User $user): bool
    {
        return $this->owners()->where('user_id', $user->id)->exists();
    }

    /**
     * Check if a user is the primary owner of this company.
     */
    public function isPrimaryOwner(User $user): bool
    {
        return $this->owners()
            ->where('user_id', $user->id)
            ->wherePivot('is_primary', true)
            ->exists();
    }

    /**
     * Scope to filter active companies.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope to filter verified companies.
     */
    public function scopeVerified($query)
    {
        return $query->where('is_verified', true);
    }

    /**
     * Scope to filter featured companies.
     */
    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    /**
     * Scope to filter hiring companies.
     */
    public function scopeHiring($query)
    {
        return $query->where('is_hiring', true);
    }

    /**
     * Scope to filter by industry.
     */
    public function scopeIndustry($query, $industry)
    {
        return $query->where('industry', $industry);
    }

    /**
     * Scope to filter by company size.
     */
    public function scopeSize($query, $size)
    {
        return $query->where('company_size', $size);
    }

    /**
     * Get full address as string.
     */
    public function getFullAddressAttribute(): string
    {
        $parts = array_filter([
            $this->street,
            $this->city,
            $this->postal_code,
            $this->country,
        ]);

        return implode(', ', $parts);
    }
}
