import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/auth_controller.dart';
import '../home/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesController favCtrl = Get.find<FavoritesController>();
  final AuthController authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateCollectionDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardBg,
        title: Text(
          'Create Cooking Collection',
          style: TextStyle(color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: TextStyle(color: context.textPrimary),
              decoration: const InputDecoration(hintText: 'Collection Title (e.g. Weekend Dinners)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              style: TextStyle(color: context.textPrimary),
              decoration: const InputDecoration(hintText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              favCtrl.createNewCollection(titleCtrl.text, descCtrl.text);
              Get.back();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
            onPressed: () => _showCreateCollectionDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
          labelColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
          unselectedLabelColor: context.textSecondary,
          tabs: const [
            Tab(text: 'Saved Recipes'),
            Tab(text: 'Cooking Collections'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSavedRecipesTab(),
          _buildCollectionsTab(),
        ],
      ),
    );
  }

  Widget _buildSavedRecipesTab() {
    return Obx(() {
      favCtrl.loadFavorites();
      if (favCtrl.favoriteFoods.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 64, color: context.textSecondary),
              const SizedBox(height: 12),
              Text('No favorite recipes saved yet.', style: TextStyle(color: context.textSecondary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.find<AuthController>().login('user@khmerfood.app', 'pass');
                },
                child: const Text('Save Favorites Demo'),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        itemCount: favCtrl.favoriteFoods.length,
        itemBuilder: (context, index) {
          final food = favCtrl.favoriteFoods[index];
          return FoodCardHorizontal(food: food);
        },
      );
    });
  }

  Widget _buildCollectionsTab() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
        itemCount: favCtrl.collections.length,
        itemBuilder: (context, index) {
          final col = favCtrl.collections[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(col.coverImageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    col.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${col.foodIds.length} Recipes • ${col.description}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
