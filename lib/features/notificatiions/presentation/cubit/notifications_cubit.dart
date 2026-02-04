import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/services/notifications/notification_service.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
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
                NotificationType.offerNotification &&
            AppConstants.userType == UserType.contractor) {
          addOfferNotification(
            offerModel: notificationData.notification as OfferModel,
          );
        } else if (notificationData.type == NotificationType.replyOnOffer) {
          markOfferAsUnreadByOfferId(
            offerModel: notificationData.notification as OfferModel,
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
    if (state.publicNotifications.notifications.isNotEmpty) {
      return;
    }
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
        final unReadPublicNotifications = Set<int>.from(
          state.unReadPublicNotifications,
        );
        for (var notification in publicNotifications.notifications) {
          if (!notification.status) {
            unReadPublicNotifications.add(notification.id);
          }
        }
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.success,
            publicNotifications: publicNotifications,
            unReadPublicNotifications: unReadPublicNotifications,
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
        final unReadPublicNotifications = Set<int>.from(
          state.unReadPublicNotifications,
        );
        for (var notification in publicNotifications.notifications) {
          if (!notification.status) {
            unReadPublicNotifications.add(notification.id);
          }
        }
        emit(
          state.copyWith(
            getPublicNotificationsState: RequestStatus.success,
            publicNotifications: updatedPublicNotifications,
            publicNotificationsCurrentPage: publicNotifications.currentPage,
            unReadPublicNotifications: unReadPublicNotifications,
          ),
        );
      },
    );
  }

  Future<void> getOfferNotifications() async {
    if (state.offerNotifications.notifications.isNotEmpty) {
      return;
    }
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
        final unReadOfferNotifications = Set<int>.from(
          state.unReadOfferNotifications,
        );
        for (var notification in offerNotifications.notifications) {
          if (!notification.status) {
            unReadOfferNotifications.add(notification.offerId);
          }
        }
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.success,
            offerNotifications: offerNotifications,
            offerNotificationsCurrentPage: offerNotifications.currentPage,
            unReadOfferNotifications: unReadOfferNotifications,
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
        final unReadOfferNotifications = Set<int>.from(
          state.unReadOfferNotifications,
        );
        for (var notification in offerNotifications.notifications) {
          if (!notification.status) {
            unReadOfferNotifications.add(notification.offerId);
          }
        }
        emit(
          state.copyWith(
            getOfferNotificationsState: RequestStatus.success,
            offerNotifications: updatedOfferNotifications,
            offerNotificationsCurrentPage: offerNotifications.currentPage,
            unReadOfferNotifications: unReadOfferNotifications,
          ),
        );
      },
    );
  }

  void markPublicNotificationAsRead({required int notificationId}) {
    final unReadPublicNotifications = Set<int>.from(
      state.unReadPublicNotifications,
    );
    unReadPublicNotifications.remove(notificationId);
    emit(state.copyWith(unReadPublicNotifications: unReadPublicNotifications));
  }

  void markOfferNotificationAsRead({required int offerId}) {
    final unReadOfferNotifications = Set<int>.from(
      state.unReadOfferNotifications,
    );
    unReadOfferNotifications.remove(offerId);
    emit(state.copyWith(unReadOfferNotifications: unReadOfferNotifications));
  }

  void addPublicNotification({
    required PublicNotificationModel publicNotification,
  }) {
    final currentList = List<PublicNotificationModel>.from(
      state.publicNotifications.notifications,
    );
    final unReadPublicNotifications = Set<int>.from(
      state.unReadPublicNotifications,
    );
    unReadPublicNotifications.add(publicNotification.id);
    emit(state.copyWith(unReadPublicNotifications: unReadPublicNotifications));

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

  void addOfferNotification({required OfferModel offerModel}) {
    final currentList = List<OfferModel>.from(
      state.offerNotifications.notifications,
    );
    final unReadOfferNotifications = Set<int>.from(
      state.unReadOfferNotifications,
    );
    unReadOfferNotifications.add(offerModel.offerId);
    emit(state.copyWith(unReadOfferNotifications: unReadOfferNotifications));
    
    if (currentList.contains(offerModel)) {
      return;
    }

    currentList.insert(0, offerModel);

    emit(
      state.copyWith(
        offerNotifications: state.offerNotifications.copyWith(
          notifications: currentList,
        ),
      ),
    );
  }

  void markOfferAsUnreadByOfferId({required OfferModel offerModel}) {
    Set<int> unReadOfferNotifications = Set<int>.from(
      state.unReadOfferNotifications,
    );
    unReadOfferNotifications.add(offerModel.offerId);
    emit(state.copyWith(unReadOfferNotifications: unReadOfferNotifications));
  }

  Future<void> getUserOffers() async {
    emit(
      state.copyWith(
        getUserOffersState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await notificationsRepo.getUserOffers(
      page: state.userOffersCurrentPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          getUserOffersErrorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) {
        final unReadOfferNotifications = Set<int>.from(
          state.unReadOfferNotifications,
        );
        for (var notification in userOffersModel.offers) {
          if (!notification.status) {
            unReadOfferNotifications.add(notification.offerId);
          }
        }
        emit(
          state.copyWith(
            getUserOffersState: RequestStatus.success,
            userOffersModel: userOffersModel,
            unReadOfferNotifications: unReadOfferNotifications,
          ),
        );
      },
    );
  }

  Future<void> loadMoreUserOffers() async {
    if (state.userOffersCurrentPage >= state.userOffersModel.totalPages ||
        state.getUserOffersState.isLoadingMore) {
      return;
    }
    emit(state.copyWith(getUserOffersState: RequestStatus.loadingMore));
    final result = await notificationsRepo.getUserOffers(
      page: state.userOffersCurrentPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          getUserOffersErrorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) {
        final unReadOfferNotifications = Set<int>.from(
          state.unReadOfferNotifications,
        );
        for (var notification in userOffersModel.offers) {
          if (!notification.status) {
            unReadOfferNotifications.add(notification.offerId);
          }
        }
        emit(
          state.copyWith(
            getUserOffersState: RequestStatus.success,
            userOffersModel: userOffersModel.copyWith(
              offers: [
                ...state.userOffersModel.offers,
                ...userOffersModel.offers,
              ],
            ),
            unReadOfferNotifications: unReadOfferNotifications,
            userOffersCurrentPage: userOffersModel.currentPage,
          ),
        );
      },
    );
  }
}
