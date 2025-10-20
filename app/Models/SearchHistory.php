<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SearchHistory extends Model
{
    use HasFactory;

    protected $table = 'search_history';

    protected $fillable = [
        'user_id',
        'search_query',
        'location',
        'filters',
        'results_count',
        'ip_address',
        'user_agent',
        'session_id',
    ];

    protected $casts = [
        'filters' => 'array',
        'results_count' => 'integer',
    ];

    /**
     * Get the user that made this search.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
