class CollectionModel {
  final String id;
  final String title;
  final String description;
  final String coverImageUrl;
  final List<String> foodIds;
  final bool isDefault;

  CollectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImageUrl,
    required this.foodIds,
    this.isDefault = false,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      foodIds: List<String>.from(json['foodIds'] ?? []),
      isDefault: json['isDefault'] == true || json['isDefault'] == 1 || json['isDefault'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'foodIds': foodIds,
      'isDefault': isDefault,
    };
  }
}
