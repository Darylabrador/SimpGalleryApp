<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reaction extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'photo_id',
        'reaction_types_id'
    ];

    /**
     * A reaction belong to an user
     */
    public function user()
    {
        return $this->belongsTo('App\Models\User', 'user_id', 'id');
    }


    /**
     * A reaction belong to a photo
     */
    public function photo()
    {
        return $this->belongsTo('App\Models\Photo', 'photo_id', 'id');
    }


    /**
     * A reaction belong to reaction type
     */
    public function reactionType()
    {
        return $this->belongsTo('App\Models\ReactionType', 'reaction_types_id', 'id');
    }
}
