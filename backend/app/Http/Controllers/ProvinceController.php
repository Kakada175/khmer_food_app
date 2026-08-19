<?php

namespace App\Http\Controllers;

use App\Models\Province;
use Illuminate\Http\JsonResponse;

class ProvinceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): JsonResponse
    {
        return response()->json(Province::all());
    }
}
