import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/services/google_sign_in_service.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/models/google_signin_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/login_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';

class UserAuthRepoImpl implements UserAuthRepo {
  final UserAuthDataSource userAuthDataSource;

  UserAuthRepoImpl({required this.userAuthDataSource});

  @override
  Future<Either<Failure, String>> signup({
    required UserSignupRequestModel userSignupRequestModel,
  }) async => safeApiCall<String>(
    () => userAuthDataSource.signup(userRequestModel: userSignupRequestModel),
  );

  @override
  Future<Either<Failure, ActivateAccountResponseModel>> activateUserAccount({
    required String email,
    required String verificationCode,
  }) async => safeApiCall<ActivateAccountResponseModel>(
    () => userAuthDataSource.activateUserAccount(
      email: email,
      verificationCode: verificationCode,
    ),
  );

  final _userTypeController = StreamController<UserType>.broadcast();

  @override
  Stream<UserType> get userTypeStream => _userTypeController.stream;

  @override
  Future<Either<Failure, UserLoginResponseModel>> userLogin({
    required LoginRequestModel loginRequestModel,
  }) async {
    final result = await safeApiCall<UserLoginResponseModel>(
      () => userAuthDataSource.userLogin(loginRequestModel: loginRequestModel),
    );
    result.fold((l) {}, (userLoginResponseModel) {
      if (userLoginResponseModel.type == "normal") {
        _userTypeController.add(UserType.user);
      } else {
        _userTypeController.add(UserType.contractor);
      }
    });
    return result;
  }

  @override
  Future<Either<Failure, UserLoginResponseModel>> googleLogin() async {
    final result = await safeApiCall<UserLoginResponseModel>(() async {
      final idToken = await GoogleSignInService.instance.signIn();

      GoogleSignInRequestModel googleSignInRequestModel =
          GoogleSignInRequestModel(
            idToken: idToken!,
            fcmToken: await FcmInitHelper().getFcmToken() ?? "",
          );
      return userAuthDataSource.googleLogin(
        googleSignInRequestModel: googleSignInRequestModel,
      );
    });
    result.fold((l) {}, (userLoginResponseModel) {
      _userTypeController.add(UserType.user);
    });
    return result;
  }

  @override
  Future<Either<Failure, String>> forgetPassword({
    required String email,
  }) async => safeApiCall<String>(
    () => userAuthDataSource.forgetPassword(email: email),
  );
}
