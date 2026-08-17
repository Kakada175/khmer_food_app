class IngredientModel {
  final String id;
  final String nameKhmer;
  final String nameEnglish;
  final String quantity;
  final String measurement;
  final bool isOptional;

  IngredientModel({
    required this.id,
    required this.nameKhmer,
    required this.nameEnglish,
    required this.quantity,
    required this.measurement,
    this.isOptional = false,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? '',
      nameKhmer: json['nameKhmer'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      quantity: json['quantity'] ?? '',
      measurement: json['measurement'] ?? '',
      isOptional: json['isOptional'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKhmer': nameKhmer,
      'nameEnglish': nameEnglish,
      'quantity': quantity,
      'measurement': measurement,
      'isOptional': isOptional,
    };
  }
}
