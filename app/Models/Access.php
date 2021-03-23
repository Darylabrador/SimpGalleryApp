<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Access extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'album_id',
        'user_id',
        'share_token'
    ];

    /**
     * An access belong to an user
     */
    public function user()
    {
        return $this->belongsTo('App\Models\User', 'user_id', 'id');
    }

    /**
     * An access belong to an album
     */
    public function album()
    {
        return $this->belongsTo('App\Models\Album', 'album_id', 'id');
    }
}
