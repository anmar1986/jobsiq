<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CvLanguage extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_cv_id',
        'language',
        'proficiency',
        'order',
    ];

    protected $casts = [
        'order' => 'integer',
    ];

    /**
     * Get the CV that owns this language.
     */
    public function userCv(): BelongsTo
    {
        return $this->belongsTo(UserCv::class);
    }
}
