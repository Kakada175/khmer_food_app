class CookingStepModel {
  final int stepNumber;
  final String title;
  final String descriptionKhmer;
  final String descriptionEnglish;
  final String? photoUrl;
  final int? timerMinutes;

  CookingStepModel({
    required this.stepNumber,
    required this.title,
    required this.descriptionKhmer,
    required this.descriptionEnglish,
    this.photoUrl,
    this.timerMinutes,
  });

  factory CookingStepModel.fromJson(Map<String, dynamic> json) {
    return CookingStepModel(
      stepNumber: json['stepNumber'] ?? 1,
      title: json['title'] ?? '',
      descriptionKhmer: json['descriptionKhmer'] ?? '',
      descriptionEnglish: json['descriptionEnglish'] ?? '',
      photoUrl: json['photoUrl'],
      timerMinutes: json['timerMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'descriptionKhmer': descriptionKhmer,
      'descriptionEnglish': descriptionEnglish,
      'photoUrl': photoUrl,
      'timerMinutes': timerMinutes,
    };
  }
}
