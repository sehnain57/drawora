import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/drawing_controller.dart';
import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';
import '../utils/app_constants.dart';
import '../widgets/bottom_tool_panel.dart';
import '../widgets/drawing_canvas.dart';
import 'onboarding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showMoreMenu(
    BuildContext context,
    DrawingController controller,
    ThemeController themeController,
    bool isDark,
  ) {
    final surfaceColor = AppTheme.getSurfaceColor(isDark);
    final inkColor = AppTheme.getInkColor(isDark);
    final mutedColor = AppTheme.getMutedColor(isDark);
    final borderColor = AppTheme.getBorderColor(isDark);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                    ? Colors.black.withOpacity(0.5)
                    : const Color(0x18000000),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle bar
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Sheet Title
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo.jpg',
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Canvas Options',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: inkColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close_rounded, size: 20, color: mutedColor),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Theme Mode Switch Tile
                Obx(() {
                  final dark = themeController.isDarkMode.value;
                  return _MenuTile(
                    icon: dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    iconColor: dark ? const Color(0xFFFBBF24) : const Color(0xFF6366F1),
                    iconBgColor: dark
                        ? const Color(0xFFFBBF24).withOpacity(0.15)
                        : const Color(0xFF6366F1).withOpacity(0.12),
                    title: 'Appearance',
                    subtitle: dark ? 'Dark Mode active' : 'Light Mode active',
                    trailing: Switch.adaptive(
                      value: dark,
                      activeColor: const Color(0xFF6366F1),
                      onChanged: (_) => themeController.toggleTheme(),
                    ),
                    onTap: themeController.toggleTheme,
                    isDark: isDark,
                  );
                }),
                const SizedBox(height: 10),

                // Clear Canvas Tile
                _MenuTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFFEF4444),
                  iconBgColor: const Color(0xFFEF4444).withOpacity(0.12),
                  title: 'Clear Canvas',
                  subtitle: 'Erase all drawings and start fresh',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: mutedColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    controller.clearCanvas();
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 10),

                // Guide & Tips Tile
                _MenuTile(
                  icon: Icons.auto_stories_rounded,
                  iconColor: const Color(0xFF06B6D4),
                  iconBgColor: const Color(0xFF06B6D4).withOpacity(0.12),
                  title: 'Guide & Tips',
                  subtitle: 'Explore tools, gestures, and features',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: mutedColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(
                      () => const OnboardingScreen(),
                      transition: Transition.downToUp,
                    );
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 10),

                // Privacy Policy Tile
                _MenuTile(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF10B981),
                  iconBgColor: const Color(0xFF10B981).withOpacity(0.12),
                  title: 'Privacy Policy',
                  subtitle: 'Terms, user privacy & data safety',
                  trailing: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: mutedColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    AppConstants.launchPrivacyPolicy();
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: 18),

                // App Version & Quick Links Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Drawora v${AppConstants.appVersion}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: mutedColor.withOpacity(0.8),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: mutedColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        AppConstants.launchPrivacyPolicy();
                      },
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawingController>();
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final canvasColor = AppTheme.getCanvasColor(isDark);
      final inkColor = AppTheme.getInkColor(isDark);
      final mutedColor = AppTheme.getMutedColor(isDark);
      final borderColor = AppTheme.getBorderColor(isDark);
      final capsuleBg =
          isDark ? const Color(0xFF1E212B) : const Color(0xFFF1F5F9);

      return Scaffold(
        backgroundColor: canvasColor,
        appBar: AppBar(
          backgroundColor: canvasColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 16,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.brush_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Drawora',
                style: GoogleFonts.outfit(
                  color: inkColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          actions: [
            // Connected Paired Pill Capsule: Undo & Redo
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: capsuleBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Undo
                  Obx(
                    () => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(18),
                        ),
                        onTap: controller.canUndo ? controller.undo : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Icon(
                            Icons.undo_rounded,
                            size: 18,
                            color: controller.canUndo
                                ? inkColor
                                : mutedColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 16,
                    color: borderColor,
                  ),

                  // Redo
                  Obx(
                    () => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(18),
                        ),
                        onTap: controller.canRedo ? controller.redo : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Icon(
                            Icons.redo_rounded,
                            size: 18,
                            color: controller.canRedo
                                ? inkColor
                                : mutedColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Gradient Export Pill
            GestureDetector(
              onTap: controller.exportAndShare,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.ios_share_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Share',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // More Options Button (...)
            GestureDetector(
              onTap: () => _showMoreMenu(
                context,
                controller,
                themeController,
                isDark,
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: capsuleBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 20,
                  color: inkColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: const DrawingCanvas(),
        bottomSheet: const BottomToolPanel(),
      );
    });
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;
  final bool isDark;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final inkColor = AppTheme.getInkColor(isDark);
    final mutedColor = AppTheme.getMutedColor(isDark);
    final borderColor = AppTheme.getBorderColor(isDark);
    final tileBg = isDark ? const Color(0xFF1E212B) : const Color(0xFFF8FAFC);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: inkColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mutedColor,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
