import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_service.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  final NotificationService _notificationService = NotificationService();
  StreamSubscription<NotificationData>? _notificationSubscription;

  NotificationsCubit({required this.notificationsRepo})
    : super(const NotificationsState()) {
    _subscribeToNotifications();
  }

  void _subscribeToNotifications() {
    _notificationSubscription = _notificationService.notificationStream.listen(
      (notificationData) {
        debugPrint("Received notification in cubit: ${notificationData.type}");

        if (notificationData.type == NotificationType.publicNotification) {
          addPublicNotification(
            publicNotification:
                notificationData.notification as PublicNotificationModel,
          );
        } else if (notificationData.type ==
            NotificationType.offerNotification) {
          addOfferNotification(
            offerNotification: notificationData.notification as OfferModel,
          );
        } else if (notificationData.type == NotificationType.replyOnOffer) {
          markOfferAsUnreadByOfferId(
            offerNotification: notificationData.notification as OfferModel,
          );
        }
      },
      onError: (error) {
        debugPrint("Error in notification stream: $error");
      },
    );
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }

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
        final updatedPublicNotificationsReadStatus = Set<int>.from(
          state.publicNotificationsReadStatus,
        );
        for (var notification in publicNotifications.notifications) {
          if (notification.status) {
            updatedPublicNotificationsReadStatus.add(notification.id);
          }
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
        final updatedPublicNotificationsReadStatus = Set<int>.from(
          state.publicNotificationsReadStatus,
        );
        for (var notification in publicNotifications.notifications) {
          if (notification.status) {
            updatedPublicNotificationsReadStatus.add(notification.id);
          }
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
        final updatedOfferNotificationsReadStatus = Set<int>.from(
          state.offerNotificationsReadStatus,
        );
        for (var notification in offerNotifications.notifications) {
          if (notification.status) {
            updatedOfferNotificationsReadStatus.add(notification.id);
          }
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
        final updatedOfferNotificationsReadStatus = Set<int>.from(
          state.offerNotificationsReadStatus,
        );
        for (var notification in offerNotifications.notifications) {
          if (notification.status) {
            updatedOfferNotificationsReadStatus.add(notification.id);
          }
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
    final updatedReadStatus = Set<int>.from(
      state.publicNotificationsReadStatus,
    );
    updatedReadStatus.add(notificationId);
    emit(state.copyWith(publicNotificationsReadStatus: updatedReadStatus));
  }

  void markOfferNotificationAsRead({required int notificationId}) {
    final updatedReadStatus = Set<int>.from(state.offerNotificationsReadStatus);
    updatedReadStatus.add(notificationId);
    emit(state.copyWith(offerNotificationsReadStatus: updatedReadStatus));
  }

  void addPublicNotification({
    required PublicNotificationModel publicNotification,
  }) {
    final currentList = List<PublicNotificationModel>.from(
      state.publicNotifications.notifications,
    );

    if (currentList.contains(publicNotification)) {
      return;
    }

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

    final index = currentList.indexWhere((e) => e.id == offerNotification.id);

    if (index != -1) {
      currentList[index] = currentList[index].copyWith(
        status: offerNotification.status,
      );
    } else {
      currentList.insert(0, offerNotification);
    }

    emit(
      state.copyWith(
        offerNotifications: state.offerNotifications.copyWith(
          notifications: currentList,
        ),
      ),
    );
  }

  void markOfferAsUnreadByOfferId({required OfferModel offerNotification}) {
    final currentList = List<OfferModel>.from(
      state.offerNotifications.notifications,
    );

    final index = currentList.indexWhere(
      (e) => e.offerId == offerNotification.offerId,
    );

    if (index != -1) {
      currentList[index] = currentList[index].copyWith(status: false);

      final updatedReadStatus = Set<int>.from(
        state.offerNotificationsReadStatus,
      );
      updatedReadStatus.remove(currentList[index].id);

      emit(
        state.copyWith(
          offerNotifications: state.offerNotifications.copyWith(
            notifications: currentList,
          ),
          offerNotificationsReadStatus: updatedReadStatus,
        ),
      );

      debugPrint(
        "Marked offer ${currentList[index].id} as unread due to new reply on offer ${offerNotification.offerId}",
      );
    } else {
      debugPrint(
        "Parent offer with offerId ${offerNotification.offerId} not found in current list",
      );
    }
  }
}
