import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/shared/data/models/app_version_model.dart';
import 'package:mokawlcom_app/features/shared/data/repo/app_repo.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/visitor_access_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppCubit extends HydratedCubit<AppState> {
  final UserAuthRepo userAuthRepo;
  final AppRepo appRepo;

  AppCubit({required this.userAuthRepo, required this.appRepo})
      : super(const AppState()) {
    _userTypeSubscription = userAuthRepo.userTypeStream.listen((UserType userType) {
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
    final settings = await FirebaseMessaging.instance.requestPermission();
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  void changeClassification({required String classification}) {
    emit(state.copyWith(classification: classification));
  }

  Future<PlatformVersionModel?> checkAppVersion() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return null;
    }

    final result = await appRepo.getAppVersion();
    return await result.fold(
      (failure) async => null,
      (versionData) async {
        final PlatformVersionModel platformData =
            Platform.isAndroid ? versionData.android : versionData.ios;
        if (platformData.maintainanceMode) {
          return platformData;
        }

        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;
        final requiresMandatoryUpdate =
            _isVersionLower(currentVersion, platformData.minVersion) &&
                platformData.forceUpdate;
        final requiresOptionalUpdate =
            _isVersionLower(currentVersion, platformData.latestVersion);

        if (!requiresMandatoryUpdate && !requiresOptionalUpdate) {
          return null;
        }

        return platformData;
      },
    );
  }

  bool _isVersionLower(String currentVersion, String requiredVersion) {
    final currentParts = currentVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final requiredParts = requiredVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    final length = currentParts.length > requiredParts.length
        ? currentParts.length
        : requiredParts.length;

    for (int i = 0; i < length; i++) {
      final current = i < currentParts.length ? currentParts[i] : 0;
      final required = i < requiredParts.length ? requiredParts[i] : 0;

      if (current < required) return true;
      if (current > required) return false;
    }

    return false;
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      userType: _userTypeFromString(json['user_type'] as String? ?? 'visitor'),
      isArabic: json['is_arabic'] as bool? ?? true,
      classification: json['classification'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'user_type': _userTypeToString(state.userType),
      'is_arabic': state.isArabic,
      'classification': state.classification,
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
