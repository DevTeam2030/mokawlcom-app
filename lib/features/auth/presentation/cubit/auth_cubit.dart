import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/pick_image_service.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/complete_contractor_data_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/contractor_sign_up_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/google_signin_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/login_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/data/repo/user/user_auth_repo.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

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
    if (state.userSignupState.isLoading) return;
    emit(state.copyWith(userSignupState: RequestStatus.loading));
    UserSignupRequestModel userSignupRequestModel = UserSignupRequestModel(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
      fcmToken: await FcmInitHelper().getFcmToken() ?? "",
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
    if (state.activateAccountState.isLoading) return;
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
    if (state.userLoginState.isLoading) return;
    emit(state.copyWith(userLoginState: RequestStatus.loading));
    final result = await userAuthRepoImpl.userLogin(
      loginRequestModel: LoginRequestModel(
        email: email,
        password: password,
        fcmToken: await FcmInitHelper().getFcmToken() ?? "",
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
        if (userLoginResponseModel.completeData &&
            userLoginResponseModel.filesUploaded &&
            userLoginResponseModel.planCompleted &&
            userLoginResponseModel.userApproved == 1) {
          await cacheHelper.saveData(
            key: AppConstants.tokenKey,
            value: userLoginResponseModel.token,
          );
        }
        emit(
          state.copyWith(
            userLoginState: RequestStatus.success,
            userLoginResponseModel: userLoginResponseModel,
            phone: userLoginResponseModel.phone,
          ),
        );
      },
    );
  }

  Future<void> googleLogin() async {
    if (state.googleLoginState.isLoading) return;
    emit(state.copyWith(googleLoginState: RequestStatus.loading));

    final result = await userAuthRepoImpl.googleLogin();
    result.fold(
      (failure) => emit(
        state.copyWith(
          googleLoginState: RequestStatus.error,
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
            googleLoginState: RequestStatus.success,
            userLoginResponseModel: userLoginResponseModel,
          ),
        );
      },
    );
  }

  Future<void> appleLogin() async {
    if (state.appleLoginState.isLoading) return;
    emit(state.copyWith(appleLoginState: RequestStatus.loading));

    final result = await userAuthRepoImpl.appleLogin();
    result.fold(
      (failure) => emit(
        state.copyWith(
          appleLoginState: RequestStatus.error,
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
            appleLoginState: RequestStatus.success,
            userLoginResponseModel: userLoginResponseModel,
          ),
        );
      },
    );
  }

  Future<void> getClassifications() async {
    emit(
      state.copyWith(
        getClassificationsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getClassifications(
      page: state.classficicationsCurrentPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.success,
          classificationsModel: classificationsModel,
          classficicationsCurrentPage: classificationsModel.currentPage,
          classficicationsTotalPages: classificationsModel.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMoreClassifications() async {
    if (state.classficicationsCurrentPage >= state.classficicationsTotalPages ||
        state.getClassificationsState.isLoading) {
      return;
    }
    emit(
      state.copyWith(
        getClassificationsState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getClassifications(
      page: state.classficicationsCurrentPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) {
        final List<ClassificationModel> updatedClassifications = [
          ...state.classificationsModel.classifications,
          ...classificationsModel.classifications,
        ];
        emit(
          state.copyWith(
            getClassificationsState: RequestStatus.success,
            classificationsModel: classificationsModel.copyWith(
              classifications: updatedClassifications,
            ),
            classficicationsCurrentPage: classificationsModel.currentPage,
            classficicationsTotalPages: classificationsModel.totalPages,
          ),
        );
      },
    );
  }

  Future<void> getServices({
    required int classificationId,
  }) async {
    emit(
      state.copyWith(
        getServicesState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getServices(
      page: state.servicesCurrentPage,
      classificationId: classificationId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getServicesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (servicesModel) => emit(
        state.copyWith(
          getServicesState: RequestStatus.success,
          servicesModel: servicesModel,
          servicesCurrentPage: servicesModel.currentPage,
          servicesTotalPages: servicesModel.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMoreServices({
    required int classificationId,
  }) async {
    if (state.servicesCurrentPage >= state.servicesTotalPages ||
        state.getServicesState.isLoading) {
      return;
    }
    emit(
      state.copyWith(
        getServicesState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getServices(
      page: state.servicesCurrentPage + 1,
      classificationId: classificationId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getServicesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (servicesModel) {
        final List<ServiceModel> updatedServices = [
          ...state.servicesModel.services,
          ...servicesModel.services,
        ];
        emit(
          state.copyWith(
            getServicesState: RequestStatus.success,
            servicesModel: servicesModel.copyWith(services: updatedServices),
            servicesCurrentPage: servicesModel.currentPage,
            servicesTotalPages: servicesModel.totalPages,
          ),
        );
      },
    );
  }

  void saveSettings({
    required int classificiationId,
    required List<int> servicesIds,
  }) => emit(
    state.copyWith(
      classificiationId: classificiationId,
      servicesIds: servicesIds,
    ),
  );

  Future<void> contractorSignUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    if (state.contractorSignUpState.isLoading) return;
    emit(state.copyWith(contractorSignUpState: RequestStatus.loading));
    final result = await contractorAuthRepoImpl.contractorSignUp(
      contractorSignUpRequestModel: ContractorSignUpRequestModel(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        phone: phone,
        fcmToken: await FcmInitHelper().getFcmToken() ?? "",
        classificationId: state.classificiationId,
        services: state.servicesIds,
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
            phone: phone,
          ),
        );
      },
    );
  }

  Future<void> pickFile() async {
    try {
      final File? file = await ImagePickerService.pickImage();
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
    if (state.completeContractorDataState.isLoading) return;
    if (state.logo == null) {
      emit(
        state.copyWith(
          completeContractorDataState: RequestStatus.error,
          errorMessage: LocaleKeys.pleaseSelectLogo,
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
    if (state.subscibePlanState.isLoading) return;  
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
    if (state.forgetPasswordState.isLoading) return;  
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
