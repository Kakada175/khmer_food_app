import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:khmer_food_app/app/controllers/home_controller.dart';
import 'package:khmer_food_app/app/controllers/food_search_controller.dart';
import 'package:khmer_food_app/app/controllers/province_controller.dart';
import 'package:khmer_food_app/app/controllers/auth_controller.dart';
import 'package:khmer_food_app/app/data/repositories/food_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Khmer Food Explorer App Tests', () {
    late FoodRepository foodRepository;

    setUp(() {
      Get.reset();
      foodRepository = FoodRepository();
      Get.put(foodRepository);
      Get.put(AuthController());
      Get.put(HomeController(foodRepository));
      Get.put(FoodSearchController(foodRepository));
      Get.put(ProvinceController(foodRepository));
    });

    test('Initial Food Repository contains authentic Khmer dishes', () {
      final foods = foodRepository.getAllFoods();
      expect(foods.isNotEmpty, true);
      expect(foods.any((f) => f.nameEnglish == 'Fish Amok'), true);
      expect(foods.any((f) => f.nameEnglish == 'Beef Lok Lak'), true);
      expect(foods.any((f) => f.nameEnglish == 'Samlor Korko'), true);
    });

    test('Province Repository contains 25 Cambodian Provinces', () {
      final provinces = foodRepository.getProvinces();
      expect(provinces.isNotEmpty, true);
      expect(provinces.any((p) => p.nameEnglish == 'Phnom Penh'), true);
      expect(provinces.any((p) => p.nameEnglish == 'Siem Reap'), true);
      expect(provinces.any((p) => p.nameEnglish == 'Kampot'), true);
    });

    test('Food Search Controller filters recipes correctly', () {
      final searchCtrl = Get.find<FoodSearchController>();
      searchCtrl.searchQuery.value = 'Amok';
      searchCtrl.performSearch();
      expect(searchCtrl.searchResults.isNotEmpty, true);
      expect(searchCtrl.searchResults.first.nameEnglish, 'Fish Amok');
    });

    test('Auth Controller toggles Guest and Registered user role', () {
      final authCtrl = Get.find<AuthController>();
      expect(authCtrl.isGuest, false);

      authCtrl.loginAsGuest();
      expect(authCtrl.isGuest, true);
    });
  });
}
