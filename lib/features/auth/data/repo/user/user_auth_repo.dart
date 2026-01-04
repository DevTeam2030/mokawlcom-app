import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';

abstract class UserAuthRepo {
  Future<Either<Failure, String>> signup({
    required UserSignupRequestModel userSignupRequestModel,
  });
  Future<Either<Failure, ActivateAccountResponseModel>> activateUserAccount({
    required String email,
    required String verificationCode,
  });
  Future<Either<Failure, UserLoginResponseModel>> userLogin({
    required String email,
    required String password,
  });

  Stream<UserType> get userTypeStream;
}
