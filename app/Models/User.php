<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    public $directory = 'profils/';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'pseudo',
        'email',
        'password',
        'profilPic',
        'resetToken',
        'verifyToken',
        'verify_at'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password'
    ];


    /**
     * user has many notifications
     */
    public function notifications() 
    {
        return $this->hasMany('App\Models\Notification');
    }


    /**
     * user can access to many shared albums
     */
    public function albumAccesses()
    {
        return $this->hasMany('App\Models\Access');
    }


    /**
     * user has many albums
     */
    public function albums()
    {
        return $this->hasMany('App\Models\Album');
    }


    /**
     * user has many comments
     */
    public function comments()
    {
        return $this->hasMany('App\Models\Comment');
    }


    /**
     * user has many reactions
     */
    public function reactions()
    {
        return $this->hasMany('App\Models\Reaction');
    }

    /**
     * Accessor for cover image
     */
    public function getProfilPicAttribute($value)
    {
        return $this->directory . $value;
    }
}
