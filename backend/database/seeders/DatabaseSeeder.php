<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Province;
use App\Models\Recipe;
use App\Models\RecipeIngredient;
use App\Models\RecipeStep;
use App\Models\Review;
use App\Models\Collection;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $driver = DB::connection()->getDriverName();
        if ($driver === 'mysql') {
            DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        }

        User::truncate();
        Category::truncate();
        Province::truncate();
        Recipe::truncate();
        RecipeIngredient::truncate();
        RecipeStep::truncate();
        Review::truncate();
        Collection::truncate();
        DB::table('collection_recipe')->truncate();
        DB::table('user_favorites')->truncate();

        if ($driver === 'mysql') {
            DB::statement('SET FOREIGN_KEY_CHECKS=1;');
        }

        // 1. Seed Users
        $users = [
            [
                'id' => 'usr_001',
                'name' => 'Sokha Rith',
                'email' => 'sokha@khmerfood.app',
                'password' => Hash::make('password'),
                'avatar_url' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                'role' => 'registered',
            ],
            [
                'id' => 'usr_admin',
                'name' => 'Master Admin',
                'email' => 'admin@khmerfood.app',
                'password' => Hash::make('password'),
                'avatar_url' => 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80',
                'role' => 'admin',
            ],
            [
                'id' => 'usr_reg',
                'name' => 'Cambodian Foodie',
                'email' => 'user@khmerfood.app',
                'password' => Hash::make('password'),
                'avatar_url' => 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
                'role' => 'registered',
            ]
        ];
        foreach ($users as $u) {
            User::create($u);
        }

        // Seed default favorites for Sokha Rith (usr_001)
        $user1 = User::find('usr_001');
        $user1->favorites()->attach(['food_fish_amok', 'food_pepper_crab']);

        // Seed default favorites for user (usr_reg)
        $user2 = User::find('usr_reg');
        $user2->favorites()->attach(['food_fish_amok']);

        // 2. Seed Categories
        $categoriesPath = database_path('seeders/data/categories.json');
        if (File::exists($categoriesPath)) {
            $categories = json_decode(File::get($categoriesPath), true);
            foreach ($categories as $cat) {
                Category::create([
                    'id' => $cat['id'],
                    'nameKhmer' => $cat['nameKhmer'],
                    'nameEnglish' => $cat['nameEnglish'],
                    'icon' => $cat['icon'],
                    'imageUrl' => $cat['imageUrl'],
                    'foodCount' => $cat['foodCount'] ?? 0,
                ]);
            }
        }

        // 3. Seed Provinces
        $provincesPath = database_path('seeders/data/provinces.json');
        if (File::exists($provincesPath)) {
            $provinces = json_decode(File::get($provincesPath), true);
            foreach ($provinces as $p) {
                Province::create([
                    'id' => $p['id'],
                    'nameKhmer' => $p['nameKhmer'],
                    'nameEnglish' => $p['nameEnglish'],
                    'region' => $p['region'],
                    'descriptionKhmer' => $p['descriptionKhmer'],
                    'descriptionEnglish' => $p['descriptionEnglish'],
                    'imageUrl' => $p['imageUrl'],
                    'famousFoodIds' => $p['famousFoodIds'] ?? [],
                    'famousDesserts' => $p['famousDesserts'] ?? [],
                    'localIngredients' => $p['localIngredients'] ?? [],
                    'foodFestivals' => $p['foodFestivals'] ?? [],
                ]);
            }
        }

        // 4. Seed Recipes (foods)
        $foodsPath = database_path('seeders/data/foods.json');
        if (File::exists($foodsPath)) {
            $foods = json_decode(File::get($foodsPath), true);
            foreach ($foods as $food) {
                $recipe = Recipe::create([
                    'id' => $food['id'],
                    'nameKhmer' => $food['nameKhmer'],
                    'nameEnglish' => $food['nameEnglish'],
                    'localName' => $food['localName'],
                    'descriptionKhmer' => $food['descriptionKhmer'],
                    'descriptionEnglish' => $food['descriptionEnglish'],
                    'provinceId' => $food['provinceId'],
                    'provinceName' => $food['provinceName'],
                    'categoryId' => $food['categoryId'],
                    'categoryName' => $food['categoryName'],
                    'difficulty' => $food['difficulty'],
                    'prepTimeMinutes' => $food['prepTimeMinutes'],
                    'cookTimeMinutes' => $food['cookTimeMinutes'],
                    'servingSize' => $food['servingSize'],
                    'historyBackgroundKhmer' => $food['historyBackgroundKhmer'],
                    'historyBackgroundEnglish' => $food['historyBackgroundEnglish'],
                    'culturalSignificance' => $food['culturalSignificance'] ?? '',
                    'traditionalEvents' => $food['traditionalEvents'] ?? '',
                    'originStory' => $food['originStory'] ?? '',
                    'coverImageUrl' => $food['coverImageUrl'],
                    'galleryImages' => $food['galleryImages'] ?? [],
                    'youtubeVideoUrl' => $food['youtubeVideoUrl'] ?? null,
                    'videoThumbnailUrl' => $food['videoThumbnailUrl'] ?? null,
                    'rating' => $food['rating'] ?? 5.0,
                    'reviewCount' => $food['reviewCount'] ?? 0,
                    'viewCount' => $food['viewCount'] ?? 0,
                    'favoriteCount' => $food['favoriteCount'] ?? 0,
                    'isFeatured' => $food['isFeatured'] ?? false,
                    'isPopular' => $food['isPopular'] ?? false,
                    'isTraditional' => $food['isTraditional'] ?? true,
                    'isFestival' => $food['isFestival'] ?? false,
                    'festivalName' => $food['festivalName'] ?? null,
                    'isVegetarian' => $food['isVegetarian'] ?? false,
                    'isSpicy' => $food['isSpicy'] ?? false,
                    'isHalalFriendly' => $food['isHalalFriendly'] ?? false,
                    'isGlutenFree' => $food['isGlutenFree'] ?? false,
                    'nutrition' => $food['nutrition'] ?? [],
                ]);

                // Ingredients
                if (!empty($food['ingredients'])) {
                    foreach ($food['ingredients'] as $ing) {
                        RecipeIngredient::create([
                            'recipe_id' => $recipe->id,
                            'nameKhmer' => $ing['nameKhmer'],
                            'nameEnglish' => $ing['nameEnglish'],
                            'quantity' => $ing['quantity'] ?? '',
                            'measurement' => $ing['measurement'] ?? '',
                        ]);
                    }
                }

                // Cooking Steps
                if (!empty($food['cookingSteps'])) {
                    foreach ($food['cookingSteps'] as $step) {
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

                // Reviews
                if (!empty($food['reviews'])) {
                    foreach ($food['reviews'] as $rev) {
                        Review::create([
                            'id' => $rev['id'] ?? uniqid('rev_'),
                            'recipe_id' => $recipe->id,
                            'userName' => $rev['userName'],
                            'userAvatar' => $rev['userAvatar'],
                            'rating' => $rev['rating'],
                            'comment' => $rev['comment'] ?? '',
                            'date' => $rev['date'] ?? '',
                            'photoUrl' => $rev['photoUrl'] ?? null,
                        ]);
                    }
                }
            }
        }

        // 5. Seed Collections
        $collections = [
            [
                'id' => 'col_weekend',
                'userId' => 'usr_001',
                'title' => 'Weekend Family Favorites',
                'description' => 'Hearty traditional Khmer meals perfect for Sunday family luncheons.',
                'coverImageUrl' => 'assets/recipes/Fish_amok.jpg',
                'isDefault' => true,
                'recipe_ids' => ['food_fish_amok', 'food_lok_lak', 'food_samlor_korko', 'food_takeo_prawn']
            ],
            [
                'id' => 'col_healthy',
                'userId' => 'usr_001',
                'title' => 'Healthy Heritage Soups',
                'description' => 'Nutrient-packed traditional soups rich in medicinal herbs and fresh fish.',
                'coverImageUrl' => 'assets/recipes/food_samlor_korko.jpg',
                'isDefault' => false,
                'recipe_ids' => ['food_samlor_korko', 'food_nom_banh_chok', 'food_samlor_prahalar']
            ],
            [
                'id' => 'col_festivals',
                'userId' => 'usr_001',
                'title' => 'Khmer New Year & Pchum Ben Delicacies',
                'description' => 'Sacred recipes prepared during festive celebrations across Cambodia.',
                'coverImageUrl' => 'assets/recipes/nom_banh_chok.jpg',
                'isDefault' => false,
                'recipe_ids' => ['food_fish_amok', 'food_nom_banh_chok', 'food_kralan_kratie']
            ]
        ];

        foreach ($collections as $col) {
            $createdCol = Collection::create([
                'id' => $col['id'],
                'userId' => $col['userId'],
                'title' => $col['title'],
                'description' => $col['description'],
                'coverImageUrl' => $col['coverImageUrl'],
                'isDefault' => $col['isDefault'],
            ]);
            $createdCol->recipes()->attach($col['recipe_ids']);
        }
    }
}
