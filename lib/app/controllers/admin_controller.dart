import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/models/category_model.dart';
import '../data/models/province_model.dart';
import '../data/repositories/food_repository.dart';
import '../data/services/openai_translation_service.dart';

class AdminController extends GetxController {
  final FoodRepository foodRepository;
  final OpenAITranslationService _translationService = OpenAITranslationService();
  
  late final TextEditingController apiKeyController;

  AdminController(this.foodRepository);

  final RxInt totalFoods = 0.obs;
  final RxInt totalUsers = 1420.obs;
  final RxInt dailyActiveUsers = 385.obs;

  final RxList<FoodModel> adminFoods = <FoodModel>[].obs;
  final RxList<CategoryModel> adminCategories = <CategoryModel>[].obs;
  final RxList<ProvinceModel> adminProvinces = <ProvinceModel>[].obs;

  final RxString openaiApiKey = ''.obs;
  final RxBool isTranslating = false.obs;

  @override
  void onInit() {
    super.onInit();
    apiKeyController = TextEditingController();
    loadAdminData();
    _loadApiKey();
  }

  @override
  void onClose() {
    apiKeyController.dispose();
    super.onClose();
  }

  void loadAdminData() {
    adminFoods.value = foodRepository.getAllFoods();
    adminCategories.value = foodRepository.getCategories();
    adminProvinces.value = foodRepository.getProvinces();
    totalFoods.value = adminFoods.length;
  }

  Future<void> _loadApiKey() async {
    final key = await _translationService.getApiKey();
    openaiApiKey.value = key;
    apiKeyController.text = key;
  }

  Future<void> updateApiKey(String key) async {
    await _translationService.saveApiKey(key);
    openaiApiKey.value = key.trim();
    apiKeyController.text = key.trim();
  }

  Future<String> translateText(String text, {required bool toKhmer}) async {
    isTranslating.value = true;
    try {
      final res = await _translationService.translate(text, toKhmer: toKhmer);
      isTranslating.value = false;
      return res;
    } catch (_) {
      isTranslating.value = false;
      return '';
    }
  }

  void deleteFood(String foodId) async {
    final success = await foodRepository.deleteFood(foodId);
    if (success) {
      loadAdminData();
      Get.snackbar('Deleted', 'Food recipe deleted successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete food recipe');
    }
  }
}
