<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SavedJob extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'job_id',
    ];

    /**
     * Get the user that saved the job.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the job that was saved.
     */
    public function job(): BelongsTo
    {
        return $this->belongsTo(Job::class);
    }
}
