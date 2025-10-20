<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Carbon\Carbon;

class CvEducation extends Model
{
    use HasFactory;

    protected $table = 'cv_education';

    protected $fillable = [
        'user_cv_id',
        'degree',
        'field',
        'institution',
        'location',
        'start_date',
        'end_date',
        'gpa',
        'description',
        'order',
    ];

    protected $casts = [
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
     * Get the CV that owns this education.
     */
    public function userCv(): BelongsTo
    {
        return $this->belongsTo(UserCv::class);
    }
}