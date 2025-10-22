<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class UserCv extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'slug',
        'full_name',
        'email',
        'phone',
        'website',
        'linkedin',
        'github',
        'profile_image_path',
        'address',
        'city',
        'country',
        'postal_code',
        'work_experience',
        'education',
        'skills',
        'languages',
        'certifications',
        'projects',
        'references',
        'awards',
        'publications',
        'volunteer_work',
        'hobbies',
        'is_public',
        'is_primary',
        'template',
        'settings',
    ];

    protected $casts = [
        'work_experience' => 'array',
        'education' => 'array',
        'skills' => 'array',
        'languages' => 'array',
        'certifications' => 'array',
        'projects' => 'array',
        'references' => 'array',
        'awards' => 'array',
        'publications' => 'array',
        'volunteer_work' => 'array',
        'hobbies' => 'array',
        'settings' => 'array',
        'is_public' => 'boolean',
        'is_primary' => 'boolean',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($cv) {
            if (empty($cv->slug)) {
                $baseSlug = $cv->title ?: $cv->full_name;
                // Use a cleaner slug format: title/name (no random code)
                $originalSlug = Str::slug($baseSlug);

                // Batch check for existing slugs to avoid N+1 queries
                $possibleSlugs = [$originalSlug];
                for ($i = 1; $i <= 20; $i++) {
                    $possibleSlugs[] = $originalSlug . '-' . $i;
                }
                
                $existingSlugs = static::whereIn('slug', $possibleSlugs)->pluck('slug')->all();
                $slugSet = array_flip($existingSlugs);
                
                $slug = $originalSlug;
                foreach ($possibleSlugs as $candidate) {
                    if (!isset($slugSet[$candidate])) {
                        $slug = $candidate;
                        break;
                    }
                }

                $cv->slug = $slug;
            }
        });

        // When setting a CV as primary, unset other primary CVs for this user
        static::saving(function ($cv) {
            if ($cv->is_primary && $cv->isDirty('is_primary')) {
                static::where('user_id', $cv->user_id)
                    ->where('id', '!=', $cv->id)
                    ->update(['is_primary' => false]);
            }
        });
    }

    /**
     * Get the user that owns this CV.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the work experiences for this CV.
     */
    public function workExperiences(): HasMany
    {
        return $this->hasMany(CvWorkExperience::class)->orderBy('order');
    }

    /**
     * Get the education entries for this CV.
     */
    public function educationEntries(): HasMany
    {
        return $this->hasMany(CvEducation::class)->orderBy('order');
    }

    /**
     * Get the certifications for this CV.
     */
    public function certifications(): HasMany
    {
        return $this->hasMany(CvCertification::class)->orderBy('order');
    }

    /**
     * Get the languages for this CV.
     */
    public function languages(): HasMany
    {
        return $this->hasMany(CvLanguage::class)->orderBy('order');
    }

    /**
     * Scope to only include public CVs.
     */
    public function scopePublic($query)
    {
        return $query->where('is_public', true);
    }

    /**
     * Check if CV belongs to user.
     */
    public function belongsToUser(User $user): bool
    {
        return $this->user_id === $user->id;
    }

    /**
     * Get profile_image accessor for frontend compatibility.
     */
    public function getProfileImageAttribute()
    {
        if ($this->profile_image_path) {
            return (object) [
                'path' => $this->profile_image_path,
                'url' => asset('storage/'.$this->profile_image_path),
            ];
        }

        return null;
    }

    /**
     * Get total years of experience.
     */
    public function getTotalExperienceAttribute(): float
    {
        if (! $this->work_experience) {
            return 0;
        }

        $totalMonths = 0;
        foreach ($this->work_experience as $experience) {
            $start = \Carbon\Carbon::parse($experience['start_date'] ?? null);
            $end = $experience['current'] ?? false
                ? now()
                : \Carbon\Carbon::parse($experience['end_date'] ?? null);

            if ($start && $end) {
                $totalMonths += $start->diffInMonths($end);
            }
        }

        return round($totalMonths / 12, 1);
    }
}
