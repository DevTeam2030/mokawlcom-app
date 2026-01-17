import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/profile/data/data_source/profile_data_source.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileDataSource profileDataSource;

  ProfileRepoImpl({required this.profileDataSource});

  @override
  Future<Either<Failure, String>> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  }) async => safeApiCall<String>(
    () => profileDataSource.updateProfile(
      updateUserProfileRequestModel: updateUserProfileRequestModel,
    ),
  );

  @override
  Future<Either<Failure, String>> changeProfileImage({
    required File image,
  }) async => safeApiCall<String>(
    () => profileDataSource.changeProfileImage(image: image),
  );

  @override
  Future<Either<Failure, String>> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async => safeApiCall<String>(
    () => profileDataSource.changePassword(
      changePasswordRequestModel: changePasswordRequestModel,
    ),
  );

  @override
  Future<Either<Failure, String>> deleteAccount() async => safeApiCall<String>(
    () => profileDataSource.deleteAccount(),
  );
}
