import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/drawing_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DraworaApp());
}

class DraworaApp extends StatelessWidget {
  const DraworaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return SafeArea(
      top: false,
      child: Obx(
        () => GetMaterialApp(
          title: 'Drawora',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.currentThemeMode,
          initialBinding: BindingsBuilder(() {
            Get.put(DrawingController());
          }),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
