import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/navigation_controller.dart';
import '../home/home_screen.dart';
import '../province/province_explorer_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../favorites/favorites_screen.dart';
import '../auth/profile_screen.dart';

class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(NavigationController());

    final pages = const [
      HomeScreen(),
      ProvinceExplorerScreen(),
      AIAssistantScreen(),
      FavoritesScreen(),
      ProfileScreen(),
    ];

    final navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'home'.tr},
      {'icon': Icons.map_outlined, 'activeIcon': Icons.map, 'label': 'provinces'.tr},
      {'icon': Icons.auto_awesome_outlined, 'activeIcon': Icons.auto_awesome, 'label': 'ai_chef'.tr},
      {'icon': Icons.bookmark_outline, 'activeIcon': Icons.bookmark, 'label': 'favorites'.tr},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'profile'.tr},
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() => IndexedStack(
            index: navCtrl.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 68,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: context.isDarkMode ? const Color(0xEE1C2026) : Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: context.isDarkMode
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.secondary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDarkMode ? 0.45 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isSelected = navCtrl.currentIndex.value == index;
                final item = navItems[index];
                return GestureDetector(
                  onTap: () => navCtrl.changePage(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 14 : 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? (context.isDarkMode ? AppColors.primaryGradient : AppColors.emeraldGradient)
                          : null,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (context.isDarkMode ? AppColors.primary : AppColors.secondary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? (item['activeIcon'] as IconData) : (item['icon'] as IconData),
                          size: 22,
                          color: isSelected
                              ? (context.isDarkMode ? Colors.black : Colors.white)
                              : (context.isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
