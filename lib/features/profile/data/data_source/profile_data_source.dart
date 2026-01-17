import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';

abstract class ProfileDataSource {
  Future<String> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  });
  Future<String> changeProfileImage({required File image});
  Future<String> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  });
  Future<String> deleteAccount();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final DioHelper dioHelper;

  ProfileDataSourceImpl({required this.dioHelper});
  @override
  Future<String> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.updateProfile,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: updateUserProfileRequestModel.toJson(),
    );
    if (response.statusCode == 200) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> changeProfileImage({required File image}) async {
    final FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path),
    });
    final response = await dioHelper.post(
      url: ApiConstants.changeImage,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
    );
    if (response.statusCode == 200) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.changePassword,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: changePasswordRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> deleteAccount() async {
    final response = await dioHelper.post(
      url: ApiConstants.deleteAccount,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }
}
