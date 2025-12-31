import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/shared/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/user/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';

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
  }) async {
    final result = await safeApiCall<ActivateAccountResponseModel>(
      () => userAuthDataSource.activateUserAccount(
        email: email,
        verificationCode: verificationCode,
      ),
    );
    result.fold((l) {}, (r) {
      if (r.type == "normal") {
        _userTypeController.add(UserType.user);
      } else {
        _userTypeController.add(UserType.contractor);
      }
    });
    return result;
  }

  final _userTypeController = StreamController<UserType>.broadcast();

  @override
  Stream<UserType> get userTypeStream => _userTypeController.stream;
}
