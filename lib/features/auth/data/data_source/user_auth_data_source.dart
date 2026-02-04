import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/google_signin_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/login_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/apple_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_apple_login_model.dart';
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

  Future<UserLoginResponseModel> googleLogin({
    required GoogleSignInRequestModel googleSignInRequestModel,
  });

  Future<UserLoginResponseModel> appleLogin({
    required AppleRequestModel appleRequestModel,
  });

  Future<String> forgetPassword({required String email});
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

  @override
  Future<UserLoginResponseModel> googleLogin({
    required GoogleSignInRequestModel googleSignInRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.userLoginGoogle,
      data: googleSignInRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserLoginResponseModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }

  @override
  Future<UserLoginResponseModel> appleLogin({
    required AppleRequestModel appleRequestModel,
  }) async {
    final response = await dioHelper.post(
      url: ApiConstants.userLoginApple,
      data: appleRequestModel.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserLoginResponseModel.fromJson(response.data ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }

  @override
  Future<String> forgetPassword({required String email}) async {
    final response = await dioHelper.post(
      url: ApiConstants.forgetPassword,
      data: {"email": email},
    );
    if (response.statusCode == 200) {
      return response.data["message"];
    } else {
      throw ServerException(errorMessage: response.data["message"]);
    }
  }
}
