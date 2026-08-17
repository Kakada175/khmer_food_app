import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/models/collection_model.dart';
import '../data/repositories/food_repository.dart';
import 'auth_controller.dart';

class FavoritesController extends GetxController {
  final FoodRepository foodRepository;
  FavoritesController(this.foodRepository);

  final RxList<CollectionModel> collections = <CollectionModel>[].obs;
  final RxList<FoodModel> favoriteFoods = <FoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    collections.value = foodRepository.getCollections();
    final authCtrl = Get.find<AuthController>();
    final favIds = authCtrl.currentUser.value.favoriteFoodIds;

    favoriteFoods.value = foodRepository
        .getAllFoods()
        .where((f) => favIds.contains(f.id))
        .toList();
  }

  void createNewCollection(String title, String description) {
    if (title.trim().isEmpty) return;

    final newCol = CollectionModel(
      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      coverImageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
      foodIds: [],
    );

    foodRepository.createCollection(newCol);
    collections.value = foodRepository.getCollections();
    Get.snackbar('Collection Created', 'Collection "$title" has been created.');
  }
}
