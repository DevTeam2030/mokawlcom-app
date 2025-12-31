import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/user/data_source/user_auth_data_source.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/user/repo/user_auth_repo.dart';

class UserAuthRepoImpl implements UserAuthRepo {
  final UserAuthDataSource userAuthDataSource;

  UserAuthRepoImpl({required this.userAuthDataSource});

  @override
  Future<Either<Failure, String>> signup({
    required UserSignupRequestModel userSignupRequestModel,
  }) async =>
      safeApiCall<String>(() => userAuthDataSource.signup(userRequestModel: userSignupRequestModel));
}