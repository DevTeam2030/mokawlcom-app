import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';

enum NotificationType { publicNotification, offerNotification, replyOnOffer }

class NotificationData {
  final NotificationType type;
  final dynamic notification;
  final RemoteMessage? originalMessage;

  NotificationData({
    required this.type,
    required this.notification,
    this.originalMessage,
  });

  factory NotificationData.fromRemoteMessage(RemoteMessage message) {
    final notificationType = message.data['type'] == 'public'
        ? NotificationType.publicNotification
        : message.data['type'] == 'offer'
        ? NotificationType.offerNotification
        : NotificationType.replyOnOffer;

    if (notificationType == NotificationType.publicNotification) {
      return NotificationData(
        type: NotificationType.publicNotification,
        notification: PublicNotificationModel(
          id: int.tryParse(message.data['id'] ?? "") ?? 0,
          title: message.notification?.title ?? 'No title',
          body: message.notification?.body ?? 'No body',
          date: message.data['date'] ?? "",
          time: message.data['time'] ?? "",
          status: bool.tryParse(message.data['status'] ?? "") ?? false,
        ),
        originalMessage: message,
      );
    } else {
      return NotificationData(
        type: NotificationType.offerNotification,
        notification: OfferModel(
          id: int.tryParse(message.data['id'] ?? "") ?? 0,
          title: message.notification?.title ?? 'No title',
          message: message.notification?.body ?? 'No body',
          date: message.data['date'] ?? "",
          time: message.data['time'] ?? "",
          status: bool.tryParse(message.data['status'] ?? "") ?? false,
          isPdf: bool.tryParse(message.data['is_pdf'] ?? "") ?? false,
          price: num.tryParse(message.data['price'] ?? "") ?? 0,
          offerUserName: message.data['offer_user_name'] ?? "",
          url: message.data['file'] ?? "",
          offerId: int.tryParse(message.data['offer_id'] ?? "") ?? 0,
        ),
        originalMessage: message,
      );
    }
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final StreamController<NotificationData> _notificationController =
      StreamController<NotificationData>.broadcast();

  Stream<NotificationData> get notificationStream =>
      _notificationController.stream;

  void addNotification(NotificationData notification) {
    if (!_notificationController.isClosed) {
      _notificationController.add(notification);
    }
  }

  void dispose() {
    _notificationController.close();
  }
}
