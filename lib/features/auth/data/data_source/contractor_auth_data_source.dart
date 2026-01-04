import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';

abstract class ContractorAuthDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<String> contractorSignUp({
    required ContractorSignUpRequestModel contractorSignUpRequestModel,
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
}
