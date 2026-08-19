<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RecipeStep extends Model
{
    protected $fillable = [
        'recipe_id',
        'stepNumber',
        'title',
        'descriptionKhmer',
        'descriptionEnglish',
        'photoUrl',
    ];

    protected $casts = [
        'stepNumber' => 'integer',
    ];

    public function recipe()
    {
        return $this->belongsTo(Recipe::class, 'recipe_id', 'id');
    }
}
