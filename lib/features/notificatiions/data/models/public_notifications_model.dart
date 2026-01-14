import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';

class PublicNotificationsModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final List<PublicNotificationModel> notifications;

  const PublicNotificationsModel({
    required this.currentPage,
    required this.totalPages,
    required this.notifications,
  });

  factory PublicNotificationsModel.fromJson(Map<String, dynamic> json) =>
      PublicNotificationsModel(
        currentPage: json["current_page"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
        notifications: List<PublicNotificationModel>.from(
          (json["notifications"] as List? ?? []).map(
            (x) => PublicNotificationModel.fromJson(x),
          ),
        ),
      );
  const PublicNotificationsModel.empty()
    : this(currentPage: 0, totalPages: 0, notifications: const []);

  PublicNotificationsModel copyWith({
    List<PublicNotificationModel>? notifications,
  }) {
    return PublicNotificationsModel(
      currentPage: currentPage,
      totalPages: totalPages,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [currentPage, totalPages, notifications];
}
