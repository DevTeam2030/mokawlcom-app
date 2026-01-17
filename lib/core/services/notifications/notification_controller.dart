import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
     await getIt<FcmInitHelper>().navigateToNotifications();
  }
}
