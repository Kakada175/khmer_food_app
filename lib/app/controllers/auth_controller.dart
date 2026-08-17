import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final Rx<UserModel> currentUser = UserModel.guest().obs;

  bool get isGuest => currentUser.value.isGuest;
  bool get isAdmin => currentUser.value.isAdmin;
  bool get isRegistered => currentUser.value.role == UserRole.registered;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authRepository.currentUser;
  }

  void loginAsGuest() {
    currentUser.value = _authRepository.loginAsGuest();
    if (Get.context != null) {
      Get.snackbar('Guest Mode', 'Browsing in Guest Mode');
    }
  }

  void login(String email, String password) {
    currentUser.value = _authRepository.login(email, password);
    if (Get.context != null) {
      Get.snackbar('Welcome Back', 'Logged in as ${currentUser.value.name}');
    }
  }

  void register(String name, String email, String password) {
    currentUser.value = _authRepository.register(name, email, password);
    if (Get.context != null) {
      Get.snackbar('Account Created', 'Welcome to Khmer Food Explorer!');
    }
  }

  void switchRole(UserRole role) {
    _authRepository.switchRole(role);
    currentUser.value = _authRepository.currentUser;
    if (Get.context != null) {
      Get.snackbar('Role Switched', 'Current role: ${role.toString().split('.').last.toUpperCase()}');
    }
  }

  void toggleFavorite(String foodId) {
    if (isGuest) {
      if (Get.context != null) {
        Get.snackbar('Sign In Required', 'Please log in to save favorites');
      }
      return;
    }
    _authRepository.toggleFavoriteFood(foodId);
    currentUser.value = _authRepository.currentUser;
  }

  bool isFavorite(String foodId) {
    return currentUser.value.favoriteFoodIds.contains(foodId);
  }
}
