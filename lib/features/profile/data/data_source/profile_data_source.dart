import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/plan/plan_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/add_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/edit_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deals_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/service_response_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/settings_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/user_offers_model.dart';

abstract class ProfileDataSource {
  Future<String> updateProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  });
  Future<String> changeProfileImage({required File image});
  Future<String> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  });
  Future<String> deleteAccount();
  Future<UserModel> editContractorProfile({
    required EditContractorProfileRequestModel
    editContractorProfileRequestModel,
  });
  Future<String> logout();
  Future<UserModel> getUserProfile();
  Future<UserModel> getContractorProfile();

  Future<ContractorServicesModel> getContractorServices({required int page});
  Future<ServiceResponseModel> addService({
    required AddServiceRequestModel addServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  });
  Future<ServiceResponseModel> editService({
    required EditServiceRequestModel editServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  });
  Future<DealsModel> getDeals({required int page});

  Future<String> addDeal({required String title, required String description});
  Future<String> deleteDeal({required int dealId});

  Future<String> editDeal({
    required int dealId,
    required String title,
    required String description,
  });

  Future<PlanModel> getPlan();
  Future<String> deleteService({required int serviceId});
  Future<SettingsModel> getSettings();
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

  @override
  Future<UserModel> editContractorProfile({
    required EditContractorProfileRequestModel
    editContractorProfileRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.editContractorProfile,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: editContractorProfileRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> logout() async {
    final response = await dioHelper.post(
      url: ApiConstants.logout,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    final response = await dioHelper.get(
      url: ApiConstants.profile,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<ContractorServicesModel> getContractorServices({
    required int page,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.getContractorServices,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      query: {"page": page},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ContractorServicesModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<UserModel> getContractorProfile() async {
    final response = await dioHelper.get(
      url: ApiConstants.profile,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<ServiceResponseModel> addService({
    required AddServiceRequestModel addServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  }) async {
    final Map<String, dynamic> formDataMap = {
      ...addServiceRequestModel.toJson(),
    };

    if (addServiceRequestModel.images != null &&
        addServiceRequestModel.images!.isNotEmpty) {
      final List<MultipartFile> imageFiles = [];

      for (final image in addServiceRequestModel.images!) {
        imageFiles.add(
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        );
      }
      formDataMap['images[]'] = imageFiles;
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await dioHelper.post(
      url: ApiConstants.addService,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: onSendProgress,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ServiceResponseModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<ServiceResponseModel> editService({
    required EditServiceRequestModel editServiceRequestModel,
    required void Function(int, int)? onSendProgress,
  }) async {
    final Map<String, dynamic> formDataMap = {
      ...editServiceRequestModel.toJson(),
    };

    if (editServiceRequestModel.images != null &&
        editServiceRequestModel.images!.isNotEmpty) {
      final List<MultipartFile> imageFiles = [];

      for (final image in editServiceRequestModel.images!) {
        imageFiles.add(
          await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        );
      }
      formDataMap['images[]'] = imageFiles;
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await dioHelper.post(
      url: ApiConstants.editService,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: onSendProgress,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ServiceResponseModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<DealsModel> getDeals({required int page}) async {
    final response = await dioHelper.get(
      url: ApiConstants.getDeals,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      queryParameters: {"page": page},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return DealsModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> addDeal({
    required String title,
    required String description,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.addDeal,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: {"title": title, "description": description},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> deleteDeal({required int dealId}) async {
    final response = await dioHelper.post(
      url: ApiConstants.deleteDeal,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: {"id": dealId},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> editDeal({
    required int dealId,
    required String title,
    required String description,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.editDeal,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: {"id": dealId, "title": title, "description": description},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<PlanModel> getPlan() async {
    final response = await dioHelper.get(
      url: ApiConstants.getPlan,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return PlanModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> deleteService({required int serviceId}) async {
    final response = await dioHelper.post(
      url: ApiConstants.deleteService,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: {"service_id": serviceId},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<SettingsModel> getSettings() async {
    final response = await dioHelper.get(url: ApiConstants.getSettings);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SettingsModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }
}
