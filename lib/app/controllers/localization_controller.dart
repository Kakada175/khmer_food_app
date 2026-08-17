import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  bool get isKhmer => currentLocale.value.languageCode == 'km';

  void toggleLanguage() {
    if (isKhmer) {
      currentLocale.value = const Locale('en', 'US');
      Get.updateLocale(currentLocale.value);
    } else {
      currentLocale.value = const Locale('km', 'KH');
      Get.updateLocale(currentLocale.value);
    }
  }

  void changeLanguage(String langCode) {
    if (langCode == 'km') {
      currentLocale.value = const Locale('km', 'KH');
    } else {
      currentLocale.value = const Locale('en', 'US');
    }
    Get.updateLocale(currentLocale.value);
  }
}
