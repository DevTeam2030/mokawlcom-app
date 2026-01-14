import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notification_model.dart';

class OfferNotificationsModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final List<OfferNotificationModel> notifications;

  const OfferNotificationsModel({
    required this.currentPage,
    required this.totalPages,
    required this.notifications,
  });

  factory OfferNotificationsModel.fromJson(Map<String, dynamic> json) {
    return OfferNotificationsModel(
      currentPage: json["current_page"] ?? 0,
      totalPages: json["total_pages"] ?? 0,
      notifications: List<OfferNotificationModel>.from(
        (json["notifications"] as List? ?? []).map(
          (x) => OfferNotificationModel.fromJson(x),
        ),
      ),
    );
  }
  const OfferNotificationsModel.empty()
    : this(currentPage: 0, totalPages: 0, notifications: const []);
  OfferNotificationsModel copyWith({
    List<OfferNotificationModel>? notifications,
  }) {
    return OfferNotificationsModel(
      currentPage: currentPage,
      totalPages: totalPages,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [currentPage, totalPages, notifications];
}
