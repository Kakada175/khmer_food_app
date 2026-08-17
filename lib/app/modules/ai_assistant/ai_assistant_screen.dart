import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/localization_controller.dart';
import '../home/home_screen.dart';
import '../../data/utils/image_helper.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AIController aiCtrl = Get.find<AIController>();
  final _ingInputCtrl = TextEditingController();
  final _chatInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ingInputCtrl.dispose();
    _chatInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
            const SizedBox(width: 8),
            const Text('AI Culinary Assistant'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
          labelColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
          unselectedLabelColor: context.textSecondary,
          tabs: [
            Tab(text: 'Ingredient Finder'.tr),
            Tab(text: 'Dish Recognizer'.tr),
            Tab(text: 'AI Chef Chat'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIngredientFinderTab(context),
          _buildDishRecognizerTab(context),
          _buildAIChatTab(context),
        ],
      ),
    );
  }

  Widget _buildIngredientFinderTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: context.isDarkMode ? AppColors.primaryGradient : AppColors.emeraldGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'kitchen_ingredients_hint'.tr,
                    style: TextStyle(
                      color: context.isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingInputCtrl,
                  style: TextStyle(color: context.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Chicken, lemongrass, coconut milk...'.tr,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_ingInputCtrl.text.isNotEmpty) {
                    aiCtrl.addIngredient(_ingInputCtrl.text);
                    _ingInputCtrl.clear();
                  }
                },
                child: Text('add'.tr),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User Selected Ingredient Chips
          Obx(
            () => Wrap(
              spacing: 8,
              children: aiCtrl.userIngredients
                  .map((ing) => InputChip(
                        key: ValueKey(ing),
                        label: Text(ing, style: TextStyle(color: context.textPrimary)),
                        onDeleted: () => aiCtrl.removeIngredient(ing),
                        deleteIconColor: AppColors.accentRed,
                        backgroundColor: context.cardBg,
                        side: BorderSide(color: context.borderColor),
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'recommended_recipes'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (aiCtrl.isLoadingFinder.value) {
                return Center(child: CircularProgressIndicator(color: context.isDarkMode ? AppColors.primary : AppColors.secondary));
              }

              if (aiCtrl.suggestedFoods.isEmpty) {
                return Center(
                  child: Text(
                    'add_ingredients_to_find'.tr,
                    style: TextStyle(color: context.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                itemCount: aiCtrl.suggestedFoods.length,
                itemBuilder: (context, index) {
                  final food = aiCtrl.suggestedFoods[index];
                  return FoodCardHorizontal(food: food);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDishRecognizerTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (context.isDarkMode ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, size: 56, color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                const SizedBox(height: 12),
                Text(
                  'snap_upload_photo'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  'ai_identify_desc'.tr,
                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: Text('scan_dish_now'.tr),
                  onPressed: () => _showPhotoPicker(context, aiCtrl),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (aiCtrl.isScanningPhoto.value) {
              return Column(
                children: [
                  CircularProgressIndicator(color: context.isDarkMode ? AppColors.primary : AppColors.secondary),
                  const SizedBox(height: 12),
                  Text('ai_analyzing'.tr, style: TextStyle(color: context.textPrimary)),
                ],
              );
            }

            final recognized = aiCtrl.recognizedFood.value;
            if (recognized != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ai_match_result'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FoodCardHorizontal(food: recognized),
                ],
              );
            }

            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildAIChatTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: aiCtrl.chatMessages.length,
              itemBuilder: (context, index) {
                final msg = aiCtrl.chatMessages[index];
                final isUser = msg['sender'] == 'user';
                final bg = isUser
                    ? (context.isDarkMode ? AppColors.primary : AppColors.secondary)
                    : context.cardBg;
                final txtColor = isUser
                    ? (context.isDarkMode ? Colors.black : Colors.white)
                    : context.textPrimary;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: txtColor,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Obx(() => aiCtrl.isChatLoading.value
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('ai_typing'.tr, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                  ],
                ),
              )
            : const SizedBox()),
        Container(
          padding: const EdgeInsets.all(12),
          color: context.surfaceBg,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatInputCtrl,
                  style: TextStyle(color: context.textPrimary),
                  onChanged: (val) => aiCtrl.userChatInput.value = val,
                  decoration: InputDecoration(
                    hintText: 'ask_ai_chef_hint'.tr,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
                child: IconButton(
                  icon: Icon(Icons.send, color: context.isDarkMode ? Colors.black : Colors.white, size: 20),
                  onPressed: () {
                    aiCtrl.sendChatMessage();
                    _chatInputCtrl.clear();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  void _showPhotoPicker(BuildContext context, AIController aiCtrl) {
    final foods = aiCtrl.foodRepository.getAllFoods();
    final locCtrl = Get.find<LocalizationController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Food Photo to Scan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      aiCtrl.scanAndNavigate(food);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          buildRecipeImage(food.coverImageUrl, fit: BoxFit.cover),
                          Container(
                            color: Colors.black38,
                          ),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            right: 6,
                            child: Text(
                              locCtrl.isKhmer ? food.nameKhmer : food.nameEnglish,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
