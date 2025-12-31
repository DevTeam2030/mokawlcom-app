import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';

abstract class UserAuthDataSource {
  Future<String> signup({required UserSignupRequestModel userRequestModel});
}

class UserAuthDataSourceImpl implements UserAuthDataSource {
  final DioHelper dioHelper;

  UserAuthDataSourceImpl({required this.dioHelper});
  @override
  Future<String> signup({
    required UserSignupRequestModel userRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.userSignup,
      data: userRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["message"];
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }
}
