part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final RequestStatus updateUserProfileRequestStatus;
  final String errorMessage;
  final String successMessage;
  final File? profileImage;
  final RequestStatus changePasswordRequestState;
  final RequestStatus deleteAccountRequestState;

  const ProfileState({
    this.updateUserProfileRequestStatus = RequestStatus.initial,
    this.errorMessage = "",
    this.successMessage = "",
    this.profileImage,
    this.changePasswordRequestState = RequestStatus.initial,
    this.deleteAccountRequestState = RequestStatus.initial,
  });

  ProfileState copyWith({
    RequestStatus? updateUserProfileRequestStatus,
    String? errorMessage,
    String? successMessage,
    File? profileImage,
    RequestStatus? changePasswordRequestState,
    RequestStatus? deleteAccountRequestState,
  }) {
    return ProfileState(
      updateUserProfileRequestStatus:
          updateUserProfileRequestStatus ?? this.updateUserProfileRequestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      profileImage: profileImage ?? this.profileImage,
      changePasswordRequestState:
          changePasswordRequestState ?? this.changePasswordRequestState,
      deleteAccountRequestState:
          deleteAccountRequestState ?? this.deleteAccountRequestState,
    );
  }

  @override
  List<Object?> get props => [
    updateUserProfileRequestStatus,
    errorMessage,
    profileImage,
    changePasswordRequestState,
    deleteAccountRequestState,
  ];
}
