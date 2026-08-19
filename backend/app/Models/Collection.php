<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Collection extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'userId',
        'title',
        'description',
        'coverImageUrl',
        'isDefault',
    ];

    protected $casts = [
        'isDefault' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'userId', 'id');
    }

    public function recipes()
    {
        return $this->belongsToMany(Recipe::class, 'collection_recipe', 'collection_id', 'recipe_id');
    }
}
