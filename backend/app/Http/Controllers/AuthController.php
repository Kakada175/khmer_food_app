<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Recipe;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * Helper to format user response to match Flutter's UserModel structure.
     */
    private function formatUserResponse(User $user): array
    {
        $favoriteFoodIds = $user->favorites()->pluck('recipe_id')->toArray();

        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'avatarUrl' => $user->avatar_url ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
            'role' => 'UserRole.' . $user->role, // Format as e.g. "UserRole.registered" or "UserRole.admin"
            'favoriteFoodIds' => $favoriteFoodIds,
            'favoriteVideoIds' => [],
            'downloadedFoodIds' => [],
        ];
    }

    /**
     * Handle Login request.
     */
    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        $email = strtolower(trim($data['email']));
        
        // Find or create user to make development simple and flexible
        $user = User::where('email', $email)->first();
        
        if (!$user) {
            $role = str_contains($email, 'admin') ? 'admin' : 'registered';
            $name = str_contains($email, 'admin') ? 'Master Admin' : 'Cambodian Foodie';
            
            $user = User::create([
                'id' => str_contains($email, 'admin') ? 'usr_admin' : 'usr_' . Str::random(8),
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($data['password']),
                'role' => $role,
                'avatar_url' => str_contains($email, 'admin') 
                    ? 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80'
                    : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
            ]);

            // Give them some default favorites
            $user->favorites()->attach(['food_fish_amok']);
        }

        return response()->json($this->formatUserResponse($user));
    }

    /**
     * Handle registration.
     */
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|string',
        ]);

        $user = User::create([
            'id' => 'usr_' . time(),
            'name' => $data['name'],
            'email' => strtolower(trim($data['email'])),
            'password' => Hash::make($data['password']),
            'role' => 'registered',
            'avatar_url' => 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
        ]);

        return response()->json($this->formatUserResponse($user));
    }

    /**
     * Handle Switch Role request.
     */
    public function switchRole(Request $request): JsonResponse
    {
        $data = $request->validate([
            'userId' => 'required|string',
            'role' => 'required|string', // UserRole.admin, UserRole.registered
        ]);

        $user = User::findOrFail($data['userId']);
        
        $role = str_replace('UserRole.', '', $data['role']); // e.g. "admin", "registered"
        $user->update(['role' => $role]);

        return response()->json($this->formatUserResponse($user));
    }

    /**
     * Handle Toggling Favorite Recipe.
     */
    public function toggleFavorite(Request $request): JsonResponse
    {
        $data = $request->validate([
            'userId' => 'required|string',
            'foodId' => 'required|string',
        ]);

        $user = User::findOrFail($data['userId']);
        $recipe = Recipe::findOrFail($data['foodId']);

        if ($user->favorites()->where('recipe_id', $recipe->id)->exists()) {
            $user->favorites()->detach($recipe->id);
            // Decrement favorite count
            $recipe->decrement('favoriteCount');
        } else {
            $user->favorites()->attach($recipe->id);
            // Increment favorite count
            $recipe->increment('favoriteCount');
        }

        return response()->json($this->formatUserResponse($user));
    }
}
