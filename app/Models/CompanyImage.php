<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CompanyImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'path',
        'type',
        'is_primary',
        'order',
    ];

    protected $casts = [
        'is_primary' => 'boolean',
        'order' => 'integer',
    ];

    protected $appends = [
        'url',
    ];

    /**
     * Get the company that owns this image.
     */
    public function company(): BelongsTo
    {
        return $this->belongsTo(Company::class);
    }

    /**
     * Get the full URL of the image.
     */
    public function getUrlAttribute(): string
    {
        return url('storage/'.$this->path);
    }
}
