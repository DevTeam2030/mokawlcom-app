import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/complete_contractor_data_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

abstract class ContractorAuthDataSource {
  Future<ClassificationsModel> getClassifications({
    required int page,
  });
  Future<ServicesModel> getServices({
    required int page,
  });
  Future<String> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
  });
  Future<String> uploadCommercialRegistry({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<String> uploadTradeLicense({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<String> uploadEstablishmentCertificate({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<String> uploadAuthorizedSignature({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
  Future<String> completeContractorData({
    required CompleteContractorDataRequestModel
    completeContractorDataRequestModel,
  });
  Future<String> subscibePlan();
}

class ContractorAuthDataSourceImpl implements ContractorAuthDataSource {
  final DioHelper dioHelper;

  ContractorAuthDataSourceImpl({required this.dioHelper});
  @override
  Future<ClassificationsModel> getClassifications({
    required int page,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.getClassifications,
      queryParameters: {
        "page": page,
      },
    );
    if (response.statusCode == 200) {
      return ClassificationsModel.fromJson(response.data);
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }

  @override
  Future<ServicesModel> getServices({
    required int page,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.getServices,
      queryParameters: {
        "page": page,
      },
    );
    if (response.statusCode == 200) {
      return ServicesModel.fromJson(response.data);
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }

  @override
  Future<String> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.contractorSignup,
      data: contractorSignUpRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> uploadCommercialRegistry({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap({
      'user_id': fileModel.userId,
      'commercial_registry': fileModel.fileNumber,
      'commercial_registry_file': await MultipartFile.fromFile(
        fileModel.file.path,
      ),
      "commercial_registry_expiry_date": fileModel.expiryDate,
    });

    final response = await dioHelper.post(
      url: ApiConstants.uploadCommercialRegistry,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: (sent, total) {
        if (total != 0) {
          onProgress(sent / total);
        }
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> uploadTradeLicense({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap({
      'user_id': fileModel.userId,
      'trade_license': fileModel.fileNumber,
      'trade_license_file': await MultipartFile.fromFile(fileModel.file.path),
      "trade_license_expiry_date": fileModel.expiryDate,
    });

    final response = await dioHelper.post(
      url: ApiConstants.uploadTradeLicense,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: (sent, total) {
        if (total != 0) {
          onProgress(sent / total);
        }
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> uploadEstablishmentCertificate({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap({
      'user_id': fileModel.userId,
      'establishment_certificate': fileModel.fileNumber,
      'establishment_certificate_file': await MultipartFile.fromFile(
        fileModel.file.path,
      ),
      "establishment_certificate_expiry_date": fileModel.expiryDate,
    });

    final response = await dioHelper.post(
      url: ApiConstants.uploadEstablishmentCertificate,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: (sent, total) {
        if (total != 0) {
          onProgress(sent / total);
        }
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> uploadAuthorizedSignature({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap({
      'user_id': fileModel.userId,
      'authorized_signature': fileModel.fileNumber,
      'authorized_signature_file': await MultipartFile.fromFile(
        fileModel.file.path,
      ),
      "authorized_signature_expiry_date": fileModel.expiryDate,
    });

    final response = await dioHelper.post(
      url: ApiConstants.uploadAuthorizedSignature,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: formData,
      onSendProgress: (sent, total) {
        if (total != 0) {
          onProgress(sent / total);
        }
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> completeContractorData({
    required CompleteContractorDataRequestModel
    completeContractorDataRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.completeContractorData,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: await completeContractorDataRequestModel.toFormData(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<String> subscibePlan() async {
    final response = await dioHelper.post(
      url: ApiConstants.subscibePlan,
      query: {"plan_id": 1},
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }
}
