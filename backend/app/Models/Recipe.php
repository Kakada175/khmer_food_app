<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Recipe extends Model
{
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id',
        'nameKhmer',
        'nameEnglish',
        'localName',
        'descriptionKhmer',
        'descriptionEnglish',
        'provinceId',
        'provinceName',
        'categoryId',
        'categoryName',
        'difficulty',
        'prepTimeMinutes',
        'cookTimeMinutes',
        'servingSize',
        'historyBackgroundKhmer',
        'historyBackgroundEnglish',
        'culturalSignificance',
        'traditionalEvents',
        'originStory',
        'coverImageUrl',
        'galleryImages',
        'youtubeVideoUrl',
        'videoThumbnailUrl',
        'rating',
        'reviewCount',
        'viewCount',
        'favoriteCount',
        'isFeatured',
        'isPopular',
        'isTraditional',
        'isFestival',
        'festivalName',
        'isVegetarian',
        'isSpicy',
        'isHalalFriendly',
        'isGlutenFree',
        'nutrition',
    ];

    protected $casts = [
        'galleryImages' => 'array',
        'nutrition' => 'array',
        'isFeatured' => 'boolean',
        'isPopular' => 'boolean',
        'isTraditional' => 'boolean',
        'isFestival' => 'boolean',
        'isVegetarian' => 'boolean',
        'isSpicy' => 'boolean',
        'isHalalFriendly' => 'boolean',
        'isGlutenFree' => 'boolean',
        'rating' => 'double',
        'reviewCount' => 'integer',
        'viewCount' => 'integer',
        'favoriteCount' => 'integer',
        'prepTimeMinutes' => 'integer',
        'cookTimeMinutes' => 'integer',
        'servingSize' => 'integer',
    ];

    public function ingredients()
    {
        return $this->hasMany(RecipeIngredient::class, 'recipe_id', 'id');
    }

    public function cookingSteps()
    {
        return $this->hasMany(RecipeStep::class, 'recipe_id', 'id');
    }

    public function reviews()
    {
        return $this->hasMany(Review::class, 'recipe_id', 'id');
    }

    public function category()
    {
        return $this->belongsTo(Category::class, 'categoryId', 'id');
    }

    public function province()
    {
        return $this->belongsTo(Province::class, 'provinceId', 'id');
    }

    public function favoritedBy()
    {
        return $this->belongsToMany(User::class, 'user_favorites', 'recipe_id', 'user_id');
    }
}
