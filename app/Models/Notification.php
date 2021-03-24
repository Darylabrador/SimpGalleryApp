<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'label',
        'isRead'
    ];

    /**
     * Notification belong to an user
     */
    public function user()
    {
        return $this->belongsTo('App\Models\User', 'user_id', 'id');
    }
}
