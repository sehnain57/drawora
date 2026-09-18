import 'package:url_launcher/url_launcher.dart';

class AppConstants {
  static const String appName = 'Drawora';
  static const String appVersion = '1.0.0';
  static const String privacyPolicyUrl =
      'https://www.termsfeed.com/live/2315408c-80d7-4b76-9c8a-efa520804445';

  static Future<void> launchPrivacyPolicy() async {
    final uri = Uri.parse(privacyPolicyUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback in case external application launch fails
      await launchUrl(uri);
    }
  }
}
