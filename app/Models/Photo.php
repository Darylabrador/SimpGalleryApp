<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Photo extends Model
{
    use HasFactory, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'album_id',
        'label'
    ];


    /**
     * A photo belong to an album
     */
    public function album()
    {
        return $this->belongsTo('App\Models\Album', 'album_id', 'id');
    }


    /**
     * a photo has many reactions
     */
    public function reactions()
    {
        return $this->hasMany('App\Models\Reaction');
    }


    /**
     * a photo has many comments
     */
    public function comments()
    {
        return $this->hasMany('App\Models\Comment');
    }
}
