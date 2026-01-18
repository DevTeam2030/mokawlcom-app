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
  final RequestStatus getOfferDetailsState;
  final OfferDetailsModel offerDetails;
  final String offerDetailsErrorMessage;
  final int offerDetailsCurrentPage;
  final Map<int, bool> publicNotificationsReadStatus;
  final Map<int, bool> offerNotificationsReadStatus;
  final bool isConnected;
  final String replayOnOfferPriceMessage;
  final bool isFileLoading;
  final double progress;
  final RequestStatus replayOnOfferPriceState;

  final File? file;

  const NotificationsState({
    this.getPublicNotificationsState = RequestStatus.initial,
    this.publicNotifications = const PublicNotificationsModel.empty(),
    this.publicNotificationsErrorMessage = "",
    this.publicNotificationsCurrentPage = 1,
    this.getOfferNotificationsState = RequestStatus.initial,
    this.offerNotifications = const OfferNotificationsModel.empty(),
    this.offerNotificationsErrorMessage = "",
    this.offerNotificationsCurrentPage = 1,
    this.getOfferDetailsState = RequestStatus.initial,
    this.offerDetails = const OfferDetailsModel.empty(),
    this.offerDetailsErrorMessage = "",
    this.offerDetailsCurrentPage = 1,
    this.publicNotificationsReadStatus = const {},
    this.offerNotificationsReadStatus = const {},
    this.replayOnOfferPriceMessage = "",
    this.isFileLoading = false,
    this.progress = 0,
    this.file,
    this.replayOnOfferPriceState = RequestStatus.initial,
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
    RequestStatus? getOfferDetailsState,
    OfferDetailsModel? offerDetails,
    String? offerDetailsErrorMessage,
    int? offerDetailsCurrentPage,
    Map<int, bool>? publicNotificationsReadStatus,
    Map<int, bool>? offerNotificationsReadStatus,
    String? replayOnOfferPriceMessage,
    bool? isFileLoading,
    double? progress,
    File? file,
    bool? clearFile,
    RequestStatus? replayOnOfferPriceState,
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
      getOfferDetailsState: getOfferDetailsState ?? this.getOfferDetailsState,
      offerDetails: offerDetails ?? this.offerDetails,
      offerDetailsErrorMessage:
          offerDetailsErrorMessage ?? this.offerDetailsErrorMessage,
      offerDetailsCurrentPage:
          offerDetailsCurrentPage ?? this.offerDetailsCurrentPage,
      publicNotificationsReadStatus:
          publicNotificationsReadStatus ?? this.publicNotificationsReadStatus,
      offerNotificationsReadStatus:
          offerNotificationsReadStatus ?? this.offerNotificationsReadStatus,
      replayOnOfferPriceMessage:
          replayOnOfferPriceMessage ?? this.replayOnOfferPriceMessage,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      progress: progress ?? this.progress,
      file: clearFile == true ? null : file ?? this.file,
      replayOnOfferPriceState: replayOnOfferPriceState ?? this.replayOnOfferPriceState,
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
    getOfferDetailsState,
    offerDetails,
    offerDetailsErrorMessage,
    offerDetailsCurrentPage,
    publicNotificationsReadStatus,
    offerNotificationsReadStatus,
    replayOnOfferPriceMessage,
    isFileLoading,
    progress,
    file,
    replayOnOfferPriceState,
    isConnected,
  ];
}
