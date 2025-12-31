import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/user_auth_cubit.dart/user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final UserAuthRepo userAuthRepoImpl;
  UserAuthCubit({required this.userAuthRepoImpl})
    : super(const UserAuthState());
  Future<void> userSignup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    emit(state.copyWith(userSignupState: RequestStatus.loading));
    UserSignupRequestModel userSignupRequestModel = UserSignupRequestModel(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
      fcmToken: await FcmInitHelper.getFcmToken()??"",
    );
    final result = await userAuthRepoImpl.signup(
      userSignupRequestModel: userSignupRequestModel,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          userSignupState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) => emit(
        state.copyWith(
          userSignupState: RequestStatus.success,
          message: message,
        ),
      ),
    );
  }
}
