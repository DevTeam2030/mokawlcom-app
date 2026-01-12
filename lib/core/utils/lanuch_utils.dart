import 'package:url_launcher/url_launcher.dart';

class LaunchUtils {
  LaunchUtils._();

  /// Opens any URL received directly from backend
  /// Examples:
  /// https://wa.me/201234567890
  /// https://www.facebook.com/username
  /// tel:+20123456789
  /// mailto:test@mail.com
  static Future<void> open({
    required String url,
    required Function(String msg) onError,
  }) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        onError('لا يمكن فتح الرابط');
      }
    } catch (_) {
      onError('رابط غير صالح');
    }
  }
}
