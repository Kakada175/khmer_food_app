import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/food_search_controller.dart';
import '../home/home_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = Get.find<FoodSearchController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
            onPressed: () => searchCtrl.resetFilters(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Header & Filters Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: context.surfaceBg,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) {
                    searchCtrl.searchQuery.value = val;
                    searchCtrl.performSearch();
                  },
                  style: TextStyle(color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'search_hint'.tr,
                    prefixIcon: Icon(Icons.search, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                    suffixIcon: Obx(() => searchCtrl.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              searchCtrl.searchQuery.value = '';
                              searchCtrl.performSearch();
                            },
                          )
                        : const SizedBox()),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Pills Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Obx(() => _buildFilterPill(
                            context: context,
                            label: '🌶️ Spicy',
                            isSelected: searchCtrl.isSpicy.value,
                            activeColor: AppColors.accentRed,
                            onTap: () {
                              searchCtrl.isSpicy.value = !searchCtrl.isSpicy.value;
                              searchCtrl.performSearch();
                            },
                          )),
                      const SizedBox(width: 8),
                      Obx(() => _buildFilterPill(
                            context: context,
                            label: '🥗 Vegetarian',
                            isSelected: searchCtrl.isVegetarian.value,
                            activeColor: AppColors.secondary,
                            onTap: () {
                              searchCtrl.isVegetarian.value = !searchCtrl.isVegetarian.value;
                              searchCtrl.performSearch();
                            },
                          )),
                      const SizedBox(width: 8),
                      Obx(() => _buildFilterPill(
                            context: context,
                            label: '☪️ Halal Friendly',
                            isSelected: searchCtrl.isHalalFriendly.value,
                            activeColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                            onTap: () {
                              searchCtrl.isHalalFriendly.value = !searchCtrl.isHalalFriendly.value;
                              searchCtrl.performSearch();
                            },
                          )),
                      const SizedBox(width: 8),
                      Obx(() => _buildFilterPill(
                            context: context,
                            label: '🌾 Gluten-Free',
                            isSelected: searchCtrl.isGlutenFree.value,
                            activeColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                            onTap: () {
                              searchCtrl.isGlutenFree.value = !searchCtrl.isGlutenFree.value;
                              searchCtrl.performSearch();
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Results Counter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      'Found ${searchCtrl.searchResults.length} recipes',
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    )),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: Obx(() {
              if (searchCtrl.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'No dishes found matching search filters',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: searchCtrl.searchResults.length,
                itemBuilder: (context, index) {
                  final food = searchCtrl.searchResults[index];
                  return FoodCardHorizontal(food: food);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : context.borderColor,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : context.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
