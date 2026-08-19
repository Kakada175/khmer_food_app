<?php

namespace App\Http\Controllers;

use App\Models\Recipe;
use App\Models\RecipeIngredient;
use App\Models\RecipeStep;
use App\Models\Review;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Str;

class RecipeController extends Controller
{
    /**
     * Display a listing of the recipes with their relationships.
     */
    public function index(): JsonResponse
    {
        $recipes = Recipe::with(['ingredients', 'cookingSteps', 'reviews'])
            ->orderBy('isFeatured', 'desc')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($recipes);
    }

    /**
     * Store a newly created recipe in the database.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id' => 'required|string',
            'nameKhmer' => 'required|string',
            'nameEnglish' => 'required|string',
            'localName' => 'required|string',
            'descriptionKhmer' => 'required|string',
            'descriptionEnglish' => 'required|string',
            'provinceId' => 'required|string',
            'provinceName' => 'required|string',
            'categoryId' => 'required|string',
            'categoryName' => 'required|string',
            'difficulty' => 'required|string',
            'prepTimeMinutes' => 'required|integer',
            'cookTimeMinutes' => 'required|integer',
            'servingSize' => 'required|integer',
            'historyBackgroundKhmer' => 'required|string',
            'historyBackgroundEnglish' => 'required|string',
            'culturalSignificance' => 'required|string',
            'traditionalEvents' => 'required|string',
            'originStory' => 'required|string',
            'coverImageUrl' => 'required|string',
            'galleryImages' => 'array',
            'youtubeVideoUrl' => 'nullable|string',
            'videoThumbnailUrl' => 'nullable|string',
            'rating' => 'numeric',
            'reviewCount' => 'integer',
            'viewCount' => 'integer',
            'favoriteCount' => 'integer',
            'isFeatured' => 'boolean',
            'isPopular' => 'boolean',
            'isTraditional' => 'boolean',
            'isFestival' => 'boolean',
            'festivalName' => 'nullable|string',
            'isVegetarian' => 'boolean',
            'isSpicy' => 'boolean',
            'isHalalFriendly' => 'boolean',
            'isGlutenFree' => 'boolean',
            'nutrition' => 'required|array',
            'ingredients' => 'array',
            'cookingSteps' => 'array',
        ]);

        $recipe = Recipe::create([
            'id' => $data['id'],
            'nameKhmer' => $data['nameKhmer'],
            'nameEnglish' => $data['nameEnglish'],
            'localName' => $data['localName'],
            'descriptionKhmer' => $data['descriptionKhmer'],
            'descriptionEnglish' => $data['descriptionEnglish'],
            'provinceId' => $data['provinceId'],
            'provinceName' => $data['provinceName'],
            'categoryId' => $data['categoryId'],
            'categoryName' => $data['categoryName'],
            'difficulty' => $data['difficulty'],
            'prepTimeMinutes' => $data['prepTimeMinutes'],
            'cookTimeMinutes' => $data['cookTimeMinutes'],
            'servingSize' => $data['servingSize'],
            'historyBackgroundKhmer' => $data['historyBackgroundKhmer'],
            'historyBackgroundEnglish' => $data['historyBackgroundEnglish'],
            'culturalSignificance' => $data['culturalSignificance'],
            'traditionalEvents' => $data['traditionalEvents'],
            'originStory' => $data['originStory'],
            'coverImageUrl' => $data['coverImageUrl'],
            'galleryImages' => $data['galleryImages'] ?? [],
            'youtubeVideoUrl' => $data['youtubeVideoUrl'] ?? null,
            'videoThumbnailUrl' => $data['videoThumbnailUrl'] ?? null,
            'rating' => $data['rating'] ?? 5.0,
            'reviewCount' => $data['reviewCount'] ?? 0,
            'viewCount' => $data['viewCount'] ?? 0,
            'favoriteCount' => $data['favoriteCount'] ?? 0,
            'isFeatured' => $data['isFeatured'] ?? false,
            'isPopular' => $data['isPopular'] ?? false,
            'isTraditional' => $data['isTraditional'] ?? true,
            'isFestival' => $data['isFestival'] ?? false,
            'festivalName' => $data['festivalName'] ?? null,
            'isVegetarian' => $data['isVegetarian'] ?? false,
            'isSpicy' => $data['isSpicy'] ?? false,
            'isHalalFriendly' => $data['isHalalFriendly'] ?? false,
            'isGlutenFree' => $data['isGlutenFree'] ?? false,
            'nutrition' => $data['nutrition'],
        ]);

        if (!empty($data['ingredients'])) {
            foreach ($data['ingredients'] as $ing) {
                RecipeIngredient::create([
                    'recipe_id' => $recipe->id,
                    'nameKhmer' => $ing['nameKhmer'] ?? '',
                    'nameEnglish' => $ing['nameEnglish'] ?? '',
                    'quantity' => $ing['quantity'] ?? '',
                    'measurement' => $ing['measurement'] ?? '',
                ]);
            }
        }

        if (!empty($data['cookingSteps'])) {
            foreach ($data['cookingSteps'] as $step) {
                RecipeStep::create([
                    'recipe_id' => $recipe->id,
                    'stepNumber' => $step['stepNumber'],
                    'title' => $step['title'] ?? null,
                    'descriptionKhmer' => $step['descriptionKhmer'] ?? '',
                    'descriptionEnglish' => $step['descriptionEnglish'] ?? '',
                    'photoUrl' => $step['photoUrl'] ?? null,
                ]);
            }
        }

        return response()->json(Recipe::with(['ingredients', 'cookingSteps', 'reviews'])->find($recipe->id), 201);
    }

    /**
     * Remove the specified recipe from database.
     */
    public function destroy(string $id): JsonResponse
    {
        $recipe = Recipe::findOrFail($id);
        $recipe->delete();

        return response()->json(['message' => 'Recipe deleted successfully']);
    }

    /**
     * Add a review to a recipe and recalculate average rating.
     */
    public function addReview(Request $request, string $id): JsonResponse
    {
        $recipe = Recipe::findOrFail($id);

        $data = $request->validate([
            'userName' => 'required|string',
            'userAvatar' => 'required|string',
            'rating' => 'required|numeric|min:1|max:5',
            'comment' => 'required|string',
            'date' => 'required|string',
            'photoUrl' => 'nullable|string',
        ]);

        $review = Review::create([
            'id' => $request->input('id') ?? ('rev_' . Str::random(10)),
            'recipe_id' => $recipe->id,
            'userName' => $data['userName'],
            'userAvatar' => $data['userAvatar'],
            'rating' => $data['rating'],
            'comment' => $data['comment'],
            'date' => $data['date'],
            'photoUrl' => $data['photoUrl'] ?? null,
        ]);

        // Recalculate stats
        $newReviewCount = $recipe->reviewCount + 1;
        $newRating = (($recipe->rating * $recipe->reviewCount) + $data['rating']) / $newReviewCount;

        $recipe->update([
            'reviewCount' => $newReviewCount,
            'rating' => round($newRating, 1),
        ]);

        return response()->json($review, 201);
    }
}
