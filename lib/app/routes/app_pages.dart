import 'package:get/get.dart';
import '../data/repositories/food_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/localization_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/food_search_controller.dart';
import '../controllers/food_detail_controller.dart';
import '../controllers/province_controller.dart';
import '../controllers/ai_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/admin_controller.dart';

import '../modules/splash/splash_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/auth/profile_screen.dart';
import '../modules/shell/main_shell_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/search/search_screen.dart';
import '../modules/food_detail/food_detail_screen.dart';
import '../modules/province/province_explorer_screen.dart';
import '../modules/ai_assistant/ai_assistant_screen.dart';
import '../modules/favorites/favorites_screen.dart';
import '../modules/festivals/festivals_screen.dart';
import '../modules/admin/admin_dashboard_screen.dart';
import '../modules/admin/manage_foods_screen.dart';

import 'app_routes.dart';

import '../controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final foodRepo = Get.put(FoodRepository(), permanent: true);
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(LocalizationController(), permanent: true);
    Get.put(HomeController(foodRepo), permanent: true);
    Get.put(FoodSearchController(foodRepo), permanent: true);
    Get.put(FoodDetailController(foodRepo), permanent: true);
    Get.put(ProvinceController(foodRepo), permanent: true);
    Get.put(AIController(), permanent: true);
    Get.put(FavoritesController(foodRepo), permanent: true);
    Get.put(AdminController(foodRepo), permanent: true);
  }
}

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.SHELL,
      page: () => const MainShellScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.FOOD_DETAIL,
      page: () => const FoodDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.PROVINCE,
      page: () => const ProvinceExplorerScreen(),
    ),
    GetPage(
      name: AppRoutes.AI_ASSISTANT,
      page: () => const AIAssistantScreen(),
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const FavoritesScreen(),
    ),
    GetPage(
      name: AppRoutes.FESTIVALS,
      page: () => const FestivalsScreen(),
    ),
    GetPage(
      name: AppRoutes.ADMIN,
      page: () => const AdminDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.MANAGE_FOODS,
      page: () => const ManageFoodsScreen(),
    ),
  ];
}
