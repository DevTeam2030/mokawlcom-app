import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint("Notification action received: ${receivedAction.payload}");
    try {
      await FcmInitHelper().navigateToNotifications(
        isOffer: receivedAction.payload?['type'] != 'public',
      );
    } catch (e) {
      debugPrint("Error handling notification action: $e");
    }
  }
}
