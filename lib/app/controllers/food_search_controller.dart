import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/models/category_model.dart';
import '../data/models/province_model.dart';
import '../data/repositories/food_repository.dart';

class FoodSearchController extends GetxController {
  final FoodRepository foodRepository;
  FoodSearchController(this.foodRepository);

  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedProvinceId = ''.obs;
  final RxString selectedDifficulty = ''.obs;

  final RxBool isSpicy = false.obs;
  final RxBool isVegetarian = false.obs;
  final RxBool isHalalFriendly = false.obs;
  final RxBool isGlutenFree = false.obs;

  final RxList<FoodModel> searchResults = <FoodModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProvinceModel> provinces = <ProvinceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.value = foodRepository.getCategories();
    provinces.value = foodRepository.getProvinces();
    performSearch();
  }

  void performSearch() {
    searchResults.value = foodRepository.searchFoods(
      query: searchQuery.value,
      categoryId: selectedCategoryId.value,
      provinceId: selectedProvinceId.value,
      difficulty: selectedDifficulty.value,
      isSpicy: isSpicy.value ? true : null,
      isVegetarian: isVegetarian.value ? true : null,
      isHalalFriendly: isHalalFriendly.value ? true : null,
      isGlutenFree: isGlutenFree.value ? true : null,
    );
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCategoryId.value = '';
    selectedProvinceId.value = '';
    selectedDifficulty.value = '';
    isSpicy.value = false;
    isVegetarian.value = false;
    isHalalFriendly.value = false;
    isGlutenFree.value = false;
    performSearch();
  }
}
