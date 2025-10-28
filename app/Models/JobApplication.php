<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class JobApplication extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'job_id',
        'cv_id',
        'cover_letter',
        'status',
        'applied_at',
        'reviewed_at',
        'notes',
    ];

    protected $casts = [
        'applied_at' => 'datetime',
        'reviewed_at' => 'datetime',
    ];

    /**
     * Get the user who submitted the application.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the job this application is for.
     */
    public function job(): BelongsTo
    {
        return $this->belongsTo(Job::class);
    }

    /**
     * Get the CV attached to this application.
     */
    public function cv(): BelongsTo
    {
        return $this->belongsTo(UserCv::class, 'cv_id');
    }

    /**
     * Scope to filter by status.
     */
    public function scopeStatus($query, string $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope to filter pending applications.
     */
    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    /**
     * Scope to filter reviewed applications.
     */
    public function scopeReviewed($query)
    {
        return $query->where('status', 'reviewed');
    }

    /**
     * Scope to filter accepted applications.
     */
    public function scopeAccepted($query)
    {
        return $query->where('status', 'accepted');
    }

    /**
     * Scope to filter rejected applications.
     */
    public function scopeRejected($query)
    {
        return $query->where('status', 'rejected');
    }

    /**
     * Scope to filter by user.
     */
    public function scopeByUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Scope to filter by job.
     */
    public function scopeByJob($query, int $jobId)
    {
        return $query->where('job_id', $jobId);
    }

    /**
     * Check if application is pending.
     */
    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    /**
     * Check if application is accepted.
     */
    public function isAccepted(): bool
    {
        return $this->status === 'accepted';
    }

    /**
     * Check if application is rejected.
     */
    public function isRejected(): bool
    {
        return $this->status === 'rejected';
    }

    /**
     * Mark application as reviewed.
     */
    public function markAsReviewed(): void
    {
        $this->update([
            'status' => 'reviewed',
            'reviewed_at' => now(),
        ]);
    }

    /**
     * Accept the application.
     */
    public function accept(?string $notes = null): void
    {
        $this->update([
            'status' => 'accepted',
            'reviewed_at' => now(),
            'notes' => $notes,
        ]);
    }

    /**
     * Reject the application.
     */
    public function reject(?string $notes = null): void
    {
        $this->update([
            'status' => 'rejected',
            'reviewed_at' => now(),
            'notes' => $notes,
        ]);
    }
}
