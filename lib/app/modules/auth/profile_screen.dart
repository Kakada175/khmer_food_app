import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/localization_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final locCtrl = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
            onPressed: () {
              locCtrl.toggleLanguage();
            },
          ),
        ],
      ),
      body: Obx(() {
        final user = authCtrl.currentUser.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          child: Column(
            children: [
              // User Avatar Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: context.isDarkMode ? 0.3 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: user.isAdmin
                            ? AppColors.accentRed.withValues(alpha: 0.2)
                            : (context.isDarkMode ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: user.isAdmin
                              ? AppColors.accentRed
                              : (context.isDarkMode ? AppColors.primary : AppColors.secondary),
                        ),
                      ),
                      child: Text(
                        'Role: ${user.role.toString().split('.').last.toUpperCase()}',
                        style: TextStyle(
                          color: user.isAdmin
                              ? AppColors.accentRed
                              : (context.isDarkMode ? AppColors.primary : AppColors.secondary),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Role Switcher Tile (for quick demo testing)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Role Switcher',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChoiceChip(
                          label: const Text('Guest'),
                          selected: user.isGuest,
                          onSelected: (_) => authCtrl.switchRole(UserRole.guest),
                          selectedColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                        ),
                        ChoiceChip(
                          label: const Text('User'),
                          selected: user.role == UserRole.registered,
                          onSelected: (_) => authCtrl.switchRole(UserRole.registered),
                          selectedColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                        ),
                        ChoiceChip(
                          label: const Text('Admin'),
                          selected: user.isAdmin,
                          onSelected: (_) => authCtrl.switchRole(UserRole.admin),
                          selectedColor: AppColors.accentRed,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Options
              if (user.isAdmin) ...[
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings, color: AppColors.accentRed),
                  title: Text('Admin Control Panel', style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary)),
                  subtitle: Text('Manage recipes, categories, provinces, and users', style: TextStyle(color: context.textSecondary)),
                  trailing: Icon(Icons.chevron_right, color: context.textSecondary),
                  onTap: () {
                    Get.toNamed(AppRoutes.ADMIN);
                  },
                ),
                const Divider(),
              ],

              ListTile(
                leading: Icon(Icons.language, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                title: Text('language'.tr, style: TextStyle(color: context.textPrimary)),
                subtitle: Text(locCtrl.isKhmer ? 'khmer'.tr : 'english'.tr, style: TextStyle(color: context.textSecondary)),
                trailing: Icon(Icons.swap_horiz, color: context.textSecondary),
                onTap: () {
                  locCtrl.toggleLanguage();
                },
              ),
              const Divider(),

              Obx(() {
                final themeCtrl = Get.find<ThemeController>();
                return ListTile(
                  leading: Icon(
                    themeCtrl.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                    color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                  ),
                  title: Text('App Theme', style: TextStyle(color: context.textPrimary)),
                  subtitle: Text(
                    themeCtrl.isDarkMode.value ? 'Dark Royal Mode' : 'Light Cream Mode',
                    style: TextStyle(color: context.textSecondary),
                  ),
                  trailing: Switch(
                    value: themeCtrl.isDarkMode.value,
                    onChanged: (val) => themeCtrl.toggleTheme(),
                    activeTrackColor: AppColors.primary,
                  ),
                );
              }),
              const Divider(),

              ListTile(
                leading: Icon(Icons.download_for_offline, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                title: Text('Offline Recipe Cache', style: TextStyle(color: context.textPrimary)),
                subtitle: Text('${user.downloadedFoodIds.length} recipes downloaded', style: TextStyle(color: context.textSecondary)),
                trailing: Icon(Icons.chevron_right, color: context.textSecondary),
                onTap: () {
                  Get.snackbar('Offline Recipes', '${user.downloadedFoodIds.length} recipes available offline.');
                },
              ),
              const Divider(),

              ListTile(
                leading: Icon(Icons.notifications_active, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                title: Text('Recipe & Festival Notifications', style: TextStyle(color: context.textPrimary)),
                subtitle: Text('Khmer New Year & Water Festival specials', style: TextStyle(color: context.textSecondary)),
                trailing: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeTrackColor: AppColors.primary,
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),

              if (user.isGuest)
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.LOGIN);
                  },
                  child: Text('login'.tr),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    authCtrl.loginAsGuest();
                  },
                  child: const Text('Log Out'),
                ),
            ],
          ),
        );
      }),
    );
  }
}
