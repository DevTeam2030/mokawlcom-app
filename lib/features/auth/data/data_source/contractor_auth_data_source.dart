import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';

abstract class ContractorAuthDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<String> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
  });
  Future<String> uploadCommercialRegistry({
    required UploadFileModel fileModel,
    required void Function(double progress) onProgress,
  });
}

class ContractorAuthDataSourceImpl implements ContractorAuthDataSource {
  final DioHelper dioHelper;

  ContractorAuthDataSourceImpl({required this.dioHelper});
  @override
  Future<Map<String, dynamic>> getSettings() async {
    final response = await dioHelper.get(url: ApiConstants.getSettings);
    if (response.statusCode == 200) {
      return response.data;
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
      headers: {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer ${AppConstants.token}",
      },
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
}
