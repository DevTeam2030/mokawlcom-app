import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/visitor_access_dialog.dart';

class AppCubit extends HydratedCubit<AppState> {
  final UserAuthRepo userAuthRepo;

  AppCubit({required this.userAuthRepo}) : super(const AppState()) {
    _userTypeSubscription = userAuthRepo.userTypeStream.listen(
      (userType) {
        changeUserType(userType: userType);
      },
    );
  }

  late final StreamSubscription<UserType> _userTypeSubscription;


  bool get isVisitor => state.userType == UserType.visitor;
  bool get isUser => state.userType == UserType.user;
  bool get isContractor => state.userType == UserType.contractor;

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
    if (isVisitor) {
      showDialog(
        context: context,
        builder: (_) => const VisitorAccessDialog(),
      );
      return;
    }

    onAllowed();
  }


  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      userType: _userTypeFromString(json['user_type'] as String?),
      isArabic: json['is_arabic'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return {
      'user_type': _userTypeToString(state.userType),
      'is_arabic': state.isArabic,
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
