<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Blog extends Model
{
    /** @use HasFactory<\Database\Factories\BlogFactory> */
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'slug',
        'excerpt',
        'content',
        'featured_image',
        'category',
        'tags',
        'status',
        'published_at',
        'views',
    ];

    protected $casts = [
        'tags' => 'array',
        'published_at' => 'datetime',
        'views' => 'integer',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($blog) {
            if (empty($blog->slug)) {
                $originalSlug = Str::slug($blog->title);

                // Batch check for existing slugs to avoid N+1 queries
                $possibleSlugs = [$originalSlug];
                for ($i = 1; $i <= 20; $i++) {
                    $possibleSlugs[] = $originalSlug.'-'.$i;
                }

                $existingSlugs = static::whereIn('slug', $possibleSlugs)->pluck('slug')->all();
                $slugSet = array_flip($existingSlugs);

                $slug = $originalSlug;
                foreach ($possibleSlugs as $candidate) {
                    if (! isset($slugSet[$candidate])) {
                        $slug = $candidate;
                        break;
                    }
                }

                $blog->slug = $slug;
            }
        });
    }

    /**
     * Get the author of the blog post.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Scope to only include published blogs.
     */
    public function scopePublished($query)
    {
        return $query->where('status', 'published')
            ->whereNotNull('published_at')
            ->where('published_at', '<=', now());
    }

    /**
     * Scope to order by latest published.
     */
    public function scopeLatest($query)
    {
        return $query->orderBy('published_at', 'desc');
    }

    /**
     * Increment views count.
     */
    public function incrementViews(): void
    {
        $this->increment('views');
    }
}
