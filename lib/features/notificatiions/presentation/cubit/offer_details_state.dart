import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';

class OfferDetailsState extends Equatable {
  final RequestStatus getOfferDetailsState;
  final OfferDetailsModel offerDetails;
  final String offerDetailsErrorMessage;
  final int offerDetailsCurrentPage;
  final String replayOnOfferPriceMessage;
  final bool isFileLoading;
  final double progress;
  final RequestStatus replayOnOfferPriceState;
  final bool isConnected;

  final File? file;

  const OfferDetailsState({
    this.getOfferDetailsState = RequestStatus.initial,
    this.offerDetails = const OfferDetailsModel.empty(),
    this.offerDetailsErrorMessage = "",
    this.offerDetailsCurrentPage = 1,
    this.replayOnOfferPriceMessage = "",
    this.isFileLoading = false,
    this.progress = 0,
    this.replayOnOfferPriceState = RequestStatus.initial,
    this.isConnected = true,
    this.file,
  });

  OfferDetailsState copyWith({
    OfferDetailsModel? offerDetails,
    String? offerDetailsErrorMessage,
    int? offerDetailsCurrentPage,
    String? replayOnOfferPriceMessage,
    bool? isFileLoading,
    double? progress,
    RequestStatus? replayOnOfferPriceState,
    RequestStatus? getOfferDetailsState,
    bool? isConnected,
    File? file,
    bool clearFile = false,
  }) {
    return OfferDetailsState(
      getOfferDetailsState: getOfferDetailsState ?? this.getOfferDetailsState,
      offerDetails: offerDetails ?? this.offerDetails,
      offerDetailsErrorMessage:
          offerDetailsErrorMessage ?? this.offerDetailsErrorMessage,
      offerDetailsCurrentPage:
          offerDetailsCurrentPage ?? this.offerDetailsCurrentPage,
      replayOnOfferPriceMessage:
          replayOnOfferPriceMessage ?? this.replayOnOfferPriceMessage,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      progress: progress ?? this.progress,
      replayOnOfferPriceState:
          replayOnOfferPriceState ?? this.replayOnOfferPriceState,
      isConnected: isConnected ?? this.isConnected,
      file: clearFile ? null : file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [
    getOfferDetailsState,
    offerDetails,
    offerDetailsErrorMessage,
    offerDetailsCurrentPage,
    replayOnOfferPriceMessage,
    isFileLoading,
    progress,
    replayOnOfferPriceState,
    isConnected,
    file,
  ];
}
