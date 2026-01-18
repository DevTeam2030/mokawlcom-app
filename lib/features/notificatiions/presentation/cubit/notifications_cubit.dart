import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/public_notifications_item.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  NotificationsCubit({required this.notificationsRepo})
    : super(const NotificationsState());
  Future<void> getPublicNotifications() async {
    emit(
      state.copyWith(
        getPublicNotificationsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getPublicNotifications(
      page: state.publicNotificationsCurrentPage,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.error,
            publicNotificationsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (publicNotifications) {
        final updatedPublicNotificationsReadStatus = Map<int, bool>.from(
          state.publicNotificationsReadStatus,
        );
        for (var notification in publicNotifications.notifications) {
          updatedPublicNotificationsReadStatus[notification.id] =
              notification.status;
        }
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.success,
            publicNotifications: publicNotifications,
            publicNotificationsReadStatus: updatedPublicNotificationsReadStatus,
          ),
        );
      },
    );
  }

  Future<void> loadMorePublicNotifications() async {
    if (state.getPublicNotificationsState == RequestStatus.loadingMore ||
        state.publicNotificationsCurrentPage >=
            state.publicNotifications.totalPages) {
      return;
    }
    emit(
      state.copyWith(
        getPublicNotificationsState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getPublicNotifications(
      page: state.publicNotificationsCurrentPage + 1,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.error,
            publicNotificationsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (publicNotifications) {
        final updatedPublicNotifications = state.publicNotifications.copyWith(
          notifications: [
            ...state.publicNotifications.notifications,
            ...publicNotifications.notifications,
          ],
        );
        final updatedPublicNotificationsReadStatus = Map<int, bool>.from(
          state.publicNotificationsReadStatus,
        );
        for (var notification in publicNotifications.notifications) {
          updatedPublicNotificationsReadStatus[notification.id] =
              notification.status;
        }
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.success,
            publicNotifications: updatedPublicNotifications,
            publicNotificationsCurrentPage: publicNotifications.currentPage,
            publicNotificationsReadStatus: updatedPublicNotificationsReadStatus,
          ),
        );
      },
    );
  }

  Future<void> getOfferNotifications() async {
    emit(
      state.copyWith(
        getOfferNotificationsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getOfferNotifications(
      page: state.offerNotificationsCurrentPage,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.error,
            offerNotificationsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (offerNotifications) {
        final updatedOfferNotificationsReadStatus = Map<int, bool>.from(
          state.offerNotificationsReadStatus,
        );
        for (var notification in offerNotifications.notifications) {
          updatedOfferNotificationsReadStatus[notification.id] =
              notification.status;
        }
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.success,
            offerNotifications: offerNotifications,
            offerNotificationsCurrentPage: offerNotifications.currentPage,
            offerNotificationsReadStatus: updatedOfferNotificationsReadStatus,
          ),
        );
      },
    );
  }

  Future<void> loadMoreOfferNotifications() async {
    if (state.getOfferNotificationsState.isLoadingMore ||
        state.offerNotificationsCurrentPage >=
            state.offerNotifications.totalPages) {
      return;
    }
    emit(
      state.copyWith(
        getOfferNotificationsState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getOfferNotifications(
      page: state.offerNotificationsCurrentPage + 1,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.error,
            offerNotificationsErrorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (offerNotifications) {
        final updatedOfferNotifications = state.offerNotifications.copyWith(
          notifications: [
            ...state.offerNotifications.notifications,
            ...offerNotifications.notifications,
          ],
        );
        final updatedOfferNotificationsReadStatus = Map<int, bool>.from(
          state.offerNotificationsReadStatus,
        );
        for (var notification in offerNotifications.notifications) {
          updatedOfferNotificationsReadStatus[notification.id] =
              notification.status;
        }
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.success,
            offerNotifications: updatedOfferNotifications,
            offerNotificationsCurrentPage: offerNotifications.currentPage,
            offerNotificationsReadStatus: updatedOfferNotificationsReadStatus,
          ),
        );
      },
    );
  }

  void markPublicNotificationAsRead({required int notificationId}) {
    if (state.publicNotificationsReadStatus.containsKey(notificationId)) {
      return;
    }
    final updatedReadStatus = Map<int, bool>.from(
      state.publicNotificationsReadStatus,
    );
    updatedReadStatus[notificationId] = true;
    emit(state.copyWith(publicNotificationsReadStatus: updatedReadStatus));
  }

  void markOfferNotificationAsRead({required int notificationId}) {
    if (state.offerNotificationsReadStatus.containsKey(notificationId)) {
      return;
    }
    final updatedReadStatus = Map<int, bool>.from(
      state.offerNotificationsReadStatus,
    );
    updatedReadStatus[notificationId] = true;
    emit(state.copyWith(offerNotificationsReadStatus: updatedReadStatus));
  }

  Future<void> getOfferDetails({required int offerId}) async {
    emit(
      state.copyWith(
        getOfferDetailsState: RequestStatus.loading,
        offerDetails: const OfferDetailsModel.empty(),
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

  void addPublicNotification({
    required PublicNotificationModel publicNotification,
  }) {
    final currentList = List<PublicNotificationModel>.from(
      state.publicNotifications.notifications,
    );

    final exists = currentList.any((e) => e.id == publicNotification.id);

    if (exists) return;

    currentList.insert(0, publicNotification);

    emit(
      state.copyWith(
        publicNotifications: state.publicNotifications.copyWith(
          notifications: currentList,
        ),
      ),
    );
  }

  void addOfferNotification({required OfferModel offerNotification}) {
    final currentList = List<OfferModel>.from(
      state.offerNotifications.notifications,
    );

    final exists = currentList.any((e) => e.id == offerNotification.id);

    if (exists) return;

    currentList.insert(0, offerNotification);

    emit(
      state.copyWith(
        offerNotifications: state.offerNotifications.copyWith(
          notifications: currentList,
        ),
      ),
    );
  }
}
