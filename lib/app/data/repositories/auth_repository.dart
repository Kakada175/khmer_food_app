import '../models/user_model.dart';

class AuthRepository {
  UserModel _currentUser = UserModel(
    id: 'usr_001',
    name: 'Sokha Rith',
    email: 'sokha@khmerfood.app',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    role: UserRole.registered,
    favoriteFoodIds: ['food_fish_amok', 'food_pepper_crab'],
    favoriteVideoIds: [],
    downloadedFoodIds: ['food_fish_amok'],
  );

  UserModel get currentUser => _currentUser;

  UserModel loginAsGuest() {
    _currentUser = UserModel.guest();
    return _currentUser;
  }

  UserModel login(String email, String password) {
    if (email.contains('admin')) {
      _currentUser = UserModel(
        id: 'usr_admin',
        name: 'Master Admin',
        email: email,
        avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80',
        role: UserRole.admin,
      );
    } else {
      _currentUser = UserModel(
        id: 'usr_reg',
        name: 'Cambodian Foodie',
        email: email,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
        role: UserRole.registered,
        favoriteFoodIds: ['food_fish_amok'],
      );
    }
    return _currentUser;
  }

  UserModel register(String name, String email, String password) {
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
      role: UserRole.registered,
    );
    return _currentUser;
  }

  void switchRole(UserRole role) {
    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      avatarUrl: _currentUser.avatarUrl,
      role: role,
      favoriteFoodIds: _currentUser.favoriteFoodIds,
      favoriteVideoIds: _currentUser.favoriteVideoIds,
      downloadedFoodIds: _currentUser.downloadedFoodIds,
    );
  }

  void toggleFavoriteFood(String foodId) {
    final updatedList = List<String>.from(_currentUser.favoriteFoodIds);
    if (updatedList.contains(foodId)) {
      updatedList.remove(foodId);
    } else {
      updatedList.add(foodId);
    }
    _currentUser = UserModel(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      avatarUrl: _currentUser.avatarUrl,
      role: _currentUser.role,
      favoriteFoodIds: updatedList,
      favoriteVideoIds: _currentUser.favoriteVideoIds,
      downloadedFoodIds: _currentUser.downloadedFoodIds,
    );
  }
}
