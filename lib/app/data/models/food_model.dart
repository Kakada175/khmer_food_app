import 'package:get/get.dart';
import 'ingredient_model.dart';
import 'cooking_step_model.dart';
import 'nutrition_model.dart';
import 'review_model.dart';
import '../../controllers/localization_controller.dart';
import '../../translations/culinary_text_translations.dart';

class FoodModel {
  final String id;
  final String nameKhmer;
  final String nameEnglish;
  final String localName;
  final String descriptionKhmer;
  final String descriptionEnglish;
  
  final String provinceId;
  final String provinceName;
  final String categoryId;
  final String categoryName;
  
  final String difficulty; // Easy, Medium, Hard
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servingSize;

  // History & Cultural Context
  final String historyBackgroundKhmer;
  final String historyBackgroundEnglish;
  final String _culturalSignificance;
  final String _traditionalEvents;
  final String _originStory;

  // Components
  final List<IngredientModel> ingredients;
  final List<CookingStepModel> cookingSteps;
  final NutritionModel nutrition;

  // Media
  final String coverImageUrl;
  final List<String> galleryImages;
  final String? youtubeVideoUrl;
  final String? videoThumbnailUrl;

  // Stats & Badges
  final double rating;
  final int reviewCount;
  final int viewCount;
  final int favoriteCount;

  final bool isFeatured;
  final bool isPopular;
  final bool isTraditional;
  final bool isFestival;
  final String? festivalName;

  // Dietary Flags
  final bool isVegetarian;
  final bool isSpicy;
  final bool isHalalFriendly;
  final bool isGlutenFree;

  final List<ReviewModel> reviews;

  FoodModel({
    required this.id,
    required this.nameKhmer,
    required this.nameEnglish,
    required this.localName,
    required this.descriptionKhmer,
    required this.descriptionEnglish,
    required this.provinceId,
    required this.provinceName,
    required this.categoryId,
    required this.categoryName,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servingSize,
    required this.historyBackgroundKhmer,
    required this.historyBackgroundEnglish,
    required String culturalSignificance,
    required String traditionalEvents,
    required String originStory,
    required this.ingredients,
    required this.cookingSteps,
    required this.nutrition,
    required this.coverImageUrl,
    required this.galleryImages,
    this.youtubeVideoUrl,
    this.videoThumbnailUrl,
    required this.rating,
    required this.reviewCount,
    required this.viewCount,
    required this.favoriteCount,
    this.isFeatured = false,
    this.isPopular = false,
    this.isTraditional = true,
    this.isFestival = false,
    this.festivalName,
    this.isVegetarian = false,
    this.isSpicy = false,
    this.isHalalFriendly = false,
    this.isGlutenFree = false,
    required this.reviews,
  }) : 
    _culturalSignificance = culturalSignificance,
    _traditionalEvents = traditionalEvents,
    _originStory = originStory;

  String get culturalSignificance {
    final loc = Get.find<LocalizationController>();
    final lookupVal = CulinaryTextTranslations.lookup('${id}_cultural', loc.isKhmer);
    return lookupVal ?? _culturalSignificance;
  }

  String get traditionalEvents {
    final loc = Get.find<LocalizationController>();
    final lookupVal = CulinaryTextTranslations.lookup('${id}_events', loc.isKhmer);
    return lookupVal ?? _traditionalEvents;
  }

  String get originStory {
    final loc = Get.find<LocalizationController>();
    final lookupVal = CulinaryTextTranslations.lookup('${id}_story', loc.isKhmer);
    return lookupVal ?? _originStory;
  }

  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? '',
      nameKhmer: json['nameKhmer'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      localName: json['localName'] ?? '',
      descriptionKhmer: json['descriptionKhmer'] ?? '',
      descriptionEnglish: json['descriptionEnglish'] ?? '',
      provinceId: json['provinceId'] ?? '',
      provinceName: json['provinceName'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      servingSize: json['servingSize'] ?? 2,
      historyBackgroundKhmer: json['historyBackgroundKhmer'] ?? '',
      historyBackgroundEnglish: json['historyBackgroundEnglish'] ?? '',
      culturalSignificance: json['culturalSignificance'] ?? '',
      traditionalEvents: json['traditionalEvents'] ?? '',
      originStory: json['originStory'] ?? '',
      ingredients: (json['ingredients'] as List? ?? [])
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      cookingSteps: (json['cookingSteps'] as List? ?? [])
          .map((e) => CookingStepModel.fromJson(e))
          .toList(),
      nutrition: NutritionModel.fromJson(json['nutrition'] ?? {}),
      coverImageUrl: json['coverImageUrl'] ?? '',
      galleryImages: List<String>.from(json['galleryImages'] ?? []),
      youtubeVideoUrl: json['youtubeVideoUrl'],
      videoThumbnailUrl: json['videoThumbnailUrl'],
      rating: (json['rating'] ?? 5.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      favoriteCount: json['favoriteCount'] ?? 0,
      isFeatured: json['isFeatured'] ?? false,
      isPopular: json['isPopular'] ?? false,
      isTraditional: json['isTraditional'] ?? true,
      isFestival: json['isFestival'] ?? false,
      festivalName: json['festivalName'],
      isVegetarian: json['isVegetarian'] ?? false,
      isSpicy: json['isSpicy'] ?? false,
      isHalalFriendly: json['isHalalFriendly'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKhmer': nameKhmer,
      'nameEnglish': nameEnglish,
      'localName': localName,
      'descriptionKhmer': descriptionKhmer,
      'descriptionEnglish': descriptionEnglish,
      'provinceId': provinceId,
      'provinceName': provinceName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'difficulty': difficulty,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servingSize': servingSize,
      'historyBackgroundKhmer': historyBackgroundKhmer,
      'historyBackgroundEnglish': historyBackgroundEnglish,
      'culturalSignificance': _culturalSignificance,
      'traditionalEvents': _traditionalEvents,
      'originStory': _originStory,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'cookingSteps': cookingSteps.map((e) => e.toJson()).toList(),
      'nutrition': nutrition.toJson(),
      'coverImageUrl': coverImageUrl,
      'galleryImages': galleryImages,
      'youtubeVideoUrl': youtubeVideoUrl,
      'videoThumbnailUrl': videoThumbnailUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'isTraditional': isTraditional,
      'isFestival': isFestival,
      'festivalName': festivalName,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'isHalalFriendly': isHalalFriendly,
      'isGlutenFree': isGlutenFree,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
