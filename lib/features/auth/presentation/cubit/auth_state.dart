import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/auth/data/models/activate_account_response_model.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_login_response_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

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
  final RequestStatus getClassificationsState;
  final ClassificationsModel classificationsModel;
  final RequestStatus getServicesState;
  final ServicesModel servicesModel;
  final int classificiationId;
  final List<int> servicesIds;
  final RequestStatus contractorSignUpState;
  final RequestStatus completeContractorDataState;
  final RequestStatus subscibePlanState;
  final RequestStatus forgetPasswordState;
  final File? logo;
  final String phone;
  final int classficicationsTotalPages;
  final int servicesTotalPages;
  final int classficicationsCurrentPage;
  final int servicesCurrentPage;
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
    this.classificiationId = 0,
    this.servicesIds = const [],
    this.classificationsModel = const ClassificationsModel.empty(),
    this.servicesModel = const ServicesModel.empty(),
    this.getServicesState = RequestStatus.loading,
    this.getClassificationsState = RequestStatus.loading,
    this.contractorSignUpState = RequestStatus.initial,
    this.completeContractorDataState = RequestStatus.initial,
    this.logo,
    this.phone = "",
    this.subscibePlanState = RequestStatus.initial,
    this.forgetPasswordState = RequestStatus.initial,
    this.isConnected = true,
    this.classficicationsTotalPages = 1,
    this.servicesTotalPages = 1,
    this.classficicationsCurrentPage = 1,
    this.servicesCurrentPage = 1,
  });

  AuthState copyWith({
    RequestStatus? userSignupState,
    String? successMessage,
    String? errorMessage,
    RequestStatus? activateAccountState,
    ActivateAccountResponseModel? activateAccountResponseModel,
    RequestStatus? userLoginState,
    UserLoginResponseModel? userLoginResponseModel,
    ServicesModel? servicesModel,
    ClassificationsModel? classificationsModel,
    RequestStatus? getServicesState,
    RequestStatus? getClassificationsState,
    int? classificiationId,
    List<int>? servicesIds,
    RequestStatus? contractorSignUpState,
    File? logo,
    String? phone,
    RequestStatus? completeContractorDataState,
    RequestStatus? subscibePlanState,
    bool clearSelectedLogo = false,
    RequestStatus? forgetPasswordState,
    bool? isConnected,
    int? classficicationsCurrentPage,
    int? servicesCurrentPage,
    int? classficicationsTotalPages,
    int? servicesTotalPages,
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
      classificationsModel: classificationsModel ?? this.classificationsModel,
      servicesModel: servicesModel ?? this.servicesModel,
      getServicesState: getServicesState ?? this.getServicesState,
      getClassificationsState:
          getClassificationsState ?? this.getClassificationsState,

      classificiationId: classificiationId ?? this.classificiationId,
      servicesIds: servicesIds ?? this.servicesIds,
      contractorSignUpState:
          contractorSignUpState ?? this.contractorSignUpState,
      phone: phone ?? this.phone,
      completeContractorDataState:
          completeContractorDataState ?? this.completeContractorDataState,
      subscibePlanState: subscibePlanState ?? this.subscibePlanState,
      logo: clearSelectedLogo ? null : (logo ?? this.logo),
      forgetPasswordState: forgetPasswordState ?? this.forgetPasswordState,
      isConnected: isConnected ?? this.isConnected,
      classficicationsCurrentPage:
          classficicationsCurrentPage ?? this.classficicationsCurrentPage,
      servicesCurrentPage: servicesCurrentPage ?? this.servicesCurrentPage,
      classficicationsTotalPages:
          classficicationsTotalPages ?? this.classficicationsTotalPages,
      servicesTotalPages: servicesTotalPages ?? this.servicesTotalPages,
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
    classificationsModel,
    servicesModel,
    getServicesState,
    getClassificationsState,
    classificiationId,
    servicesIds,
    contractorSignUpState,
    logo,
    phone,
    completeContractorDataState,
    subscibePlanState,
    forgetPasswordState,
    isConnected,
    classficicationsCurrentPage,
    servicesCurrentPage,
    classficicationsTotalPages,
    servicesTotalPages,
  ];
}
