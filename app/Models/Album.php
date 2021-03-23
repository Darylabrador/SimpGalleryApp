<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Album extends Model
{
    use HasFactory, SoftDeletes;

    public $directory = 'cover/';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'label',
        'cover',
        'shareToken',
        'share_at'
    ];

    /**
     * An album belong to an user
     */
    public function user()
    {
        return $this->belongsTo('App\Models\User', 'user_id', 'id');
    }

    /**
     * An album has many photos
     */
    public function photos()
    {
        return $this->hasMany('App\Models\Photo');
    }


    /**
     * An album has many invitations
     */
    public function invitations()
    {
        return $this->hasMany('App\Models\Invitation');
    }


    /**
     * An album has many access to other user
     */
    public function albumAccesses()
    {
        return $this->hasMany('App\Models\Access');
    }

    /**
     * Accessor for cover image
     */
    public function getCoverAttribute($value)
    {
        return $this->directory . $value;
    }
}
