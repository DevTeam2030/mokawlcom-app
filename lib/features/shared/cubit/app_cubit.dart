import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  final UserAuthRepo userAuthRepo;
  AppCubit({required this.userAuthRepo}) : super(const AppState()) {
    _userTypeSubscription = userAuthRepo.userTypeStream.listen((userType) {
      changeUserType(userType: userType);
    });
  }

  late final StreamSubscription<UserType> _userTypeSubscription;

  changeUserType({required UserType userType}) {
    emit(state.copyWith(userType: userType));
  }

  changeLanguage({required bool isArabic}) {
    emit(state.copyWith(isArabic: isArabic));
  }

  @override
  Future<void> close() {
    _userTypeSubscription.cancel();
    return super.close();
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState(
      userType: _userTypeFromString(
        (json['user_type'] as String?) ?? "visitor",
      ),
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
}
