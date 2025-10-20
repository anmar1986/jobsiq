<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Carbon\Carbon;

class CvCertification extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_cv_id',
        'name',
        'issuer',
        'date',
        'expiry_date',
        'credential_id',
        'url',
        'order',
    ];

    protected $casts = [
        'order' => 'integer',
        'date' => 'date:Y-m-d',
        'expiry_date' => 'date:Y-m-d',
    ];

    protected $appends = ['formatted_date', 'formatted_expiry_date'];

    /**
     * Get the formatted issue date (dd.mm.yyyy).
     */
    protected function formattedDate(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->date ? Carbon::parse($this->date)->format('d.m.Y') : null,
        );
    }

    /**
     * Get the formatted expiry date (dd.mm.yyyy).
     */
    protected function formattedExpiryDate(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->expiry_date ? Carbon::parse($this->expiry_date)->format('d.m.Y') : null,
        );
    }

    /**
     * Get the CV that owns this certification.
     */
    public function userCv(): BelongsTo
    {
        return $this->belongsTo(UserCv::class);
    }
}