import 'package:localingo/localingo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../locale_keys.dart';

class LaunchUtils {
  LaunchUtils._();

  static Future<void> open({
    required String url,
    required Function(String msg) onError,
  }) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        onError(LocaleKeys.cannotOpenLink);
      }
    } catch (_) {
      onError(LocaleKeys.invalidLink);
    }
  }

  static Future<void> call({
    required String phone,
    required Function(String msg) onError,
  }) async {
    try {
      final Uri uri = Uri.parse('tel:$phone');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        onError(LocaleKeys.cannotOpenCallApp);
      }
    } catch (_) {
      onError(LocaleKeys.invalidNumber);
    }
  }
}
