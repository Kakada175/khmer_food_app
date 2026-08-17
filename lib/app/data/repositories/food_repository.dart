import '../models/food_model.dart';
import '../models/category_model.dart';
import '../models/province_model.dart';
import '../models/collection_model.dart';
import '../models/review_model.dart';
import '../providers/mock_data_provider.dart';

class FoodRepository {
  final List<FoodModel> _foods = List.from(MockDataProvider.foods);
  final List<CategoryModel> _categories = List.from(MockDataProvider.categories);
  final List<ProvinceModel> _provinces = List.from(MockDataProvider.provinces);
  final List<CollectionModel> _collections = List.from(MockDataProvider.initialCollections);

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

  void addFood(FoodModel food) {
    _foods.insert(0, food);
  }

  void updateFood(FoodModel food) {
    final idx = _foods.indexWhere((f) => f.id == food.id);
    if (idx != -1) {
      _foods[idx] = food;
    }
  }

  void deleteFood(String id) {
    _foods.removeWhere((f) => f.id == id);
  }

  void addReview(String foodId, ReviewModel review) {
    final food = getFoodById(foodId);
    if (food != null) {
      food.reviews.insert(0, review);
      final newReviewCount = food.reviewCount + 1;
      final newRating = ((food.rating * food.reviewCount) + review.rating) / newReviewCount;
      final updated = FoodModel(
        id: food.id,
        nameKhmer: food.nameKhmer,
        nameEnglish: food.nameEnglish,
        localName: food.localName,
        descriptionKhmer: food.descriptionKhmer,
        descriptionEnglish: food.descriptionEnglish,
        provinceId: food.provinceId,
        provinceName: food.provinceName,
        categoryId: food.categoryId,
        categoryName: food.categoryName,
        difficulty: food.difficulty,
        prepTimeMinutes: food.prepTimeMinutes,
        cookTimeMinutes: food.cookTimeMinutes,
        servingSize: food.servingSize,
        historyBackgroundKhmer: food.historyBackgroundKhmer,
        historyBackgroundEnglish: food.historyBackgroundEnglish,
        culturalSignificance: food.culturalSignificance,
        traditionalEvents: food.traditionalEvents,
        originStory: food.originStory,
        ingredients: food.ingredients,
        cookingSteps: food.cookingSteps,
        nutrition: food.nutrition,
        coverImageUrl: food.coverImageUrl,
        galleryImages: food.galleryImages,
        youtubeVideoUrl: food.youtubeVideoUrl,
        videoThumbnailUrl: food.videoThumbnailUrl,
        rating: double.parse(newRating.toStringAsFixed(1)),
        reviewCount: newReviewCount,
        viewCount: food.viewCount,
        favoriteCount: food.favoriteCount,
        isFeatured: food.isFeatured,
        isPopular: food.isPopular,
        isTraditional: food.isTraditional,
        isFestival: food.isFestival,
        festivalName: food.festivalName,
        isVegetarian: food.isVegetarian,
        isSpicy: food.isSpicy,
        isHalalFriendly: food.isHalalFriendly,
        isGlutenFree: food.isGlutenFree,
        reviews: food.reviews,
      );
      updateFood(updated);
    }
  }

  void createCollection(CollectionModel collection) {
    _collections.add(collection);
  }
}
