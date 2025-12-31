
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_controller.dart';

class FcmInitHelper {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static final AwesomeNotifications _awesomeNotifications =
      AwesomeNotifications();

  static Future<void> initAwesomeNotification() async {
    await _awesomeNotifications.initialize(null, [
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'Push Notifications',
        channelDescription: 'Notification channel for app push notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: const Color(0xFF9D50DD),
        importance: NotificationImportance.Max,
        playSound: true,
      ),
    ]);
  }

  // static Future<void> _showAwesomeNotification(RemoteMessage message) async {
  //   await _awesomeNotifications.createNotification(
  //     content: NotificationContent(
  //       id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
  //       channelKey: 'high_importance_channel',
  //       title: message.notification?.title ?? 'No title',
  //       body: message.notification?.body ?? 'No body',
  //     ),
  //   );
  // }

  static Future<void> setAwesomeNotificationListeners() async {
    await _awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  static Future<void> initFirebaseMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.data}");
      
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("📲 Notification opened (background): ${message.data}");
     
    });
  }

  static Future<void> handleInitialMessage() async {
    // final RemoteMessage? message =
    //     await FcmInitHelper.firebaseMessaging.getInitialMessage();
    
  }

  static Future<String?> getFcmToken() async {
    final token = await firebaseMessaging.getToken();
    debugPrint("📱 Device FCM Token: $token");
    return token;
  }

  
}
