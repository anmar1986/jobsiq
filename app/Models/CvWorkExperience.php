<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Carbon\Carbon;

class CvWorkExperience extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_cv_id',
        'position',
        'company',
        'location',
        'start_date',
        'end_date',
        'current',
        'description',
        'achievements',
        'order',
    ];

    protected $casts = [
        'current' => 'boolean',
        'achievements' => 'array',
        'order' => 'integer',
        'start_date' => 'date:Y-m-d',
        'end_date' => 'date:Y-m-d',
    ];

    protected $appends = ['formatted_start_date', 'formatted_end_date'];

    /**
     * Get the formatted start date (dd.mm.yyyy).
     */
    protected function formattedStartDate(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->start_date ? Carbon::parse($this->start_date)->format('d.m.Y') : null,
        );
    }

    /**
     * Get the formatted end date (dd.mm.yyyy).
     */
    protected function formattedEndDate(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->end_date ? Carbon::parse($this->end_date)->format('d.m.Y') : null,
        );
    }

    /**
     * Get the CV that owns this work experience.
     */
    public function userCv(): BelongsTo
    {
        return $this->belongsTo(UserCv::class);
    }
}