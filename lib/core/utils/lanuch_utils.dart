import 'package:localingo/localingo.dart';
import 'package:url_launcher/url_launcher.dart';

import 'locale_keys.dart';

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

  static Future<void> email({
    required String email,
    String? subject,
    String? body,
    required Function(String msg) onError,
  }) async {
    try {
      final Uri uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null && subject.isNotEmpty) 'subject': subject,
          if (body != null && body.isNotEmpty) 'body': body,
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        onError(LocaleKeys.cannotOpenEmailApp);
      }
    } catch (_) {
      onError(LocaleKeys.invalidEmail);
    }
  }
}
