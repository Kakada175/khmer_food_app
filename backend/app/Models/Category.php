<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'nameKhmer',
        'nameEnglish',
        'icon',
        'imageUrl',
        'foodCount',
    ];

    public function recipes()
    {
        return $this->hasMany(Recipe::class, 'categoryId', 'id');
    }
}
