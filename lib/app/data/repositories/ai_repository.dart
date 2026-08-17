import '../models/food_model.dart';
import 'food_repository.dart';
import '../services/openai_chat_service.dart';

class AIRepository {
  final FoodRepository _foodRepository;
  final OpenAIChatService _chatService = OpenAIChatService();

  AIRepository(this._foodRepository);

  Future<List<FoodModel>> findByIngredients(List<String> userIngredients) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final allFoods = _foodRepository.getAllFoods();
    if (userIngredients.isEmpty) return allFoods;

    final normalized = userIngredients.map((e) => e.toLowerCase()).toList();
    return allFoods.where((food) {
      final foodIngs = food.ingredients
          .map((i) => '${i.nameEnglish} ${i.nameKhmer}'.toLowerCase())
          .join(' ');
      return normalized.any((userIng) => foodIngs.contains(userIng));
    }).toList();
  }

  Future<FoodModel?> recognizeDishFromPhoto(String mockPhotoPath) async {
    await Future.delayed(const Duration(seconds: 1));
    final allFoods = _foodRepository.getAllFoods();
    return allFoods.isNotEmpty ? allFoods.first : null;
  }

  Future<String> askAIChef(String query, List<Map<String, String>> history) async {
    return await _chatService.askChef(query, history);
  }
}
