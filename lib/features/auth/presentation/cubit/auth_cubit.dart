import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/complete_contractor_data_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/setting_result_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/login_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserAuthRepo userAuthRepoImpl;
  final ContractorAuthRepo contractorAuthRepoImpl;
  final CacheHelper cacheHelper;
  AuthCubit({
    required this.userAuthRepoImpl,
    required this.cacheHelper,
    required this.contractorAuthRepoImpl,
  }) : super(const AuthState());
  Future<void> userSignup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    emit(state.copyWith(userSignupState: RequestStatus.loading));
    UserSignupRequestModel userSignupRequestModel = UserSignupRequestModel(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
      fcmToken: await FcmInitHelper.getFcmToken() ?? "",
    );
    final result = await userAuthRepoImpl.signup(
      userSignupRequestModel: userSignupRequestModel,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          userSignupState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) => emit(
        state.copyWith(
          userSignupState: RequestStatus.success,
          successMessage: message,
        ),
      ),
    );
  }

  Future<void> activateAccount({
    required String email,
    required String verificationCode,
  }) async {
    emit(state.copyWith(activateAccountState: RequestStatus.loading));
    final result = await userAuthRepoImpl.activateUserAccount(
      email: email,
      verificationCode: verificationCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          activateAccountState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (activateAccountResponseModel) {
        AppConstants.token = activateAccountResponseModel.token;
        // cacheHelper.saveData(
        //   key: AppConstants.tokenKey,
        //   value: activateAccountResponseModel.token,
        // );
        emit(
          state.copyWith(
            activateAccountState: RequestStatus.success,
            activateAccountResponseModel: activateAccountResponseModel,
          ),
        );
      },
    );
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(userLoginState: RequestStatus.loading));
    final result = await userAuthRepoImpl.userLogin(
      loginRequestModel: LoginRequestModel(
        email: email,
        password: password,
        fcmToken: await FcmInitHelper.getFcmToken() ?? "",
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          userLoginState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (userLoginResponseModel) async {
        AppConstants.token = userLoginResponseModel.token;
        await cacheHelper.saveData(
          key: AppConstants.tokenKey,
          value: userLoginResponseModel.token,
        );
        emit(
          state.copyWith(
            userLoginState: RequestStatus.success,
            userLoginResponseModel: userLoginResponseModel,
          ),
        );
      },
    );
  }

  Future<void> getSettings() async {
    emit(
      state.copyWith(
        getSettingsState: RequestStatus.loading,
        isConnected: true,
      ),
    );

    final result = await contractorAuthRepoImpl.getSettings();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isConnected: failure.isConnected,
          getSettingsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (settingsResultModel) => emit(
        state.copyWith(
          getSettingsState: RequestStatus.success,
          settingsResultModel: settingsResultModel,
        ),
      ),
    );
  }

  void saveSettings({
    required int classificiationId,
    required List<int> services,
  }) => emit(
    state.copyWith(classificiationId: classificiationId, services: services),
  );

  Future<void> contractorSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    emit(state.copyWith(contractorSignUpState: RequestStatus.loading));
    final result = await contractorAuthRepoImpl.contractorSignUp(
      contractorSignUpRequestModel: ContractorSignUpRequestModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        phone: phone,
        fcmToken: await FcmInitHelper.getFcmToken() ?? "",
        classificationId: state.classificiationId,
        services: state.services,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          contractorSignUpState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            contractorSignUpState: RequestStatus.success,
            successMessage: message,
            name: name,
            phone: phone,
          ),
        );
      },
    );
  }

  Future<void> pickFile() async {
    try {
      final File? file = await FilePickerService.pickFile(image: true);
      emit(state.copyWith(logo: file));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          completeContractorDataState: RequestStatus.error,
        ),
      );
    }
  }

  void clearOldIimage() => emit(state.copyWith(clearSelectedLogo: true));
  Future<void> completeContractorData({
    required String name,
    required String phone,
    required String hintAboutComany,
    required String? whatsApp,
    required String? facebook,
    required String? twitter,
    required String? snapChat,
  }) async {
    if (state.logo == null) {
      emit(
        state.copyWith(
          completeContractorDataState: RequestStatus.error,
          errorMessage: "Please select a logo",
        ),
      );
      return;
    }
    emit(state.copyWith(completeContractorDataState: RequestStatus.loading));

    final result = await contractorAuthRepoImpl.completeContractorData(
      completeContractorDataRequestModel: CompleteContractorDataRequestModel(
        logo: state.logo!,
        name: name,
        hintAboutComany: hintAboutComany,
        phone: phone,
        whatsApp: whatsApp ?? "",
        facebook: facebook ?? "",
        twitter: twitter ?? "",
        snapChat: snapChat ?? "",
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeContractorDataState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            completeContractorDataState: RequestStatus.success,
            successMessage: message,
          ),
        );
      },
    );
  }

  Future<void> subscibePlan() async {
    emit(state.copyWith(subscibePlanState: RequestStatus.loading));
    final result = await contractorAuthRepoImpl.subscibePlan();
    result.fold(
      (failure) => emit(
        state.copyWith(
          subscibePlanState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            subscibePlanState: RequestStatus.success,
            successMessage: message,
          ),
        );
      },
    );
  }

  Future<void> forgetPassword({required String email}) async {
    emit(state.copyWith(forgetPasswordState: RequestStatus.loading));
    final result = await userAuthRepoImpl.forgetPassword(email: email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          forgetPasswordState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            forgetPasswordState: RequestStatus.success,
            successMessage: message,
          ),
        );
      },
    );
  }
}
