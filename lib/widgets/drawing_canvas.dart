import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/drawing_controller.dart';
import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';
import 'sketch_painter.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawingController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final canvasBg = AppTheme.getCanvasColor(isDark);

      return RepaintBoundary(
        key: controller.canvasKey,
        child: Container(
          color: canvasBg,
          width: double.infinity,
          height: double.infinity,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (details) {
              controller.startStroke(details.localPosition);
            },
            onPanUpdate: (details) {
              controller.extendStroke(details.localPosition);
            },
            onPanEnd: (_) => controller.endStroke(),
            child: CustomPaint(
              painter: SketchPainter(
                strokes: controller.strokes.toList(),
                backgroundColor: canvasBg,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      );
    });
  }
}
