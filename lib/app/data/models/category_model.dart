class CategoryModel {
  final String id;
  final String nameKhmer;
  final String nameEnglish;
  final String icon;
  final String imageUrl;
  final int foodCount;

  CategoryModel({
    required this.id,
    required this.nameKhmer,
    required this.nameEnglish,
    required this.icon,
    required this.imageUrl,
    this.foodCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      nameKhmer: json['nameKhmer'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      icon: json['icon'] ?? '🍜',
      imageUrl: json['imageUrl'] ?? '',
      foodCount: json['foodCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKhmer': nameKhmer,
      'nameEnglish': nameEnglish,
      'icon': icon,
      'imageUrl': imageUrl,
      'foodCount': foodCount,
    };
  }
}
