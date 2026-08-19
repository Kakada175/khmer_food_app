<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'recipe_id',
        'userName',
        'userAvatar',
        'rating',
        'comment',
        'date',
        'photoUrl',
    ];

    protected $casts = [
        'rating' => 'double',
    ];

    public function recipe()
    {
        return $this->belongsTo(Recipe::class, 'recipe_id', 'id');
    }
}
