import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';
import 'app/translations/app_translations.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

import 'app/data/services/laravel_api_service.dart';
import 'app/data/repositories/food_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services early to fetch data from the database
  Get.put(LaravelApiService(), permanent: true);
  final foodRepo = Get.put(FoodRepository(), permanent: true);
  
  try {
    await foodRepo.initData();
  } catch (e) {
    debugPrint('Database initialization error: $e');
  }
  
  runApp(const KhmerFoodApp());
}

class KhmerFoodApp extends StatelessWidget {
  const KhmerFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Khmer Food Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to Khmer Royal Dark Mode
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
