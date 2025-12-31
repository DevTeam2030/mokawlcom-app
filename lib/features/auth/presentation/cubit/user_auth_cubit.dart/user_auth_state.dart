import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/state_box.dart';

class UserAuthState extends Equatable {
  final RequestStatus userSignupState;
  final String message;
  final String errorMessage;

  const UserAuthState({
     this.userSignupState=RequestStatus.initial,
    this.message = "",
    this.errorMessage = "",
  });

  UserAuthState copyWith({
    RequestStatus? userSignupState,
    String? message,
    String? errorMessage,
  }) {
    return UserAuthState(
      userSignupState: userSignupState ?? this.userSignupState,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [userSignupState, message, errorMessage];
}
