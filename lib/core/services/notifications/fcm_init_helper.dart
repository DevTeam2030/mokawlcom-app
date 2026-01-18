import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_controller.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notification_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';

class FcmInitHelper {


  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final AwesomeNotifications _awesomeNotifications = AwesomeNotifications();

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
      ),
    );
  }

  Future<void> setAwesomeNotificationListeners() async {
    await _awesomeNotifications.setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  Future<void> initFirebaseMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.data}");
      final curentRoute = AppConstants.currentRoute;
     // print("current route: >>>>>>>>>>>>>>$curentRoute");

      // if (message.data['type'] == 'public') {
      //   notificationsCubit.addPublicNotification(
      //     publicNotification: PublicNotificationModel(
      //       id: int.tryParse(message.data['id'] ?? "") ?? 0,
      //       title: message.notification?.title ?? 'No title',
      //       body: message.notification?.body ?? 'No body',
      //       date: message.data['date'] ?? "",
      //       time: message.data['time'] ?? "",
      //       status: bool.tryParse(message.data['status'] ?? "") ?? false,
      //     ),
      //   );
      // } else {
      //   notificationsCubit.addOfferNotification(
      //     offerNotification: OfferNotificationModel(
      //       id: int.tryParse(message.data['id'] ?? "") ?? 0,
      //       title: message.notification?.title ?? 'No title',
      //       message: message.notification?.body ?? 'No body',
      //       date: message.data['date'] ?? "",
      //       time: message.data['time'] ?? "",
      //       status: bool.tryParse(message.data['status'] ?? "") ?? false,
      //       isPdf: bool.tryParse(message.data['is_pdf'] ?? "") ?? false,
      //       price: num.tryParse(message.data['price'] ?? "") ?? 0,
      //       offerUserName: message.data['offer_user_name'] ?? "",
      //       url: message.data['file'] ?? "",
      //       offerId: int.tryParse(message.data['offer_id'] ?? "") ?? 0,
      //     ),
      //   );
      // }

      if (curentRoute == NotificationsRoute.name) {
        return;
      }
    //  appCubit.toggleTabs(tabIndex: 1);
  

      _showAwesomeNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("📲 Notification opened (background): ${message.data}");
      //final curentRoute = getIt<AppRouter>().current.name;
     // print("current route: >>>>>>>>>>>>>>$curentRoute");
      getIt<AppRouter>().push(
      OfferDetailsRoute(
        offerNotificationModel: OfferNotificationModel(
          id: int.tryParse(message.data['id'] ?? "") ?? 0,
          offerId: int.tryParse(message.data['offer_id'] ?? "") ?? 0,
          title: message.notification?.title ?? 'No title',
          message: message.notification?.body ?? 'No body',
          date: message.data['date'] ?? "",
          time: message.data['time'] ?? "",
          status: false,
          offerUserName: message.data['offer_user_name'] ?? "",
          price: num.tryParse(message.data['price'] ?? "") ?? 0,
          isPdf: bool.tryParse(message.data['is_pdf'] ?? "") ?? false,
          url: message.data['file'] ?? "",
        ),
      ),
    );
    // notificationsCubit.addOfferNotification(
    //   offerNotification: OfferNotificationModel(
    //     id: int.tryParse(message.data['id'] ?? "") ?? 0,
    //     offerId: int.tryParse(message.data['offer_id'] ?? "") ?? 0,
    //     title: message.notification?.title ?? 'No title',
    //     message: message.notification?.body ?? 'No body',
    //     date: message.data['date'] ?? "",
    //     time: message.data['time'] ?? "",
    //     status: false,
    //     offerUserName: message.data['offer_user_name'] ?? "",
    //     price: num.tryParse(message.data['price'] ?? "") ?? 0,
    //     isPdf: bool.tryParse(message.data['is_pdf'] ?? "") ?? false,
    //     url: message.data['file'] ?? "",
    //   ),
    // );
    });
    
  }

  Future<void> handleInitialMessage() async {
    final RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      await getIt<AppRouter>().replaceAll([
        const AuthenticatedRoute(children: [BottomNavBarRoute()]),
      ]);
      getIt<AppCubit>().toggleTabs(tabIndex: 1);
    }
  }

  Future<void> navigateToNotifications() async {
    
  }

  Future<String?> getFcmToken() async {
    final token = await firebaseMessaging.getToken();
    debugPrint("📱 Device FCM Token: $token");
    return token;
  }
}
