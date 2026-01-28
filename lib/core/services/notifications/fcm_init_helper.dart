import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_controller.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_service.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';

class FcmInitHelper {
  static final FcmInitHelper _instance = FcmInitHelper._internal();
  factory FcmInitHelper() => _instance;
  FcmInitHelper._internal();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();
  final NotificationService _notificationService = NotificationService();
  final AppRouter _appRouter = getIt<AppRouter>();

  Future<void> initAwesomeNotification() async {
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

  Future<void> _showAwesomeNotification(RemoteMessage message) async {
    await _awesomeNotifications.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'high_importance_channel',
        title: message.notification?.title ?? 'No title',
        body: message.notification?.body ?? 'No body',
        payload: {'type': message.data['type'] ?? 'unknown'},
      ),
    );
  }

  Future<void> setAwesomeNotificationListeners() async {
    await _awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  Future<void> initFirebaseMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("📩 Foreground message: ${message.data}");
      final currentRoute = AppConstants.currentRoute;
      debugPrint(">>>>>>>>>>>>> Current route: $currentRoute");
      debugPrint(">>>>>>>>>>>>> Current route: ${_appRouter.currentChild?.name ?? 'messi'}");

      final notificationData = NotificationData.fromRemoteMessage(message);

      _notificationService.addNotification(notificationData);

      if (currentRoute == NotificationsRoute.name ||
          currentRoute == PublicNotificationsRoute.name ||
          currentRoute == PriceOffersRoute.name ||
          currentRoute == SubmittedPriceOffersRoute.name) {
        debugPrint("User is on notifications screen, skipping popup");
        return;
      }

      _showAwesomeNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("Notification opened (background): ${message.data}");

      final notificationData = NotificationData.fromRemoteMessage(message);

      _notificationService.addNotification(notificationData);

      await _navigateToNotificationsTab(type: notificationData.type);
    });
  }

  Future<void> _navigateToNotificationsTab({
    required NotificationType type,
  }) async {
    try {
      if (type == NotificationType.offerNotification ||
          type == NotificationType.replyOnOffer) {
        if (AppConstants.userType == UserType.contractor) {
          await _appRouter.navigate(
            const AuthenticatedRoute(
              children: [
                BottomNavBarRoute(
                  children: [
                    NotificationsRoute(children: [PriceOffersRoute()]),
                  ],
                ),
              ],
            ),
          );
        } else {
          await _appRouter.navigate(
            const AuthenticatedRoute(
              children: [
                BottomNavBarRoute(
                  children: [
                    NotificationsRoute(children: [SubmittedPriceOffersRoute()]),
                  ],
                ),
              ],
            ),
          );
        }
      } else {
        await _appRouter.navigate(
          const AuthenticatedRoute(
            children: [
              BottomNavBarRoute(
                children: [
                  NotificationsRoute(children: [PublicNotificationsRoute()]),
                ],
              ),
            ],
          ),
        );
      }
      debugPrint("✅ Navigation to notifications tab completed");
    } catch (e) {
      debugPrint("❌ Error navigating to notifications: $e");
    }
  }

  Future<void> navigateToNotifications({required bool isOffer}) async {
    await _navigateToNotificationsTab(
      type: isOffer
          ? NotificationType.offerNotification
          : NotificationType.publicNotification,
    );
  }

  Future<void> handleInitialMessage() async {
    final RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      debugPrint("App opened from terminated state by notification");

      final notificationData = NotificationData.fromRemoteMessage(message);

      if (notificationData.type == NotificationType.offerNotification ||
          notificationData.type == NotificationType.replyOnOffer) {
        if (AppConstants.userType == UserType.contractor) {
          await _appRouter.replaceAll([
            const AuthenticatedRoute(
              children: [
                BottomNavBarRoute(
                  children: [
                    NotificationsRoute(children: [PriceOffersRoute()]),
                  ],
                ),
              ],
            ),
          ]);
        } else {
          await _appRouter.replaceAll([
            const AuthenticatedRoute(
              children: [
                BottomNavBarRoute(
                  children: [
                    NotificationsRoute(children: [SubmittedPriceOffersRoute()]),
                  ],
                ),
              ],
            ),
          ]);
        }
      } else {
        await _appRouter.replaceAll([
          const AuthenticatedRoute(
            children: [
              BottomNavBarRoute(
                children: [
                  NotificationsRoute(children: [PublicNotificationsRoute()]),
                ],
              ),
            ],
          ),
        ]);
      }

      debugPrint("✅ App initialized with notification route");
    }
  }

  Future<String?> getFcmToken() async {
    final token = await firebaseMessaging.getToken();
    debugPrint("📱 Device FCM Token: $token");
    return token;
  }
}
