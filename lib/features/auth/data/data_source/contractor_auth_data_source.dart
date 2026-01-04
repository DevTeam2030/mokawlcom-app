import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';

abstract class ContractorAuthDataSource {
  Future<Map<String, dynamic>> getSettings();
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
}
