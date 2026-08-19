<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('categories', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('nameKhmer');
            $table->string('nameEnglish');
            $table->string('icon');
            $table->string('imageUrl');
            $table->integer('foodCount')->default(0);
            $table->timestamps();
        });

        Schema::create('provinces', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('nameKhmer');
            $table->string('nameEnglish');
            $table->string('region');
            $table->text('descriptionKhmer');
            $table->text('descriptionEnglish');
            $table->string('imageUrl');
            $table->json('famousFoodIds')->nullable();
            $table->json('famousDesserts')->nullable();
            $table->json('localIngredients')->nullable();
            $table->json('foodFestivals')->nullable();
            $table->timestamps();
        });

        Schema::create('recipes', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('nameKhmer');
            $table->string('nameEnglish');
            $table->string('localName');
            $table->text('descriptionKhmer');
            $table->text('descriptionEnglish');
            $table->string('provinceId');
            $table->string('provinceName');
            $table->string('categoryId');
            $table->string('categoryName');
            $table->string('difficulty');
            $table->integer('prepTimeMinutes');
            $table->integer('cookTimeMinutes');
            $table->integer('servingSize');
            $table->text('historyBackgroundKhmer');
            $table->text('historyBackgroundEnglish');
            $table->text('culturalSignificance');
            $table->text('traditionalEvents');
            $table->text('originStory');
            $table->string('coverImageUrl');
            $table->json('galleryImages');
            $table->string('youtubeVideoUrl')->nullable();
            $table->string('videoThumbnailUrl')->nullable();
            $table->double('rating')->default(5.0);
            $table->integer('reviewCount')->default(0);
            $table->integer('viewCount')->default(0);
            $table->integer('favoriteCount')->default(0);
            $table->boolean('isFeatured')->default(false);
            $table->boolean('isPopular')->default(false);
            $table->boolean('isTraditional')->default(true);
            $table->boolean('isFestival')->default(false);
            $table->string('festivalName')->nullable();
            $table->boolean('isVegetarian')->default(false);
            $table->boolean('isSpicy')->default(false);
            $table->boolean('isHalalFriendly')->default(false);
            $table->boolean('isGlutenFree')->default(false);
            $table->json('nutrition');
            $table->timestamps();
        });

        Schema::create('recipe_ingredients', function (Blueprint $table) {
            $table->id();
            $table->string('recipe_id');
            $table->string('nameKhmer');
            $table->string('nameEnglish');
            $table->string('quantity');
            $table->string('measurement');
            $table->timestamps();

            $table->foreign('recipe_id')->references('id')->on('recipes')->onDelete('cascade');
        });

        Schema::create('recipe_steps', function (Blueprint $table) {
            $table->id();
            $table->string('recipe_id');
            $table->integer('stepNumber');
            $table->string('title')->nullable();
            $table->text('descriptionKhmer');
            $table->text('descriptionEnglish');
            $table->string('photoUrl')->nullable();
            $table->timestamps();

            $table->foreign('recipe_id')->references('id')->on('recipes')->onDelete('cascade');
        });

        Schema::create('reviews', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('recipe_id');
            $table->string('userName');
            $table->string('userAvatar');
            $table->double('rating');
            $table->text('comment');
            $table->string('date');
            $table->string('photoUrl')->nullable();
            $table->timestamps();

            $table->foreign('recipe_id')->references('id')->on('recipes')->onDelete('cascade');
        });

        Schema::create('collections', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('userId');
            $table->string('title');
            $table->text('description');
            $table->string('coverImageUrl');
            $table->boolean('isDefault')->default(false);
            $table->timestamps();
        });

        Schema::create('collection_recipe', function (Blueprint $table) {
            $table->id();
            $table->string('collection_id');
            $table->string('recipe_id');
            $table->timestamps();

            $table->foreign('collection_id')->references('id')->on('collections')->onDelete('cascade');
            $table->foreign('recipe_id')->references('id')->on('recipes')->onDelete('cascade');
        });

        Schema::create('user_favorites', function (Blueprint $table) {
            $table->id();
            $table->string('user_id');
            $table->string('recipe_id');
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('recipe_id')->references('id')->on('recipes')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_favorites');
        Schema::dropIfExists('collection_recipe');
        Schema::dropIfExists('collections');
        Schema::dropIfExists('reviews');
        Schema::dropIfExists('recipe_steps');
        Schema::dropIfExists('recipe_ingredients');
        Schema::dropIfExists('recipes');
        Schema::dropIfExists('provinces');
        Schema::dropIfExists('categories');
    }
};
