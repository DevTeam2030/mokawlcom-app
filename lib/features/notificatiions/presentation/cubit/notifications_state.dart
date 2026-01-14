import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/public_notifications_item.dart';

class NotificationsState extends Equatable {
  final RequestStatus getPublicNotificationsState;
  final PublicNotificationsModel publicNotifications;
  final String publicNotificationsErrorMessage;
  final int publicNotificationsCurrentPage;
  final bool isConnected;

  const NotificationsState({
    this.getPublicNotificationsState = RequestStatus.initial,
    this.publicNotifications = const PublicNotificationsModel.empty(),
    this.publicNotificationsErrorMessage = "",
    this.publicNotificationsCurrentPage = 0,
    this.isConnected = true,
  });

  NotificationsState copyWith({
    RequestStatus? getPublicNotificationsState,
    PublicNotificationsModel? publicNotifications,
    String? publicNotificationsErrorMessage,
    int? publicNotificationsCurrentPage,
    bool? isConnected,
  }) {
    return NotificationsState(
      getPublicNotificationsState:
          getPublicNotificationsState ?? this.getPublicNotificationsState,
      publicNotifications: publicNotifications ?? this.publicNotifications,
      publicNotificationsErrorMessage:
          publicNotificationsErrorMessage ??
          this.publicNotificationsErrorMessage,
      publicNotificationsCurrentPage:
          publicNotificationsCurrentPage ?? this.publicNotificationsCurrentPage,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    getPublicNotificationsState,
    publicNotifications,
    publicNotificationsErrorMessage,
    publicNotificationsCurrentPage,
    isConnected,
  ];
}
