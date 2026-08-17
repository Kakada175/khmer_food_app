import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/admin_controller.dart';
import '../../routes/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.accentRed.withOpacity(0.15),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accentRed),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: AppColors.accentRed, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Administrator Control Center', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('Full system CRUD authority for foods, provinces, and users.', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildOpenAISettingsCard(context, adminCtrl),

            const SizedBox(height: 24),
            const Text('System Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 12),

            // Stat Cards Grid
            Obx(
              () => Row(
                children: [
                  Expanded(child: _buildStatCard('Total Foods', '${adminCtrl.totalFoods.value}', Icons.restaurant_menu)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Total Users', '${adminCtrl.totalUsers.value}', Icons.people)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  Expanded(child: _buildStatCard('Daily Active', '${adminCtrl.dailyActiveUsers.value}', Icons.trending_up)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Active Reports', '0', Icons.report_problem)),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text('Management Modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.fastfood, color: AppColors.primary),
              title: const Text('Manage Foods & Recipes (CRUD)'),
              subtitle: const Text('Add, edit, delete, or feature recipes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.MANAGE_FOODS),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.category, color: AppColors.primary),
              title: const Text('Manage Food Categories'),
              subtitle: const Text('Curry, Soup, Noodles, Rice, Desserts'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.snackbar('Admin Action', 'Manage categories opened.'),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.map, color: AppColors.primary),
              title: const Text('Manage Provinces & Delicacies'),
              subtitle: const Text('25 Cambodian Provinces & local specialties'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.snackbar('Admin Action', 'Manage provinces opened.'),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.people_alt, color: AppColors.primary),
              title: const Text('Manage Users & Permissions'),
              subtitle: const Text('Moderate comments & user roles'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.snackbar('Admin Action', 'Manage users opened.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenAISettingsCard(BuildContext context, AdminController adminCtrl) {
    return Card(
      color: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.vpn_key, color: AppColors.primary, size: 22),
                SizedBox(width: 8),
                Text(
                  'OpenAI Translation Engine',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your OpenAI API key to enable real-time bidirectional translation (English ⇄ Khmer) for recipe creation and editing.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: adminCtrl.apiKeyController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'sk-proj-...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await adminCtrl.updateApiKey(adminCtrl.apiKeyController.text);
                    Get.snackbar(
                      'Settings Saved',
                      adminCtrl.apiKeyController.text.trim().isEmpty
                          ? 'OpenAI Key removed. Falling back to local translation.'
                          : 'OpenAI Translation Engine API key updated successfully.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 10),
          Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}
