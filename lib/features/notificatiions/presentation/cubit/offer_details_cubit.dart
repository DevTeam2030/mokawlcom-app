import 'dart:io';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/offer_details_state.dart';

class OfferDetailsCubit extends Cubit<OfferDetailsState> {
  final NotificationsRepo notificationsRepo;
  OfferDetailsCubit({required this.notificationsRepo})
    : super(const OfferDetailsState());
  Future<void> getOfferDetails({required int offerId}) async {
    emit(
      state.copyWith(
        getOfferDetailsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getOfferDetails(
      page: state.offerDetailsCurrentPage,
      offerId: offerId,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getOfferDetailsState: RequestStatus.error,
            offerDetailsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (offerDetails) {
        emit(
          state.copyWith(
            getOfferDetailsState: RequestStatus.success,
            offerDetails: offerDetails,
            offerDetailsCurrentPage: offerDetails.currentPage,
          ),
        );
      },
    );
  }

  Future<void> loadMoreOfferDetails({required int offerId}) async {
    if (state.getOfferDetailsState == RequestStatus.loadingMore ||
        state.offerDetailsCurrentPage >= state.offerDetails.totalPages) {
      return;
    }
    emit(
      state.copyWith(
        getOfferDetailsState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getOfferDetails(
      page: state.offerDetailsCurrentPage + 1,
      offerId: offerId,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getOfferDetailsState: RequestStatus.error,
            offerDetailsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (offerDetails) {
        final updatedOfferDetails = state.offerDetails.copyWith(
          replies: [...state.offerDetails.replies, ...offerDetails.replies],
        );
        emit(
          state.copyWith(
            getOfferDetailsState: RequestStatus.success,
            offerDetails: updatedOfferDetails,
            offerDetailsCurrentPage: offerDetails.currentPage,
          ),
        );
      },
    );
  }

  Future<void> pickFile() async {
    emit(
      state.copyWith(
        replayOnOfferPriceState: RequestStatus.initial,
        isFileLoading: true,
      ),
    );
    try {
      final File? file = await FilePickerService.pickFile();
      emit(state.copyWith(file: file, isFileLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          replayOnOfferPriceMessage: e.toString(),
          replayOnOfferPriceState: RequestStatus.error,
          isFileLoading: false,
        ),
      );
    }
  }

  Future<void> replyOnOfferPrice({
    required String offerId,
    required String price,
    required String title,
    required String message,
  }) async {
    if (state.replayOnOfferPriceState.isLoading) {
      return;
    }
    emit(state.copyWith(replayOnOfferPriceState: RequestStatus.loading));
    final result = await notificationsRepo.replyOnOfferPrice(
      replyOfferPriceRequestModel: ReplyOfferPriceRequestModel(
        file: state.file,
        offerId: offerId,
        price: price,
        title: title,
        message: message,
      ),
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          replayOnOfferPriceState: RequestStatus.error,
          replayOnOfferPriceMessage: failure.errorMessage,
          isConnected: failure.isConnected,
          progress: 0,
        ),
      ),
      (replyOnOfferResponseModel) {
        final updatedOfferDetails = state.offerDetails.copyWith(
          replies: [
            ...state.offerDetails.replies,
            replyOnOfferResponseModel.offerModel,
          ],
        );
        emit(
          state.copyWith(
            replayOnOfferPriceState: RequestStatus.success,
            replayOnOfferPriceMessage: replyOnOfferResponseModel.message,
            progress: 0,
            clearFile: true,
            offerDetails: updatedOfferDetails,
          ),
        );
      },
    );
  }
}
