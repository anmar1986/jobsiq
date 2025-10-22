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
        'legal_name',
        'description',
        'tagline',

        // Contact Information
        'email',
        'phone',
        'fax',
        'website',

        // Address
        'street',
        'street_2',
        'city',
        'state',
        'country',
        'postal_code',
        'latitude',
        'longitude',

        // Business Information
        'industry',
        'company_size',
        'company_type',
        'founded_date',
        'registration_number',
        'tax_id',

        // Social Media
        'linkedin',
        'twitter',
        'facebook',
        'instagram',
        'youtube',
        'github',

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
        'total_jobs_posted',
        'profile_views',

        // Additional
        'timezone',
        'languages',
        'locations',
        'why_work_here',
        'funding_amount',
        'funding_currency',
    ];

    protected $casts = [
        'benefits' => 'array',
        'values' => 'array',
        'perks' => 'array',
        'keywords' => 'array',
        'languages' => 'array',
        'locations' => 'array',
        'is_verified' => 'boolean',
        'is_featured' => 'boolean',
        'is_active' => 'boolean',
        'is_hiring' => 'boolean',
        'founded_date' => 'date',
        'funding_amount' => 'decimal:2',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'total_employees' => 'integer',
        'active_jobs_count' => 'integer',
        'total_jobs_posted' => 'integer',
        'profile_views' => 'integer',
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
            $this->street_2,
            $this->city,
            $this->state,
            $this->postal_code,
            $this->country,
        ]);

        return implode(', ', $parts);
    }

    /**
     * Get formatted funding amount.
     */
    public function getFormattedFundingAttribute(): ?string
    {
        if (! $this->funding_amount) {
            return null;
        }

        $symbols = [
            'USD' => '$',
            'EUR' => '€',
            'GBP' => '£',
        ];

        $symbol = $symbols[$this->funding_currency] ?? $this->funding_currency;

        if ($this->funding_amount >= 1000000) {
            return $symbol.number_format((float) $this->funding_amount / 1000000, 1).'M';
        } elseif ($this->funding_amount >= 1000) {
            return $symbol.number_format((float) $this->funding_amount / 1000, 1).'K';
        }

        return $symbol.number_format((float) $this->funding_amount, 2);
    }

    /**
     * Increment profile views.
     */
    public function incrementViews(): void
    {
        $this->increment('profile_views');
    }
}
