import 'package:get/get.dart';
import '../models/food_model.dart';
import '../models/category_model.dart';
import '../models/province_model.dart';
import '../models/collection_model.dart';
import '../models/review_model.dart';
import '../services/laravel_api_service.dart';

class FoodRepository {
  final LaravelApiService _api = Get.find<LaravelApiService>();

  final List<FoodModel> _foods = [];
  final List<CategoryModel> _categories = [];
  final List<ProvinceModel> _provinces = [];
  final List<CollectionModel> _collections = [];

  // Initialize cached data from Laravel DB
  Future<void> initData() async {
    await refreshAll();
  }

  Future<void> refreshAll() async {
    final results = await Future.wait([
      _api.getCategories(),
      _api.getProvinces(),
      _api.getFoods(),
    ]);
    
    _categories.clear();
    _categories.addAll(results[0] as List<CategoryModel>);

    _provinces.clear();
    _provinces.addAll(results[1] as List<ProvinceModel>);

    _foods.clear();
    _foods.addAll(results[2] as List<FoodModel>);
  }

  Future<void> refreshFoods() async {
    final foods = await _api.getFoods();
    _foods.clear();
    _foods.addAll(foods);
  }

  Future<void> refreshCollections(String userId) async {
    final cols = await _api.getCollections(userId);
    _collections.clear();
    _collections.addAll(cols);
  }

  List<FoodModel> getAllFoods() => _foods;
  List<CategoryModel> getCategories() => _categories;
  List<ProvinceModel> getProvinces() => _provinces;
  List<CollectionModel> getCollections() => _collections;

  List<FoodModel> getFeaturedFoods() {
    return _foods.where((f) => f.isFeatured).toList();
  }

  List<FoodModel> getPopularFoods() {
    return _foods.where((f) => f.isPopular).toList();
  }

  List<FoodModel> getFestivalFoods() {
    return _foods.where((f) => f.isFestival).toList();
  }

  FoodModel? getFoodById(String id) {
    try {
      return _foods.firstWhere((f) => f.id == id);
    } catch (_) {
      return _foods.isNotEmpty ? _foods.first : null;
    }
  }

  ProvinceModel? getProvinceById(String id) {
    try {
      return _provinces.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FoodModel> searchFoods({
    String query = '',
    String? categoryId,
    String? provinceId,
    String? difficulty,
    bool? isSpicy,
    bool? isVegetarian,
    bool? isHalalFriendly,
    bool? isGlutenFree,
  }) {
    return _foods.where((f) {
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchName = f.nameEnglish.toLowerCase().contains(q) ||
            f.nameKhmer.contains(q) ||
            f.localName.toLowerCase().contains(q);
        final matchProvince = f.provinceName.toLowerCase().contains(q);
        final matchIngredient = f.ingredients.any(
            (i) => i.nameEnglish.toLowerCase().contains(q) || i.nameKhmer.contains(q));
        if (!matchName && !matchProvince && !matchIngredient) return false;
      }
      if (categoryId != null && categoryId.isNotEmpty && f.categoryId != categoryId) {
        return false;
      }
      if (provinceId != null && provinceId.isNotEmpty && f.provinceId != provinceId) {
        return false;
      }
      if (difficulty != null && difficulty.isNotEmpty && f.difficulty.toLowerCase() != difficulty.toLowerCase()) {
        return false;
      }
      if (isSpicy == true && !f.isSpicy) return false;
      if (isVegetarian == true && !f.isVegetarian) return false;
      if (isHalalFriendly == true && !f.isHalalFriendly) return false;
      if (isGlutenFree == true && !f.isGlutenFree) return false;

      return true;
    }).toList();
  }

  Future<bool> addFood(FoodModel food) async {
    final added = await _api.addFood(food);
    if (added != null) {
      await refreshFoods();
      return true;
    }
    return false;
  }

  void updateFood(FoodModel food) {
    // Local updates are handled on DB refresh, but to keep memory in sync immediately:
    final idx = _foods.indexWhere((f) => f.id == food.id);
    if (idx != -1) {
      _foods[idx] = food;
    }
  }

  Future<bool> deleteFood(String id) async {
    final deleted = await _api.deleteFood(id);
    if (deleted) {
      await refreshFoods();
      return true;
    }
    return false;
  }

  Future<bool> addReview(String foodId, ReviewModel review) async {
    final added = await _api.addReview(foodId, review);
    if (added != null) {
      await refreshFoods();
      return true;
    }
    return false;
  }

  Future<bool> createCollection(CollectionModel collection, String userId) async {
    final added = await _api.createCollection(collection, userId);
    if (added != null) {
      await refreshCollections(userId);
      return true;
    }
    return false;
  }
}
