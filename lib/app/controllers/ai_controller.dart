import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/repositories/ai_repository.dart';
import '../data/repositories/food_repository.dart';

class AIController extends GetxController {
  late final FoodRepository foodRepository;
  late final AIRepository _aiRepository;

  final RxInt activeSubTab = 0.obs; // 0: Ingredient Finder, 1: Dish Recognition, 2: AI Chef Chat

  // AI Ingredient Finder
  final RxList<String> userIngredients = <String>[].obs;
  final RxList<FoodModel> suggestedFoods = <FoodModel>[].obs;
  final RxBool isLoadingFinder = false.obs;

  // AI Dish Recognition
  final RxBool isScanningPhoto = false.obs;
  final Rxn<FoodModel> recognizedFood = Rxn<FoodModel>();

  // AI Chatbot
  final RxList<Map<String, String>> chatMessages = <Map<String, String>>[
    {
      'sender': 'ai',
      'text': 'Choum Reap Sur! I am your Khmer AI Cooking Assistant. Ask me anything about Cambodian recipes, Kroeung pastes, or cooking techniques!'
    }
  ].obs;
  final RxString userChatInput = ''.obs;
  final RxBool isChatLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    foodRepository = Get.find<FoodRepository>();
    _aiRepository = AIRepository(foodRepository);
  }

  void addIngredient(String ing) {
    final trimmed = ing.trim();
    if (trimmed.isNotEmpty && !userIngredients.contains(trimmed)) {
      userIngredients.add(trimmed);
      findRecipesByIngredients();
    }
  }

  void removeIngredient(String ing) {
    userIngredients.remove(ing);
    findRecipesByIngredients();
  }

  Future<void> findRecipesByIngredients() async {
    isLoadingFinder.value = true;
    suggestedFoods.value = await _aiRepository.findByIngredients(userIngredients);
    isLoadingFinder.value = false;
  }

  Future<void> scanAndNavigate(FoodModel food) async {
    recognizedFood.value = food;
    isScanningPhoto.value = true;
    
    // Simulate live AI scanning analysis
    await Future.delayed(const Duration(milliseconds: 1500));
    
    isScanningPhoto.value = false;
    
    // Auto navigate directly to food details screen!
    Get.toNamed('/food-detail', arguments: food.id);
  }

  Future<void> simulateDishRecognition() async {
    isScanningPhoto.value = true;
    recognizedFood.value = await _aiRepository.recognizeDishFromPhoto('mock_photo.jpg');
    isScanningPhoto.value = false;
    if (recognizedFood.value != null) {
      Get.toNamed('/food-detail', arguments: recognizedFood.value!.id);
    }
  }

  Future<void> sendChatMessage() async {
    final query = userChatInput.value.trim();
    if (query.isEmpty) return;

    chatMessages.add({'sender': 'user', 'text': query});
    userChatInput.value = '';
    isChatLoading.value = true;

    final response = await _aiRepository.askAIChef(query, chatMessages);
    isChatLoading.value = false;
    chatMessages.add({'sender': 'ai', 'text': response});
  }
}
