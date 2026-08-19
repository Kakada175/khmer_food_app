import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/laravel_api_service.dart';

class AuthRepository {
  final LaravelApiService _api = Get.find<LaravelApiService>();

  UserModel _currentUser = UserModel.guest();

  UserModel get currentUser => _currentUser;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
  }

  UserModel loginAsGuest() {
    _currentUser = UserModel.guest();
    return _currentUser;
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _api.login(email, password);
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }

  Future<UserModel?> register(String name, String email, String password) async {
    final user = await _api.register(name, email, password);
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }

  Future<UserModel?> switchRole(String userId, UserRole role) async {
    // role.toString() yields e.g. "UserRole.admin"
    final user = await _api.switchRole(userId, role.toString());
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }

  Future<UserModel?> toggleFavoriteFood(String userId, String foodId) async {
    final user = await _api.toggleFavorite(userId, foodId);
    if (user != null) {
      _currentUser = user;
    }
    return user;
  }
}
