import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/food_model.dart';
import '../../data/models/nutrition_model.dart';
import '../../data/utils/image_helper.dart';
import '../../data/utils/recipe_image_picker.dart';

class ManageFoodsScreen extends StatelessWidget {
  const ManageFoodsScreen({super.key});

  void _showAddFoodDialog(BuildContext context, AdminController adminCtrl) {
    final nameKhmerCtrl = TextEditingController();
    final nameEngCtrl = TextEditingController();
    final descKhmerCtrl = TextEditingController();
    final descEngCtrl = TextEditingController();
    String coverImageUrl = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Obx(
          () => Stack(
            children: [
              AlertDialog(
                backgroundColor: AppColors.cardDark,
                title: const Text('Add New Khmer Recipe', style: TextStyle(color: AppColors.primary)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Upload/Preview Box
                      Container(
                        height: 120,
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: coverImageUrl.isNotEmpty
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: buildRecipeImage(coverImageUrl, width: 300, height: 120, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.black87,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 12, color: Colors.white),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setDialogState(() {
                                            coverImageUrl = '';
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image, size: 36, color: Colors.white38),
                                  const SizedBox(height: 4),
                                  TextButton.icon(
                                    icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                                    label: const Text('Upload Photo', style: TextStyle(fontSize: 12)),
                                    onPressed: () async {
                                      final imgPath = await pickImage();
                                      if (imgPath != null) {
                                        setDialogState(() {
                                          coverImageUrl = imgPath;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                      ),
                      TextField(
                        controller: nameKhmerCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name Khmer (e.g. អាម៉ុកសាច់មាន់)',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameEngCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name English (e.g. Chicken Amok)',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descKhmerCtrl,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description Khmer',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descEngCtrl,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description English',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.translate, size: 16),
                            label: const Text('EN ➔ KM', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () async {
                              if (nameEngCtrl.text.isNotEmpty) {
                                final transName = await adminCtrl.translateText(nameEngCtrl.text, toKhmer: true);
                                if (transName.isNotEmpty) nameKhmerCtrl.text = transName;
                              }
                              if (descEngCtrl.text.isNotEmpty) {
                                final transDesc = await adminCtrl.translateText(descEngCtrl.text, toKhmer: true);
                                if (transDesc.isNotEmpty) descKhmerCtrl.text = transDesc;
                              }
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.translate, size: 16),
                            label: const Text('KM ➔ EN', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () async {
                              if (nameKhmerCtrl.text.isNotEmpty) {
                                final transName = await adminCtrl.translateText(nameKhmerCtrl.text, toKhmer: false);
                                if (transName.isNotEmpty) nameEngCtrl.text = transName;
                              }
                              if (descKhmerCtrl.text.isNotEmpty) {
                                final transDesc = await adminCtrl.translateText(descKhmerCtrl.text, toKhmer: false);
                                if (transDesc.isNotEmpty) descEngCtrl.text = transDesc;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameEngCtrl.text.isNotEmpty) {
                        final newFood = FoodModel(
                          id: 'food_${DateTime.now().millisecondsSinceEpoch}',
                          nameKhmer: nameKhmerCtrl.text.isNotEmpty ? nameKhmerCtrl.text : nameEngCtrl.text,
                          nameEnglish: nameEngCtrl.text,
                          localName: nameEngCtrl.text,
                          descriptionKhmer: descKhmerCtrl.text,
                          descriptionEnglish: descEngCtrl.text,
                          provinceId: 'prov_general',
                          provinceName: 'General',
                          categoryId: 'cat_curry',
                          categoryName: 'Curry & Amok',
                          difficulty: 'Medium',
                          prepTimeMinutes: 20,
                          cookTimeMinutes: 20,
                          servingSize: 4,
                          historyBackgroundKhmer: 'Traditional Khmer dish.',
                          historyBackgroundEnglish: 'Traditional Khmer dish history.',
                          culturalSignificance: 'Cultural icon',
                          traditionalEvents: 'Festivals',
                          originStory: 'Ancient recipe',
                          ingredients: [],
                          cookingSteps: [],
                          nutrition: NutritionModel(calories: 320, proteinGrams: 20, fatGrams: 10, carbsGrams: 15, fiberGrams: 2, sodiumMg: 400),
                          coverImageUrl: coverImageUrl.isNotEmpty 
                              ? coverImageUrl 
                              : 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
                          galleryImages: [],
                          rating: 5.0,
                          reviewCount: 1,
                          viewCount: 10,
                          favoriteCount: 5,
                          isFeatured: true,
                          reviews: [],
                        );

                        await adminCtrl.foodRepository.addFood(newFood);
                        adminCtrl.loadAdminData();
                        Get.back();
                        Get.snackbar('Recipe Created', 'New recipe "${newFood.nameEnglish}" added to database.');
                      }
                    },
                    child: const Text('Save Recipe'),
                  ),
                ],
              ),
              if (adminCtrl.isTranslating.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditFoodDialog(BuildContext context, AdminController adminCtrl, FoodModel food) {
    final nameKhmerCtrl = TextEditingController(text: food.nameKhmer);
    final nameEngCtrl = TextEditingController(text: food.nameEnglish);
    final descKhmerCtrl = TextEditingController(text: food.descriptionKhmer);
    final descEngCtrl = TextEditingController(text: food.descriptionEnglish);
    String coverImageUrl = food.coverImageUrl;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Obx(
          () => Stack(
            children: [
              AlertDialog(
                backgroundColor: AppColors.cardDark,
                title: Text('Edit Recipe: ${food.nameEnglish}', style: const TextStyle(color: AppColors.primary)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image Upload/Preview Box
                      Container(
                        height: 120,
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: coverImageUrl.isNotEmpty
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: buildRecipeImage(coverImageUrl, width: 300, height: 120, fit: BoxFit.cover),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.black87,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, size: 12, color: Colors.white),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setDialogState(() {
                                            coverImageUrl = '';
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image, size: 36, color: Colors.white38),
                                  const SizedBox(height: 4),
                                  TextButton.icon(
                                    icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                                    label: const Text('Upload Photo', style: TextStyle(fontSize: 12)),
                                    onPressed: () async {
                                      final imgPath = await pickImage();
                                      if (imgPath != null) {
                                        setDialogState(() {
                                          coverImageUrl = imgPath;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                      ),
                      TextField(
                        controller: nameKhmerCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name Khmer',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: nameEngCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Name English',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descKhmerCtrl,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description Khmer',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: descEngCtrl,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Description English',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.translate, size: 16),
                            label: const Text('EN ➔ KM', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () async {
                              if (nameEngCtrl.text.isNotEmpty) {
                                final transName = await adminCtrl.translateText(nameEngCtrl.text, toKhmer: true);
                                if (transName.isNotEmpty) nameKhmerCtrl.text = transName;
                              }
                              if (descEngCtrl.text.isNotEmpty) {
                                final transDesc = await adminCtrl.translateText(descEngCtrl.text, toKhmer: true);
                                if (transDesc.isNotEmpty) descKhmerCtrl.text = transDesc;
                              }
                            },
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.translate, size: 16),
                            label: const Text('KM ➔ EN', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onPressed: () async {
                              if (nameKhmerCtrl.text.isNotEmpty) {
                                final transName = await adminCtrl.translateText(nameKhmerCtrl.text, toKhmer: false);
                                if (transName.isNotEmpty) nameEngCtrl.text = transName;
                              }
                              if (descKhmerCtrl.text.isNotEmpty) {
                                final transDesc = await adminCtrl.translateText(descKhmerCtrl.text, toKhmer: false);
                                if (transDesc.isNotEmpty) descEngCtrl.text = transDesc;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () {
                      if (nameEngCtrl.text.isNotEmpty) {
                        final updatedFood = FoodModel(
                          id: food.id,
                          nameKhmer: nameKhmerCtrl.text.isNotEmpty ? nameKhmerCtrl.text : food.nameKhmer,
                          nameEnglish: nameEngCtrl.text,
                          localName: nameEngCtrl.text,
                          descriptionKhmer: descKhmerCtrl.text,
                          descriptionEnglish: descEngCtrl.text,
                          provinceId: food.provinceId,
                          provinceName: food.provinceName,
                          categoryId: food.categoryId,
                          categoryName: food.categoryName,
                          difficulty: food.difficulty,
                          prepTimeMinutes: food.prepTimeMinutes,
                          cookTimeMinutes: food.cookTimeMinutes,
                          servingSize: food.servingSize,
                          historyBackgroundKhmer: food.historyBackgroundKhmer,
                          historyBackgroundEnglish: food.historyBackgroundEnglish,
                          culturalSignificance: food.culturalSignificance,
                          traditionalEvents: food.traditionalEvents,
                          originStory: food.originStory,
                          ingredients: food.ingredients,
                          cookingSteps: food.cookingSteps,
                          nutrition: food.nutrition,
                          coverImageUrl: coverImageUrl,
                          galleryImages: food.galleryImages,
                          rating: food.rating,
                          reviewCount: food.reviewCount,
                          viewCount: food.viewCount,
                          favoriteCount: food.favoriteCount,
                          isFeatured: food.isFeatured,
                          reviews: food.reviews,
                        );

                        adminCtrl.foodRepository.updateFood(updatedFood);
                        adminCtrl.loadAdminData();
                        Get.back();
                        Get.snackbar('Recipe Updated', '"${updatedFood.nameEnglish}" has been updated.');
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
              if (adminCtrl.isTranslating.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Recipes (CRUD)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddFoodDialog(context, adminCtrl),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: adminCtrl.adminFoods.length,
          itemBuilder: (context, index) {
            final food = adminCtrl.adminFoods[index];
            return Card(
              color: AppColors.cardDark,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: buildRecipeImage(food.coverImageUrl),
                  ),
                ),
                title: Text(food.nameEnglish, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${food.nameKhmer} • ${food.provinceName}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () => _showEditFoodDialog(context, adminCtrl, food),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.accentRed),
                      onPressed: () => adminCtrl.deleteFood(food.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
