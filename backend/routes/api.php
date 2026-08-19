<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProvinceController;
use App\Http\Controllers\RecipeController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CollectionController;
use App\Http\Controllers\AIController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider or automatically registered.
|
*/

// Category endpoints
Route::get('/categories', [CategoryController::class, 'index']);

// Province endpoints
Route::get('/provinces', [ProvinceController::class, 'index']);

// Recipe endpoints
Route::get('/foods', [RecipeController::class, 'index']);
Route::post('/foods', [RecipeController::class, 'store']);
Route::delete('/foods/{id}', [RecipeController::class, 'destroy']);
Route::post('/foods/{id}/reviews', [RecipeController::class, 'addReview']);

// Authentication endpoints
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/switch-role', [AuthController::class, 'switchRole']);
Route::post('/auth/toggle-favorite', [AuthController::class, 'toggleFavorite']);

// Collection endpoints
Route::get('/collections', [CollectionController::class, 'index']);
Route::post('/collections', [CollectionController::class, 'store']);

// AI endpoints
Route::post('/ai/chat', [AIController::class, 'chat']);
