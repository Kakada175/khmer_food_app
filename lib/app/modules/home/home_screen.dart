import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/localization_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../data/models/food_model.dart';
import '../../routes/app_routes.dart';
import '../../data/utils/image_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final locCtrl = Get.find<LocalizationController>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🍲', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'app_name'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                            ),
                          ),
                          Obx(() => Text(
                                locCtrl.isKhmer ? 'ស្វែងយល់ម្ហូបខ្មែរ' : 'Discover Khmer Food',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textSecondary,
                                ),
                              )),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.language, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                      onPressed: () => locCtrl.toggleLanguage(),
                    ),
                    Obx(() {
                      final themeCtrl = Get.find<ThemeController>();
                      return IconButton(
                        icon: Icon(
                          themeCtrl.isDarkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                          color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                        ),
                        onPressed: () => themeCtrl.toggleTheme(),
                      );
                    }),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: context.textPrimary,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.FESTIVALS);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Search Trigger Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.SEARCH);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: context.surfaceBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'search_hint'.tr,
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (context.isDarkMode ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.tune, size: 18, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Cultural Hero Banner Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.emeraldGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'khmer_food'.tr,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => Get.toNamed(AppRoutes.FESTIVALS),
                            icon: const Icon(Icons.stars, color: AppColors.primary, size: 16),
                            label: Text(
                              'festival_specials'.tr,
                              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'preserving_flavors'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'explore_history'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Food Categories Horizontal Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'categories'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.SEARCH),
                          child: Text(
                            'view_all'.tr,
                            style: TextStyle(
                              color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 116,
                    child: Obx(
                      () => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: homeCtrl.categories.length,
                        itemBuilder: (context, index) {
                          final cat = homeCtrl.categories[index];
                          final isSelected = homeCtrl.selectedCategoryId.value == cat.id;
                          return GestureDetector(
                            onTap: () => homeCtrl.selectCategory(cat.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 90,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (context.isDarkMode ? AppColors.primary : AppColors.secondary)
                                    : context.cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? (context.isDarkMode ? AppColors.primary : AppColors.secondary)
                                      : context.borderColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(cat.icon, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 6),
                                  Flexible(
                                    child: Obx(() => Text(
                                          locCtrl.isKhmer ? cat.nameKhmer : cat.nameEnglish,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected
                                                ? (context.isDarkMode ? Colors.black : Colors.white)
                                                : context.textPrimary,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Featured Cuisine Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'featured_foods'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Featured Foods List Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 290,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: homeCtrl.filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = homeCtrl.filteredFoods[index];
                      return FoodCardFeatured(food: food);
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Popular Recipes List Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'popular_recipes'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Popular Recipes Vertical Cards
            Obx(
              () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = homeCtrl.popularFoods[index];
                      return FoodCardHorizontal(food: food);
                    },
                    childCount: homeCtrl.popularFoods.length,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class FoodCardFeatured extends StatelessWidget {
  final FoodModel food;
  const FoodCardFeatured({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final locCtrl = Get.find<LocalizationController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.FOOD_DETAIL, arguments: food.id);
      },
      child: Container(
        width: 230,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDarkMode ? 0.3 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: buildRecipeImage(
                    food.coverImageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '📍 ${food.provinceName}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        locCtrl.isKhmer ? food.nameKhmer : food.nameEnglish,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    food.categoryName.tr,
                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            food.rating.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: context.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, color: context.textSecondary, size: 15),
                          const SizedBox(width: 4),
                          Text(
                            '${food.totalTimeMinutes}m',
                            style: TextStyle(fontSize: 12, color: context.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCardHorizontal extends StatelessWidget {
  final FoodModel food;
  const FoodCardHorizontal({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final locCtrl = Get.find<LocalizationController>();

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.FOOD_DETAIL, arguments: food.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDarkMode ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: buildRecipeImage(
                food.coverImageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        locCtrl.isKhmer ? food.nameKhmer : food.nameEnglish,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    '📍 ${food.provinceName}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.surfaceBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          food.difficulty.tr,
                          style: TextStyle(fontSize: 10, color: context.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: AppColors.primary, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${food.rating}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.textSecondary),
          ],
        ),
      ),
    );
  }
}
