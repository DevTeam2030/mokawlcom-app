import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/setting_result_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';

class AuthState extends Equatable {
  //user
  final RequestStatus userSignupState;
  final String successMessage;
  final String errorMessage;
  final RequestStatus activateAccountState;
  final ActivateAccountResponseModel activateAccountResponseModel;
  final RequestStatus userLoginState;
  final UserLoginResponseModel userLoginResponseModel;
  // contractor sign up
  final RequestStatus getSettingsState;
  final SettingsResultModel settingsResultModel;
  final int classificiationId;
  final List<int> services;
  final RequestStatus contractorSignUpState;
  final RequestStatus completeContractorDataState;
  final RequestStatus subscibePlanState;
  final RequestStatus forgetPasswordState;
  final File? logo;
  final String phone;

  final bool isConnected;

  const AuthState({
    this.userSignupState = RequestStatus.initial,
    this.successMessage = "",
    this.errorMessage = "",
    this.activateAccountState = RequestStatus.initial,
    this.activateAccountResponseModel =
        const ActivateAccountResponseModel.empty(),
    this.userLoginState = RequestStatus.initial,
    this.userLoginResponseModel = const UserLoginResponseModel.empty(),
    this.getSettingsState = RequestStatus.initial,
    this.settingsResultModel = const SettingsResultModel.empty(),
    this.classificiationId = 0,
    this.services = const [],
    this.contractorSignUpState = RequestStatus.initial,
    this.completeContractorDataState = RequestStatus.initial,
    this.logo,
    this.phone = "",
    this.subscibePlanState = RequestStatus.initial,
    this.forgetPasswordState = RequestStatus.initial,
    this.isConnected = true,
  });

  AuthState copyWith({
    RequestStatus? userSignupState,
    String? successMessage,
    String? errorMessage,
    RequestStatus? activateAccountState,
    ActivateAccountResponseModel? activateAccountResponseModel,
    RequestStatus? userLoginState,
    UserLoginResponseModel? userLoginResponseModel,
    RequestStatus? getSettingsState,
    SettingsResultModel? settingsResultModel,
    int? classificiationId,
    List<int>? services,
    RequestStatus? contractorSignUpState,
    File? logo,
    String? phone,
    RequestStatus? completeContractorDataState,
    RequestStatus? subscibePlanState,
    bool clearSelectedLogo = false,
    RequestStatus? forgetPasswordState,
    bool? isConnected,
  }) {
    return AuthState(
      userSignupState: userSignupState ?? this.userSignupState,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      activateAccountState: activateAccountState ?? this.activateAccountState,
      activateAccountResponseModel:
          activateAccountResponseModel ?? this.activateAccountResponseModel,
      userLoginState: userLoginState ?? this.userLoginState,
      userLoginResponseModel:
          userLoginResponseModel ?? this.userLoginResponseModel,
      getSettingsState: getSettingsState ?? this.getSettingsState,
      settingsResultModel: settingsResultModel ?? this.settingsResultModel,
      classificiationId: classificiationId ?? this.classificiationId,
      services: services ?? this.services,
      contractorSignUpState:
          contractorSignUpState ?? this.contractorSignUpState,
      phone: phone ?? this.phone,
      completeContractorDataState:
          completeContractorDataState ?? this.completeContractorDataState,
      subscibePlanState: subscibePlanState ?? this.subscibePlanState,
      logo: clearSelectedLogo ? null : (logo ?? this.logo),
      forgetPasswordState: forgetPasswordState ?? this.forgetPasswordState,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    userSignupState,
    successMessage,
    errorMessage,
    activateAccountState,
    activateAccountResponseModel,
    userLoginState,
    userLoginResponseModel,
    getSettingsState,
    settingsResultModel,
    classificiationId,
    services,
    contractorSignUpState,
    logo,
    phone,
    completeContractorDataState,
    subscibePlanState,
    forgetPasswordState,
    isConnected,
  ];
}
