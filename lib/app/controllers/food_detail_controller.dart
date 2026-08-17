import 'dart:async';
import 'package:get/get.dart';
import '../data/models/food_model.dart';
import '../data/models/review_model.dart';
import '../data/repositories/food_repository.dart';
import 'auth_controller.dart';

class FoodDetailController extends GetxController {
  final FoodRepository foodRepository;
  FoodDetailController(this.foodRepository);

  final Rxn<FoodModel> food = Rxn<FoodModel>();
  final RxInt selectedTab = 0.obs; // 0: Overview, 1: History, 2: Ingredients, 3: Steps, 4: Reviews
  final RxList<bool> checkedIngredients = <bool>[].obs;

  // Step Timer
  final RxInt activeTimerStepIndex = (-1).obs;
  final RxInt remainingSeconds = 0.obs;
  final RxBool isTimerRunning = false.obs;
  Timer? _timer;

  // Review Form
  final RxDouble userRating = 5.0.obs;
  final RxString userComment = ''.obs;

  // Download Status
  final RxBool isDownloaded = false.obs;

  void loadFood(String foodId) {
    final loaded = foodRepository.getFoodById(foodId);
    if (loaded != null) {
      food.value = loaded;
      checkedIngredients.value = List.filled(loaded.ingredients.length, false);
    }
  }

  void toggleIngredientCheck(int index) {
    if (index >= 0 && index < checkedIngredients.length) {
      checkedIngredients[index] = !checkedIngredients[index];
    }
  }

  void startStepTimer(int stepIndex, int minutes) {
    stopStepTimer();
    activeTimerStepIndex.value = stepIndex;
    remainingSeconds.value = minutes * 60;
    isTimerRunning.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        stopStepTimer();
        Get.snackbar(
          'Timer Finished! ⏰',
          'Cooking step ${stepIndex + 1} timer has completed.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  void stopStepTimer() {
    _timer?.cancel();
    isTimerRunning.value = false;
    activeTimerStepIndex.value = -1;
  }

  void submitReview() {
    final authCtrl = Get.find<AuthController>();
    if (authCtrl.isGuest) {
      Get.snackbar('Sign In Required', 'Please sign in to leave a review.');
      return;
    }

    if (userComment.value.trim().isEmpty) {
      Get.snackbar('Empty Review', 'Please enter your review text.');
      return;
    }

    if (food.value != null) {
      final review = ReviewModel(
        id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
        userName: authCtrl.currentUser.value.name,
        userAvatar: authCtrl.currentUser.value.avatarUrl,
        rating: userRating.value,
        comment: userComment.value.trim(),
        date: 'Just now',
      );

      foodRepository.addReview(food.value!.id, review);
      loadFood(food.value!.id);
      userComment.value = '';
      Get.snackbar('Thank You!', 'Your review has been submitted.');
    }
  }

  void toggleDownload() {
    isDownloaded.value = !isDownloaded.value;
    if (isDownloaded.value) {
      Get.snackbar('Offline Mode', 'Recipe downloaded for offline cooking! 📥');
    } else {
      Get.snackbar('Offline Mode', 'Recipe removed from offline cache.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
