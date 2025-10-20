<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    /**
     * Get the jobs posted by this user.
     */
    public function jobs()
    {
        return $this->hasMany(Job::class);
    }

    /**
     * Get the companies owned by this user.
     */
    public function ownedCompanies()
    {
        return $this->belongsToMany(Company::class, 'company_owners')
            ->withPivot('is_primary')
            ->withTimestamps();
    }

    /**
     * Get the search history for this user.
     */
    public function searchHistory()
    {
        return $this->hasMany(SearchHistory::class);
    }

    /**
     * Get the CVs created by this user.
     */
    public function cvs()
    {
        return $this->hasMany(UserCv::class);
    }

    /**
     * Get the primary CV for this user.
     */
    public function primaryCv()
    {
        return $this->hasOne(UserCv::class)->where('is_primary', true);
    }

    /**
     * Check if user owns a specific company.
     */
    public function ownsCompany(Company $company): bool
    {
        return $this->ownedCompanies()->where('company_id', $company->id)->exists();
    }
}
