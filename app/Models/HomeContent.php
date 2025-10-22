<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HomeContent extends Model
{
    use HasFactory;

    protected $fillable = [
        'section',
        'title',
        'subtitle',
        'content',
        'data',
        'is_active',
        'order',
    ];

    protected $casts = [
        'data' => 'array',
        'is_active' => 'boolean',
    ];

    /**
     * Scope to only include active content.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope to order by order column.
     */
    public function scopeOrdered($query)
    {
        return $query->orderBy('order');
    }

    /**
     * Get content by section.
     */
    public static function getSection(string $section)
    {
        return static::where('section', $section)
            ->active()
            ->ordered()
            ->get();
    }

    /**
     * Get all home page content grouped by section.
     */
    public static function getAllContent()
    {
        return static::active()
            ->ordered()
            ->get()
            ->groupBy('section');
    }
}
