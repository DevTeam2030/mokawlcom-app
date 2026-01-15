import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';

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
}
