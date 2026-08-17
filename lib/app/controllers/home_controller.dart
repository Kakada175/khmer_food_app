import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/models/category_model.dart';
import '../data/repositories/food_repository.dart';

class HomeController extends GetxController {
  final FoodRepository foodRepository;
  HomeController(this.foodRepository);

  final RxList<FoodModel> featuredFoods = <FoodModel>[].obs;
  final RxList<FoodModel> popularFoods = <FoodModel>[].obs;
  final RxList<FoodModel> festivalFoods = <FoodModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<FoodModel> allFoods = <FoodModel>[].obs;
  final RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  void loadHomeData() {
    allFoods.value = foodRepository.getAllFoods();
    featuredFoods.value = foodRepository.getFeaturedFoods();
    popularFoods.value = foodRepository.getPopularFoods();
    festivalFoods.value = foodRepository.getFestivalFoods();
    categories.value = foodRepository.getCategories();
  }

  void selectCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = '';
    } else {
      selectedCategoryId.value = categoryId;
    }
  }

  List<FoodModel> get filteredFoods {
    if (selectedCategoryId.value.isEmpty) {
      return allFoods;
    }
    return allFoods.where((f) => f.categoryId == selectedCategoryId.value).toList();
  }
}
