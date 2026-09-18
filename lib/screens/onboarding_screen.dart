import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/theme_controller.dart';
import '../theme/app_theme.dart';
import '../utils/app_constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final AnimationController _floatingController;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Draw with Pure Freedom',
      subtitle:
          'Experience a zero-latency canvas built for effortless ideas, fluid strokes, and spontaneous sketching.',
      icon: Icons.gesture_rounded,
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      badgeText: 'Fluid Engine',
    ),
    _OnboardingData(
      title: 'Precision Tools & Palettes',
      subtitle:
          'Fine-tune stroke sizes, explore curated vibrant color swatches, and switch to a smart eraser with one tap.',
      icon: Icons.palette_rounded,
      primaryColor: const Color(0xFFEC4899),
      secondaryColor: const Color(0xFFF43F5E),
      badgeText: 'Curated Tools',
    ),
    _OnboardingData(
      title: 'Instant High-Res Export',
      subtitle:
          'Export your artwork in crystal-clear HD PNG format and share directly with friends, team, or collaborators.',
      icon: Icons.ios_share_rounded,
      primaryColor: const Color(0xFF06B6D4),
      secondaryColor: const Color(0xFF3B82F6),
      badgeText: '1-Tap Share',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    Get.offAll(
      () => const HomeScreen(),
      transition: Transition.rightToLeftWithFade,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final canvasColor = AppTheme.getCanvasColor(isDark);
      final surfaceColor = AppTheme.getSurfaceColor(isDark);
      final inkColor = AppTheme.getInkColor(isDark);
      final mutedColor = AppTheme.getMutedColor(isDark);

      return Scaffold(
        backgroundColor: canvasColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar: Skip button and Theme toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand mark
                    Row(
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
                        const SizedBox(width: 10),
                        Text(
                          'Drawora',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: inkColor,
                          ),
                        ),
                      ],
                    ),

                    // Skip & Theme Toggle
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: inkColor,
                            size: 20,
                          ),
                          onPressed: themeController.toggleTheme,
                          tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                        ),
                        TextButton(
                          onPressed: _finishOnboarding,
                          child: Text(
                            'Skip',
                            style: GoogleFonts.outfit(
                              color: mutedColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // PageView Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Illustration Card with Floating Effect
                          AnimatedBuilder(
                            animation: _floatingController,
                            builder: (context, child) {
                              final offset =
                                  (1.0 - _floatingController.value) * 12.0;
                              return Transform.translate(
                                offset: Offset(0, offset),
                                child: child,
                              );
                            },
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(36),
                                border: Border.all(
                                  color: AppTheme.getBorderColor(isDark),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: page.primaryColor.withOpacity(
                                      isDark ? 0.25 : 0.15,
                                    ),
                                    blurRadius: 36,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Ambient radial gradient
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          page.primaryColor.withOpacity(
                                            isDark ? 0.35 : 0.2,
                                          ),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Icon Badge
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          page.primaryColor,
                                          page.secondaryColor,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: [
                                        BoxShadow(
                                          color: page.primaryColor.withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      page.icon,
                                      size: 46,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Floating Chip Badge
                                  Positioned(
                                    bottom: 24,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.black.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        page.badgeText,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: page.primaryColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 44),

                          // Title
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: inkColor,
                              letterSpacing: -0.5,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Subtitle
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: mutedColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section: Animated Indicators & Action Button
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Smooth Expanding Indicator Dots
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentPage == index ? 28 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _pages[_currentPage].primaryColor
                                : (isDark
                                    ? Colors.white24
                                    : Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    // Next / Get Started Gradient Button
                    GestureDetector(
                      onTap: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOutCubic,
                          );
                        } else {
                          _finishOnboarding();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: _currentPage == _pages.length - 1 ? 26 : 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _pages[_currentPage].primaryColor,
                              _pages[_currentPage].secondaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: _pages[_currentPage]
                                  .primaryColor
                                  .withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Continue',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _pages.length - 1
                                  ? Icons.check_circle_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom subtle footer
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Drawora v${AppConstants.appVersion}',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: mutedColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
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
                      onTap: AppConstants.launchPrivacyPolicy,
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String badgeText;

  _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.badgeText,
  });
}
