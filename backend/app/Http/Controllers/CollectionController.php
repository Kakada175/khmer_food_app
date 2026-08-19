<?php

namespace App\Http\Controllers;

use App\Models\Collection;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class CollectionController extends Controller
{
    /**
     * Get collections for a specific user.
     */
    public function index(Request $request): JsonResponse
    {
        $userId = $request->query('userId', 'usr_001');

        $collections = Collection::with('recipes')
            ->where('userId', $userId)
            ->get();

        $formatted = $collections->map(function ($c) {
            return [
                'id' => $c->id,
                'title' => $c->title,
                'description' => $c->description,
                'coverImageUrl' => $c->coverImageUrl,
                'foodIds' => $c->recipes->pluck('id')->toArray(),
                'isDefault' => $c->isDefault,
            ];
        });

        return response()->json($formatted);
    }

    /**
     * Store a new collection.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id' => 'required|string',
            'userId' => 'required|string',
            'title' => 'required|string',
            'description' => 'required|string',
            'coverImageUrl' => 'required|string',
            'isDefault' => 'boolean',
        ]);

        $collection = Collection::create([
            'id' => $data['id'],
            'userId' => $data['userId'],
            'title' => $data['title'],
            'description' => $data['description'],
            'coverImageUrl' => $data['coverImageUrl'],
            'isDefault' => $data['isDefault'] ?? false,
        ]);

        return response()->json([
            'id' => $collection->id,
            'title' => $collection->title,
            'description' => $collection->description,
            'coverImageUrl' => $collection->coverImageUrl,
            'foodIds' => [],
            'isDefault' => $collection->isDefault,
        ], 201);
    }
}
