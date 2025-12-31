import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/state_box.dart';
import 'package:mokawlcom_app/features/auth/data/shared/models/activate_account_response_model.dart';

class UserAuthState extends Equatable {
  // user sign up
  final RequestStatus userSignupState;
  final String message;
  final String errorMessage;
  // activate user account
  final RequestStatus activateUserAccountState;
  final ActivateAccountResponseModel activateAccountResponseModel;

  const UserAuthState({
    this.userSignupState = RequestStatus.initial,
    this.message = "",
    this.errorMessage = "",
    this.activateUserAccountState = RequestStatus.initial,
    this.activateAccountResponseModel =
        const ActivateAccountResponseModel.empty(),
  });

  UserAuthState copyWith({
    RequestStatus? userSignupState,
    String? message,
    String? errorMessage,
    RequestStatus? activateUserAccountState,
    ActivateAccountResponseModel? activateAccountResponseModel,
  }) {
    return UserAuthState(
      userSignupState: userSignupState ?? this.userSignupState,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      activateUserAccountState:
          activateUserAccountState ?? this.activateUserAccountState,
      activateAccountResponseModel:
          activateAccountResponseModel ?? this.activateAccountResponseModel,
    );
  }

  @override
  List<Object?> get props => [
    userSignupState,
    message,
    errorMessage,
    activateUserAccountState,
    activateAccountResponseModel,
  ];
}
