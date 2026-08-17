import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/food_detail_controller.dart';
import '../../controllers/localization_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../data/models/food_model.dart';
import '../../routes/app_routes.dart';
import '../../data/utils/image_helper.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FoodDetailController detailCtrl = Get.find<FoodDetailController>();
  final LocalizationController locCtrl = Get.find<LocalizationController>();
  final AuthController authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    final String foodId = Get.arguments ?? 'food_fish_amok';
    detailCtrl.loadFood(foodId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBrandColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;

    return Scaffold(
      body: Obx(() {
        final food = detailCtrl.food.value;
        if (food == null) {
          return Center(child: CircularProgressIndicator(color: activeBrandColor));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Hero App Bar with Cover Photo & Floating Action Buttons
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: context.isDarkMode ? AppColors.bgDark : AppColors.bgLight,
              leading: Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Get.back();
                    } else {
                      Get.offAllNamed(AppRoutes.SHELL);
                    }
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => detailCtrl.toggleDownload(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      detailCtrl.isDownloaded.value ? Icons.download_done : Icons.download,
                      color: detailCtrl.isDownloaded.value ? AppColors.primary : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() {
                  final isFav = authCtrl.isFavorite(food.id);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => authCtrl.toggleFavorite(food.id),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppColors.accentRed : Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    buildRecipeImage(
                      food.coverImageUrl,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '📍 ${food.provinceName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            locCtrl.isKhmer ? food.nameKhmer : food.nameEnglish,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            food.localName,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Key Info Bar (Time, Servings, Rating)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetaItem(context, Icons.timer, 'prep_cook'.tr, '${food.totalTimeMinutes} ${'minutes'.tr}'),
                    _buildMetaItem(context, Icons.restaurant, 'servings'.tr, '${food.servingSize} ${'people'.tr}'),
                    _buildMetaItem(context, Icons.bar_chart, 'difficulty'.tr, food.difficulty.tr),
                    _buildMetaItem(context, Icons.star, 'rating'.tr, '${food.rating} (${food.reviewCount})'),
                  ],
                ),
              ),
            ),

            // Sticky Tab Bar Header
            SliverToBoxAdapter(
              child: Container(
                color: context.isDarkMode ? AppColors.bgDark : AppColors.bgLight,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: activeBrandColor,
                  labelColor: activeBrandColor,
                  unselectedLabelColor: context.textSecondary,
                  tabs: [
                    Tab(text: 'Overview'.tr),
                    Tab(text: 'history_culture'.tr),
                    Tab(text: 'ingredients'.tr),
                    Tab(text: 'cooking_steps'.tr),
                    Tab(text: 'nutrition'.tr),
                    Tab(text: 'reviews_comments'.tr),
                  ],
                ),
              ),
            ),

            // Tab Content Box
            SliverToBoxAdapter(
              child: SizedBox(
                height: 560,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(context, food),
                    _buildHistoryTab(context, food),
                    _buildIngredientsTab(context, food),
                    _buildStepsTab(context, food),
                    _buildNutritionTab(context, food),
                    _buildReviewsTab(context, food),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMetaItem(BuildContext context, IconData icon, String label, String value) {
    final activeColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;
    return Column(
      children: [
        Icon(icon, color: activeColor, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.textPrimary)),
        Text(label, style: TextStyle(color: context.textSecondary, fontSize: 10)),
      ],
    );
  }

  Widget _buildOverviewTab(BuildContext context, FoodModel food) {
    final activeBrandColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Dish',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeBrandColor),
          ),
          const SizedBox(height: 8),
          Text(
            locCtrl.isKhmer ? food.descriptionKhmer : food.descriptionEnglish,
            style: TextStyle(fontSize: 15, height: 1.5, color: context.textPrimary),
          ),
          const SizedBox(height: 20),
          Text(
            'Dietary Attributes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (food.isGlutenFree) _buildChip(context, '🌾 Gluten Free'),
              if (food.isHalalFriendly) _buildChip(context, '☪️ Halal Friendly'),
              if (food.isSpicy) _buildChip(context, '🌶️ Spicy'),
              if (food.isVegetarian) _buildChip(context, '🥗 Vegetarian'),
              _buildChip(context, '🇰🇭 Traditional Khmer'),
            ],
          ),
          const SizedBox(height: 20),
          if (food.youtubeVideoUrl != null) ...[
            Text(
              'Video Tutorial',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor),
            ),
            const SizedBox(height: 10),
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: buildRecipeImageProvider(food.coverImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.black, size: 36),
                    onPressed: () {
                      Get.snackbar('Video Player', 'Playing traditional video guide for ${food.nameEnglish}');
                    },
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: context.textPrimary)),
    );
  }

  Widget _buildHistoryTab(BuildContext context, FoodModel food) {
    final activeBrandColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historical Heritage & Background'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeBrandColor),
          ),
          const SizedBox(height: 10),
          Text(
            locCtrl.isKhmer ? food.historyBackgroundKhmer : food.historyBackgroundEnglish,
            style: TextStyle(fontSize: 15, height: 1.6, color: context.textPrimary),
          ),
          const SizedBox(height: 20),
          Text(
            'Cultural Significance'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor),
          ),
          const SizedBox(height: 6),
          Text(food.culturalSignificance, style: TextStyle(fontSize: 14, height: 1.4, color: context.textPrimary)),
          const SizedBox(height: 16),
          Text(
            'Origin Legend'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor),
          ),
          const SizedBox(height: 6),
          Text(food.originStory, style: TextStyle(fontSize: 14, height: 1.4, color: context.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab(BuildContext context, FoodModel food) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: food.ingredients.length,
      itemBuilder: (context, index) {
        final ing = food.ingredients[index];
        return Obx(() {
          final isChecked = detailCtrl.checkedIngredients.length > index
              ? detailCtrl.checkedIngredients[index]
              : false;
          return CheckboxListTile(
            value: isChecked,
            activeColor: context.isDarkMode ? AppColors.primary : AppColors.secondary,
            onChanged: (val) => detailCtrl.toggleIngredientCheck(index),
            title: Text(
              locCtrl.isKhmer ? ing.nameKhmer : ing.nameEnglish,
              style: TextStyle(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? context.textSecondary : context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('${ing.quantity} ${ing.measurement}', style: TextStyle(color: context.textSecondary)),
            secondary: ing.isOptional
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.surfaceBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('optional'.tr, style: TextStyle(fontSize: 10, color: context.textSecondary)),
                  )
                : null,
          );
        });
      },
    );
  }

  Widget _buildStepsTab(BuildContext context, FoodModel food) {
    final activeBrandColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: food.cookingSteps.length,
      itemBuilder: (context, index) {
        final step = food.cookingSteps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      '${step.stepNumber}',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    step.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                locCtrl.isKhmer ? step.descriptionKhmer : step.descriptionEnglish,
                style: TextStyle(fontSize: 14, height: 1.5, color: context.textPrimary),
              ),
              if (step.timerMinutes != null) ...[
                const SizedBox(height: 12),
                Obx(() {
                  final isThisStepRunning =
                      detailCtrl.isTimerRunning.value && detailCtrl.activeTimerStepIndex.value == index;
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isThisStepRunning ? AppColors.accentRed : AppColors.secondary,
                    ),
                    icon: const Icon(Icons.timer, color: Colors.white),
                    label: Text(
                      isThisStepRunning
                          ? 'Timer: ${detailCtrl.remainingSeconds.value ~/ 60}m ${detailCtrl.remainingSeconds.value % 60}s'
                          : 'Start Step Timer (${step.timerMinutes} min)',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (isThisStepRunning) {
                        detailCtrl.stopStepTimer();
                      } else {
                        detailCtrl.startStepTimer(index, step.timerMinutes!);
                      }
                    },
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab(BuildContext context, FoodModel food) {
    final n = food.nutrition;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.emeraldGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Total Calories', style: TextStyle(color: Colors.white70)),
                Text(
                  '${n.calories} kcal',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildNutrientRow(context, 'Protein', '${n.proteinGrams} g'),
          _buildNutrientRow(context, 'Carbohydrates', '${n.carbsGrams} g'),
          _buildNutrientRow(context, 'Total Fat', '${n.fatGrams} g'),
          _buildNutrientRow(context, 'Dietary Fiber', '${n.fiberGrams} g'),
          _buildNutrientRow(context, 'Sodium', '${n.sodiumMg} mg'),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(BuildContext context, String label, String val) {
    final activeBrandColor = context.isDarkMode ? AppColors.primary : AppColors.secondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: context.textPrimary)),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: activeBrandColor)),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, FoodModel food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Submit Review Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leave Your Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.textPrimary)),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 28,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: AppColors.primary),
                  onRatingUpdate: (rating) {
                    detailCtrl.userRating.value = rating;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(color: context.textPrimary),
                  onChanged: (val) => detailCtrl.userComment.value = val,
                  decoration: const InputDecoration(
                    hintText: 'Share your cooking experience...',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => detailCtrl.submitReview(),
                  child: const Text('Submit Review'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Community Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
          const SizedBox(height: 10),
          if (food.reviews.isEmpty)
            Text('No reviews yet. Be the first to try and review!', style: TextStyle(color: context.textSecondary))
          else
            ...food.reviews.map((r) => ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(r.userAvatar)),
                  title: Text(r.userName, style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary)),
                  subtitle: Text(r.comment, style: TextStyle(color: context.textSecondary)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppColors.primary, size: 16),
                      Text('${r.rating}', style: TextStyle(color: context.textPrimary)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
