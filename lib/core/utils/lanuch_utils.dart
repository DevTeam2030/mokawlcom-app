import 'package:url_launcher/url_launcher.dart';

class LaunchUtils {
  LaunchUtils._();

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

  static Future<void> call({
    required String phone,
    required Function(String msg) onError,
  }) async {
    try {
      final Uri uri = Uri.parse('tel:$phone');

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        onError('لا يمكن فتح تطبيق المكالمات');
      }
    } catch (_) {
      onError('رقم غير صالح');
    }
  }
}
