import 'package:flutter/material.dart';

class ProvinceModel {
  final String id;
  final String nameKhmer;
  final String nameEnglish;
  final String region; // Capital, Central, Coastal, Tonle Sap, Plateau
  final String descriptionKhmer;
  final String descriptionEnglish;
  final String imageUrl;
  final List<String> famousFoodIds;
  final List<String> famousDesserts;
  final List<String> localIngredients;
  final List<String> foodFestivals;

  ProvinceModel({
    required this.id,
    required this.nameKhmer,
    required this.nameEnglish,
    required this.region,
    required this.descriptionKhmer,
    required this.descriptionEnglish,
    required this.imageUrl,
    required this.famousFoodIds,
    required this.famousDesserts,
    required this.localIngredients,
    required this.foodFestivals,
  });

  Color get themeColor {
    switch (id) {
      case 'prov_phnompenh':
        return const Color(0xFFD4AF37); // Royal Gold for Capital Phnom Penh
      case 'prov_siemreap':
        return const Color(0xFF1E6B54); // Angkor Emerald Green for Siem Reap
      case 'prov_kampot':
        return const Color(0xFF0077B6); // Ocean Coastal Blue for Kampot Pepper
      case 'prov_battambang':
        return const Color(0xFFE07A5F); // Terracotta Harvest Orange for Battambang
      case 'prov_kandal':
        return const Color(0xFFC2185B); // Mekong Lotus Pink for Kandal
      default:
        return const Color(0xFFD4AF37);
    }
  }

  LinearGradient get themeGradient {
    return LinearGradient(
      colors: [themeColor, themeColor.withValues(alpha: 0.75)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: json['id'] ?? '',
      nameKhmer: json['nameKhmer'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      region: json['region'] ?? '',
      descriptionKhmer: json['descriptionKhmer'] ?? '',
      descriptionEnglish: json['descriptionEnglish'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      famousFoodIds: List<String>.from(json['famousFoodIds'] ?? []),
      famousDesserts: List<String>.from(json['famousDesserts'] ?? []),
      localIngredients: List<String>.from(json['localIngredients'] ?? []),
      foodFestivals: List<String>.from(json['foodFestivals'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKhmer': nameKhmer,
      'nameEnglish': nameEnglish,
      'region': region,
      'descriptionKhmer': descriptionKhmer,
      'descriptionEnglish': descriptionEnglish,
      'imageUrl': imageUrl,
      'famousFoodIds': famousFoodIds,
      'famousDesserts': famousDesserts,
      'localIngredients': localIngredients,
      'foodFestivals': foodFestivals,
    };
  }
}
