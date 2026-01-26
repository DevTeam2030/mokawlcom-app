import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/visitor_access_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class AppCubit extends HydratedCubit<AppState> {
  final UserAuthRepo userAuthRepo;

  AppCubit({required this.userAuthRepo}) : super(const AppState()) {
    _userTypeSubscription = userAuthRepo.userTypeStream.listen((userType) {
      changeUserType(userType: userType);
    });
  }

  late final StreamSubscription<UserType> _userTypeSubscription;

  void changeUserType({required UserType userType}) {
    AppConstants.userType = userType;
    emit(state.copyWith(userType: userType));
  }

  void changeLanguage({required bool isArabic}) {
    emit(state.copyWith(isArabic: isArabic));
  }

  void handleProtectedNavigation({
    required BuildContext context,
    required VoidCallback onAllowed,
  }) {
    if (state.userType == UserType.visitor) {
      showDialog(context: context, builder: (_) => const VisitorAccessDialog());
      return;
    }

    onAllowed();
  }

 

  Future<void> checkNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {
      // debugPrint("Notification permission permanently denied.");
      // openAppSettings();
      emit(state.copyWith(areNotificationsEnabled: false));
      return;
    }

    bool granted = status.isGranted;
    debugPrint("Permission granted: $granted");
    emit(state.copyWith(areNotificationsEnabled: granted));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      userType: _userTypeFromString(json['user_type'] as String?),
      isArabic: json['is_arabic'] as bool? ?? true,
      areNotificationsEnabled:
          json['are_notifications_enabled'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'user_type': _userTypeToString(state.userType),
      'is_arabic': state.isArabic,
      'are_notifications_enabled': state.areNotificationsEnabled,
    };
  }

  String _userTypeToString(UserType userType) => userType.name;

  UserType _userTypeFromString(String? value) {
    switch (value) {
      case 'user':
        return UserType.user;
      case 'contractor':
        return UserType.contractor;
      case 'visitor':
      default:
        return UserType.visitor;
    }
  }

  @override
  Future<void> close() {
    _userTypeSubscription.cancel();
    return super.close();
  }
}
