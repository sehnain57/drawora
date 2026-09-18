import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/theme_controller.dart';
import '../models/stroke.dart';
import '../theme/app_theme.dart';

class DrawingController extends GetxController {
  // Committed strokes on the canvas.
  final RxList<Stroke> strokes = <Stroke>[].obs;

  // Strokes popped off by undo, kept so redo can restore them.
  final RxList<Stroke> redoStack = <Stroke>[].obs;

  // Current tool settings.
  final Rx<Color> currentColor = AppPalette.colors.first.obs;
  final RxDouble strokeWidth = 6.0.obs;
  final RxBool isEraser = false.obs;

  // Whether anything has been drawn (used to enable/disable actions).
  bool get canUndo => strokes.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  // Key used to capture the canvas as an image for export.
  final GlobalKey canvasKey = GlobalKey();

  Stroke? _activeStroke;

  @override
  void onInit() {
    super.onInit();
    // React to theme changes to keep default stroke contrasting if untouched
    if (Get.isRegistered<ThemeController>()) {
      final themeController = Get.find<ThemeController>();
      ever(themeController.isDarkMode, (bool isDark) {
        // If current color is either black or white, adjust to match contrast
        if (currentColor.value == AppPalette.colors[0] && isDark) {
          currentColor.value = AppPalette.colors[1]; // pure white
        } else if (currentColor.value == AppPalette.colors[1] && !isDark) {
          currentColor.value = AppPalette.colors[0]; // deep slate
        }
      });
    }
  }

  void startStroke(Offset point) {
    _activeStroke = Stroke(
      points: [point],
      color: currentColor.value,
      width: strokeWidth.value,
      isEraser: isEraser.value,
    );
    strokes.add(_activeStroke!);
    // A fresh stroke invalidates the redo history.
    redoStack.clear();
  }

  void extendStroke(Offset point) {
    if (_activeStroke == null) return;
    _activeStroke!.points.add(point);
    // Trigger reactivity by reassigning the last item.
    strokes[strokes.length - 1] = _activeStroke!;
  }

  void endStroke() {
    _activeStroke = null;
  }

  void undo() {
    if (strokes.isEmpty) return;
    final last = strokes.removeLast();
    redoStack.add(last);
  }

  void redo() {
    if (redoStack.isEmpty) return;
    final stroke = redoStack.removeLast();
    strokes.add(stroke);
  }

  void clearCanvas() {
    if (strokes.isEmpty) return;

    final isDark = Get.isRegistered<ThemeController>() &&
        Get.find<ThemeController>().isDarkMode.value;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppTheme.getSurfaceColor(isDark),
        title: Text(
          'Clear sketch?',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppTheme.getInkColor(isDark),
          ),
        ),
        content: Text(
          'This will erase everything on your canvas. This action cannot be undone.',
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: AppTheme.getMutedColor(isDark),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: AppTheme.getMutedColor(isDark),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              strokes.clear();
              redoStack.clear();
              Get.back();
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectColor(Color color) {
    currentColor.value = color;
    isEraser.value = false;
  }

  void toggleEraser() {
    isEraser.value = !isEraser.value;
  }

  void setStrokeWidth(double width) {
    strokeWidth.value = width;
  }

  Future<void> exportAndShare() async {
    try {
      final boundary = canvasKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/drawora_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Created with Drawora ✨');
    } catch (e) {
      Get.snackbar(
        'Export failed',
        'Could not save the sketch. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
