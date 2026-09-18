import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/drawing_controller.dart';
import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';

class BottomToolPanel extends StatelessWidget {
  const BottomToolPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawingController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final surfaceColor = AppTheme.getSurfaceColor(isDark);
      final borderColor = AppTheme.getBorderColor(isDark);
      final mutedColor = AppTheme.getMutedColor(isDark);
      final accentColor = AppTheme.getAccentColor(isDark);

      return Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : const Color(0x12000000),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color swatches + eraser toggle
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: AppPalette.colors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final color = AppPalette.colors[index];
                          return Obx(() {
                            final isSelected = !controller.isEraser.value &&
                                controller.currentColor.value.value ==
                                    color.value;

                            return Center(
                              child: GestureDetector(
                                onTap: () => controller.selectColor(color),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  width: isSelected ? 38 : 30,
                                  height: isSelected ? 38 : 30,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? accentColor
                                          : (color == Colors.white
                                              ? (isDark
                                                  ? Colors.white38
                                                  : Colors.black12)
                                              : Colors.transparent),
                                      width: isSelected ? 3 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? accentColor.withOpacity(0.4)
                                            : Colors.transparent,
                                        blurRadius: isSelected ? 8 : 0,
                                        offset: isSelected
                                            ? const Offset(0, 2)
                                            : Offset.zero,
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: color.computeLuminance() > 0.5
                                                  ? Colors.black87
                                                  : Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    _EraserButton(
                      controller: controller,
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Brush size slider + live stroke preview
              Row(
                children: [
                  // Dynamic brush tip preview icon
                  Obx(
                    () => Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      child: Container(
                        width: (controller.strokeWidth.value * 0.8)
                            .clamp(4.0, 24.0),
                        height: (controller.strokeWidth.value * 0.8)
                            .clamp(4.0, 24.0),
                        decoration: BoxDecoration(
                          color: controller.isEraser.value
                              ? mutedColor
                              : controller.currentColor.value,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.white30 : Colors.black12,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          activeTrackColor: accentColor,
                          inactiveTrackColor: isDark
                              ? Colors.white12
                              : Colors.black.withOpacity(0.08),
                          thumbColor: accentColor,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 9,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 18,
                          ),
                        ),
                        child: Slider(
                          value: controller.strokeWidth.value,
                          min: 2,
                          max: 32,
                          onChanged: controller.setStrokeWidth,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: 34,
                      child: Text(
                        '${controller.strokeWidth.value.toInt()}px',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.outfit(
                          color: mutedColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _EraserButton extends StatelessWidget {
  final DrawingController controller;
  final bool isDark;
  final Color accentColor;

  const _EraserButton({
    required this.controller,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.isEraser.value;

      return GestureDetector(
        onTap: controller.toggleEraser,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: active
                ? accentColor
                : (isDark
                    ? const Color(0xFF272B38)
                    : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? accentColor
                  : (isDark ? Colors.white10 : Colors.black.withOpacity(0.06)),
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? accentColor.withOpacity(0.4)
                    : Colors.transparent,
                blurRadius: active ? 10 : 0,
                offset: active ? const Offset(0, 3) : Offset.zero,
              ),
            ],
          ),
          child: Icon(
            Icons.auto_fix_normal_rounded,
            size: 22,
            color: active
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF0F172A)),
          ),
        ),
      );
    });
  }
}
