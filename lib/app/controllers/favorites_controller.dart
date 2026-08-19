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

  void loadFavorites() async {
    final authCtrl = Get.find<AuthController>();
    final userId = authCtrl.currentUser.value.id;

    // Refresh user-specific collections from the database
    await foodRepository.refreshCollections(userId);
    collections.value = foodRepository.getCollections();
    
    final favIds = authCtrl.currentUser.value.favoriteFoodIds;

    favoriteFoods.value = foodRepository
        .getAllFoods()
        .where((f) => favIds.contains(f.id))
        .toList();
  }

  void createNewCollection(String title, String description) async {
    if (title.trim().isEmpty) return;

    final authCtrl = Get.find<AuthController>();
    final userId = authCtrl.currentUser.value.id;

    final newCol = CollectionModel(
      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      coverImageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80',
      foodIds: [],
    );

    final success = await foodRepository.createCollection(newCol, userId);
    if (success) {
      collections.value = foodRepository.getCollections();
      Get.snackbar('Collection Created', 'Collection "$title" has been created.');
    } else {
      Get.snackbar('Error', 'Failed to create collection in database.');
    }
  }
}
