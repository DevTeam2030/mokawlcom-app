import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/state_box.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/setting_result_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';

class AuthState extends Equatable {
  // user sign up
  final RequestStatus userSignupState;
  final String message;
  final String errorMessage;
  // activate user account
  final RequestStatus activateUserAccountState;
  final ActivateAccountResponseModel activateAccountResponseModel;
  // user login
  final RequestStatus userLoginState;
  final UserLoginResponseModel userLoginResponseModel;
  // contractor sign up
  final RequestStatus getSettingsState;
  final SettingsResultModel settingsResultModel;
  final int classificiationId;
  final List<int> services;
  final bool isConnected;

  const AuthState({
    this.userSignupState = RequestStatus.initial,
    this.message = "",
    this.errorMessage = "",
    this.activateUserAccountState = RequestStatus.initial,
    this.activateAccountResponseModel =
        const ActivateAccountResponseModel.empty(),
    this.userLoginState = RequestStatus.initial,
    this.userLoginResponseModel = const UserLoginResponseModel.empty(),
    this.getSettingsState = RequestStatus.initial,
    this.settingsResultModel = const SettingsResultModel.empty(),
    this.classificiationId = 0,
    this.services = const [],
    this.isConnected = true,
  });

  AuthState copyWith({
    RequestStatus? userSignupState,
    String? message,
    String? errorMessage,
    RequestStatus? activateUserAccountState,
    ActivateAccountResponseModel? activateAccountResponseModel,
    RequestStatus? userLoginState,
    UserLoginResponseModel? userLoginResponseModel,
    RequestStatus? getSettingsState,
    SettingsResultModel? settingsResultModel,
    int? classificiationId,
    List<int>? services,
    bool? isConnected,
  }) {
    return AuthState(
      userSignupState: userSignupState ?? this.userSignupState,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      activateUserAccountState:
          activateUserAccountState ?? this.activateUserAccountState,
      activateAccountResponseModel:
          activateAccountResponseModel ?? this.activateAccountResponseModel,
      userLoginState: userLoginState ?? this.userLoginState,
      userLoginResponseModel:
          userLoginResponseModel ?? this.userLoginResponseModel,
      getSettingsState: getSettingsState ?? this.getSettingsState,
      settingsResultModel: settingsResultModel ?? this.settingsResultModel,
      classificiationId: classificiationId ?? this.classificiationId,
      services: services ?? this.services,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    userSignupState,
    message,
    errorMessage,
    activateUserAccountState,
    activateAccountResponseModel,
    userLoginState,
    userLoginResponseModel,
    getSettingsState,
    settingsResultModel,
    classificiationId,
    services,
    isConnected,
  ];
}
