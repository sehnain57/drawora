import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  ThemeMode get currentThemeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(currentThemeMode);
  }

  void setThemeMode(bool dark) {
    if (isDarkMode.value == dark) return;
    isDarkMode.value = dark;
    Get.changeThemeMode(currentThemeMode);
  }
}
