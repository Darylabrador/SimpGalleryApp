<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Invitation extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'email',
        'album_id'
    ];


    /**
     * An invitation belong to many album
     */
    public function album()
    {
        return $this->belongsTo('App\Models\Album', 'album_id', 'id');
    }
}
