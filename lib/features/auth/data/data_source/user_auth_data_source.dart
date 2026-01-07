import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/login_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';

abstract class UserAuthDataSource {
  Future<String> signup({required UserSignupRequestModel userRequestModel});

  Future<ActivateAccountResponseModel> activateUserAccount({
    required String email,
    required String verificationCode,
  });

  Future<UserLoginResponseModel> userLogin({
    required LoginRequestModel loginRequestModel,
  });
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

  @override
  Future<ActivateAccountResponseModel> activateUserAccount({
    required String email,
    required String verificationCode,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.activateAccount,
      data: {"email": email, "verification_code": verificationCode},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ActivateAccountResponseModel.fromJson(response.data);
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }

  @override
  Future<UserLoginResponseModel> userLogin({
    required LoginRequestModel loginRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.userLogin,
      data: loginRequestModel.toJson(),
    );
    if (response.statusCode == 200) {
      return UserLoginResponseModel.fromJson(response.data);
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }
}
