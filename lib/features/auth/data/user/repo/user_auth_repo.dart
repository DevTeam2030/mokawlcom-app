import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';

abstract class UserAuthRepo {
  Future<Either<Failure,String>> signup({required UserSignupRequestModel userSignupRequestModel});
}