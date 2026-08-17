enum UserRole { guest, registered, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final UserRole role;
  final List<String> favoriteFoodIds;
  final List<String> favoriteVideoIds;
  final List<String> downloadedFoodIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    this.favoriteFoodIds = const [],
    this.favoriteVideoIds = const [],
    this.downloadedFoodIds = const [],
  });

  bool get isGuest => role == UserRole.guest;
  bool get isAdmin => role == UserRole.admin;

  factory UserModel.guest() {
    return UserModel(
      id: 'guest',
      name: 'Guest Explorer',
      email: 'guest@khmerfood.app',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
      role: UserRole.guest,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => UserRole.registered,
      ),
      favoriteFoodIds: List<String>.from(json['favoriteFoodIds'] ?? []),
      favoriteVideoIds: List<String>.from(json['favoriteVideoIds'] ?? []),
      downloadedFoodIds: List<String>.from(json['downloadedFoodIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.toString(),
      'favoriteFoodIds': favoriteFoodIds,
      'favoriteVideoIds': favoriteVideoIds,
      'downloadedFoodIds': downloadedFoodIds,
    };
  }
}
