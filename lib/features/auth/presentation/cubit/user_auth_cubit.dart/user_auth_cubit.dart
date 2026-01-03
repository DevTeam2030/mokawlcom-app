import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/user_auth_cubit.dart/user_auth_state.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  final UserAuthRepo userAuthRepoImpl;
  final CacheHelper cacheHelper;
  UserAuthCubit({required this.userAuthRepoImpl, required this.cacheHelper})
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
      fcmToken: await FcmInitHelper.getFcmToken() ?? "",
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

  Future<void> activateUserAccount({
    required String email,
    required String verificationCode,
  }) async {
    emit(state.copyWith(activateUserAccountState: RequestStatus.loading));
    final result = await userAuthRepoImpl.activateUserAccount(
      email: email,
      verificationCode: verificationCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          activateUserAccountState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (activateAccountResponseModel) {
        cacheHelper.saveData(
          key: AppConstants.tokenKey,
          value: activateAccountResponseModel.token,
        );
        emit(
          state.copyWith(
            activateUserAccountState: RequestStatus.success,
            activateAccountResponseModel: activateAccountResponseModel,
          ),
        );
      },
    );
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(userLoginState: RequestStatus.loading));
    final result = await userAuthRepoImpl.userLogin(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          userLoginState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (userLoginResponseModel) async {
        await cacheHelper.saveData(
          key: AppConstants.tokenKey,
          value: userLoginResponseModel.token,
        );
        emit(
          state.copyWith(
            userLoginState: RequestStatus.success,
            userLoginResponseModel: userLoginResponseModel,
          ),
        );
      },
    );
  }
}
