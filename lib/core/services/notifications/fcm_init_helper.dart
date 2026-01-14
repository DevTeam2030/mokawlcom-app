import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_controller.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';

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

  static Future<void> _showAwesomeNotification(RemoteMessage message) async {
    await _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'high_importance_channel',
        title: message.notification?.title ?? 'No title',
        body: message.notification?.body ?? 'No body',
      ),
    );
  }

  static Future<void> setAwesomeNotificationListeners() async {
    await _awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  static Future<void> initFirebaseMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.data}");
      final curentRoute = getIt<AppRouter>().current.name;
      if (curentRoute == NotificationsRoute.name) {
        return;
      }
      _showAwesomeNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("📲 Notification opened (background): ${message.data}");
      await navigateToNotifications();
    });
  }

  static Future<void> handleInitialMessage() async {
    final RemoteMessage? message =
        await FcmInitHelper.firebaseMessaging.getInitialMessage();
    if (message != null) {
      await getIt<AppRouter>().replaceAll([
        const AuthenticatedRoute(children: [BottomNavBarRoute()]),
      ]);
      getIt<AppCubit>().toggleTabs(tabIndex: 1);
    }
  }

  static Future<void> navigateToNotifications() async {
    final String currentRoute = getIt<AppRouter>().current.name;
    if (currentRoute == SplashTabRoute.name) {
      await getIt<AppRouter>().replaceAll([
        const AuthenticatedRoute(children: [BottomNavBarRoute()]),
      ]);
      getIt<AppCubit>().toggleTabs(tabIndex: 1);
    } else if (currentRoute == AuthenticatedRoute.name ||
        currentRoute == BottomNavBarRoute.name) {
      getIt<AppCubit>().toggleTabs(tabIndex: 1);
    }
  }

  static Future<String?> getFcmToken() async {
    final token = await firebaseMessaging.getToken();
    debugPrint("📱 Device FCM Token: $token");
    return token;
  }
}
