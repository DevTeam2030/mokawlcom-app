import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, String>> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  });
  Future<Either<Failure, String>> changeProfileImage({
    required File image,
  });
}
