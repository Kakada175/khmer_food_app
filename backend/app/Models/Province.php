<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Province extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'nameKhmer',
        'nameEnglish',
        'region',
        'descriptionKhmer',
        'descriptionEnglish',
        'imageUrl',
        'famousFoodIds',
        'famousDesserts',
        'localIngredients',
        'foodFestivals',
    ];

    protected $casts = [
        'famousFoodIds' => 'array',
        'famousDesserts' => 'array',
        'localIngredients' => 'array',
        'foodFestivals' => 'array',
    ];
}
