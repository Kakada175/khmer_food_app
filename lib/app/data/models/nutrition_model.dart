class NutritionModel {
  final int calories;
  final double proteinGrams;
  final double fatGrams;
  final double carbsGrams;
  final double fiberGrams;
  final double sodiumMg;

  NutritionModel({
    required this.calories,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbsGrams,
    required this.fiberGrams,
    required this.sodiumMg,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      calories: json['calories'] ?? 0,
      proteinGrams: (json['proteinGrams'] ?? 0.0).toDouble(),
      fatGrams: (json['fatGrams'] ?? 0.0).toDouble(),
      carbsGrams: (json['carbsGrams'] ?? 0.0).toDouble(),
      fiberGrams: (json['fiberGrams'] ?? 0.0).toDouble(),
      sodiumMg: (json['sodiumMg'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'proteinGrams': proteinGrams,
      'fatGrams': fatGrams,
      'carbsGrams': carbsGrams,
      'fiberGrams': fiberGrams,
      'sodiumMg': sodiumMg,
    };
  }
}
