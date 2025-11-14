<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Job extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'user_id',
        'title',
        'slug',
        'description',
        'requirements',
        'benefits',
        'location',
        'city',
        'country',
        'employment_type',
        'experience_level',
        'category',
        'salary_min',
        'salary_max',
        'salary_currency',
        'salary_period',
        'is_remote',
        'is_featured',
        'is_active',
        'skills',
        'expires_at',
        'published_at',
    ];

    protected $casts = [
        'is_remote' => 'boolean',
        'is_featured' => 'boolean',
        'is_active' => 'boolean',
        'skills' => 'array',
        'salary_min' => 'decimal:2',
        'salary_max' => 'decimal:2',
        'expires_at' => 'date',
        'published_at' => 'datetime',
    ];

    protected $appends = ['is_saved', 'is_applied'];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($job) {
            if (empty($job->slug)) {
                $job->slug = Str::slug($job->title.'-'.Str::random(6));
            }
            if (empty($job->published_at)) {
                $job->published_at = now();
            }
            // Auto-set expiration to configurable number of days from posting date if not provided
            if (empty($job->expires_at)) {
                $expirationDays = config('job.default_expiration_days', 30);
                $job->expires_at = now()->addDays($expirationDays);
            }
        });
    }

    /**
     * Get the company that owns this job.
     */
    public function company(): BelongsTo
    {
        return $this->belongsTo(Company::class);
    }

    /**
     * Get the user who posted this job.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get all applications for this job.
     */
    public function applications()
    {
        return $this->hasMany(JobApplication::class);
    }

    /**
     * Scope a query to only include active jobs.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true)
            ->where(function ($q) {
                $q->whereNull('expires_at')
                    ->orWhere('expires_at', '>=', now());
            });
    }

    /**
     * Scope a query to only include published jobs.
     */
    public function scopePublished($query)
    {
        return $query->whereNotNull('published_at')
            ->where('published_at', '<=', now());
    }

    /**
     * Scope a query to filter by search term.
     */
    public function scopeSearch($query, ?string $term)
    {
        if (! $term) {
            return $query;
        }

        return $query->where(function ($q) use ($term) {
            $q->where('title', 'like', "%{$term}%")
                ->orWhere('description', 'like', "%{$term}%")
                ->orWhereHas('company', function ($companyQuery) use ($term) {
                    $companyQuery->where('name', 'like', "%{$term}%");
                });
        });
    }

    /**
     * Scope a query to filter by location.
     */
    public function scopeLocation($query, ?string $location)
    {
        if (! $location) {
            return $query;
        }

        return $query->where(function ($q) use ($location) {
            $q->where('location', 'like', "%{$location}%")
                ->orWhere('city', 'like', "%{$location}%")
                ->orWhere('country', 'like', "%{$location}%");
        });
    }

    /**
     * Scope a query to filter by employment type.
     */
    public function scopeEmploymentType($query, $types)
    {
        if (empty($types)) {
            return $query;
        }

        return $query->whereIn('employment_type', (array) $types);
    }

    /**
     * Scope a query to filter by experience level.
     */
    public function scopeExperienceLevel($query, $levels)
    {
        if (empty($levels)) {
            return $query;
        }

        return $query->whereIn('experience_level', (array) $levels);
    }

    /**
     * Scope a query to filter by remote jobs.
     */
    public function scopeRemote($query, ?bool $isRemote)
    {
        if ($isRemote === null) {
            return $query;
        }

        return $query->where('is_remote', $isRemote);
    }

    /**
     * Get formatted salary range.
     */
    public function getSalaryRangeAttribute(): ?string
    {
        if (! $this->salary_min && ! $this->salary_max) {
            return null;
        }

        $currency = $this->salary_currency;
        $min = $this->salary_min ? number_format((float) $this->salary_min, 0) : null;
        $max = $this->salary_max ? number_format((float) $this->salary_max, 0) : null;

        if ($min && $max) {
            return "{$currency} {$min} - {$max}";
        }

        return $min ? "{$currency} {$min}+" : "{$currency} {$max}";
    }

    /**
     * Check if the job is saved by the authenticated user.
     */
    public function getIsSavedAttribute(): bool
    {
        $user = auth('sanctum')->user();

        if (!$user) {
            return false;
        }

        return SavedJob::where('user_id', $user->id)
            ->where('job_id', $this->id)
            ->exists();
    }

    /**
     * Check if the authenticated user has applied to this job.
     */
    public function getIsAppliedAttribute(): bool
    {
        $user = auth('sanctum')->user();

        if (!$user) {
            return false;
        }

        return JobApplication::where('user_id', $user->id)
            ->where('job_id', $this->id)
            ->exists();
    }
}
