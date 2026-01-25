import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/public_notifications_item.dart';

class NotificationsState extends Equatable {
  final RequestStatus getPublicNotificationsState;
  final PublicNotificationsModel publicNotifications;
  final String publicNotificationsErrorMessage;
  final int publicNotificationsCurrentPage;
  final RequestStatus getOfferNotificationsState;
  final OfferNotificationsModel offerNotifications;
  final String offerNotificationsErrorMessage;
  final int offerNotificationsCurrentPage;
  final Set<int> publicNotificationsReadStatus;
  final Set<int> offerNotificationsReadStatus;
  final bool isConnected;

  const NotificationsState({
    this.getPublicNotificationsState = RequestStatus.initial,
    this.publicNotifications = const PublicNotificationsModel.empty(),
    this.publicNotificationsErrorMessage = "",
    this.publicNotificationsCurrentPage = 1,
    this.getOfferNotificationsState = RequestStatus.initial,
    this.offerNotifications = const OfferNotificationsModel.empty(),
    this.offerNotificationsErrorMessage = "",
    this.offerNotificationsCurrentPage = 1,
    this.publicNotificationsReadStatus = const {},
    this.offerNotificationsReadStatus = const {},
    this.isConnected = true,
  });

  NotificationsState copyWith({
    RequestStatus? getPublicNotificationsState,
    PublicNotificationsModel? publicNotifications,
    String? publicNotificationsErrorMessage,
    int? publicNotificationsCurrentPage,
    RequestStatus? getOfferNotificationsState,
    OfferNotificationsModel? offerNotifications,
    String? offerNotificationsErrorMessage,
    int? offerNotificationsCurrentPage,
    Set<int>? publicNotificationsReadStatus,
    Set<int>? offerNotificationsReadStatus,
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
      getOfferNotificationsState:
          getOfferNotificationsState ?? this.getOfferNotificationsState,
      offerNotifications: offerNotifications ?? this.offerNotifications,
      offerNotificationsErrorMessage:
          offerNotificationsErrorMessage ?? this.offerNotificationsErrorMessage,
      offerNotificationsCurrentPage:
          offerNotificationsCurrentPage ?? this.offerNotificationsCurrentPage,
      publicNotificationsReadStatus:
          publicNotificationsReadStatus ?? this.publicNotificationsReadStatus,
      offerNotificationsReadStatus:
          offerNotificationsReadStatus ?? this.offerNotificationsReadStatus,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    getPublicNotificationsState,
    publicNotifications,
    publicNotificationsErrorMessage,
    publicNotificationsCurrentPage,
    getOfferNotificationsState,
    offerNotifications,
    offerNotificationsErrorMessage,
    offerNotificationsCurrentPage,
    publicNotificationsReadStatus,
    offerNotificationsReadStatus,
    isConnected,
  ];
}
