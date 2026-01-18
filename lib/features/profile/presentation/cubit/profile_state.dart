part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final RequestStatus updateUserProfileRequestStatus;
  final String errorMessage;
  final String successMessage;
  final File? profileImage;
  final RequestStatus changePasswordRequestState;
  final RequestStatus deleteAccountRequestState;
  final RequestStatus logoutRequestState;
  final RequestStatus getUserProfileRequestState;
  final UserModel userModel;
  final bool isConnected;

  const ProfileState({
    this.updateUserProfileRequestStatus = RequestStatus.initial,
    this.errorMessage = "",
    this.successMessage = "",
    this.profileImage,
    this.changePasswordRequestState = RequestStatus.initial,
    this.deleteAccountRequestState = RequestStatus.initial,
    this.logoutRequestState = RequestStatus.initial,
    this.getUserProfileRequestState = RequestStatus.initial,
    this.userModel = const UserModel.empty(),
    this.isConnected = true,
  });

  ProfileState copyWith({
    RequestStatus? updateUserProfileRequestStatus,
    String? errorMessage,
    String? successMessage,
    File? profileImage,
    RequestStatus? changePasswordRequestState,
    RequestStatus? deleteAccountRequestState,
    RequestStatus? logoutRequestState,
    RequestStatus? getUserProfileRequestState,
    UserModel? userModel,
    bool? isConnected,
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
      logoutRequestState: logoutRequestState ?? this.logoutRequestState,
      getUserProfileRequestState:
          getUserProfileRequestState ?? this.getUserProfileRequestState,
      userModel: userModel ?? this.userModel,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    updateUserProfileRequestStatus,
    errorMessage,
    profileImage,
    changePasswordRequestState,
    deleteAccountRequestState,
    logoutRequestState,
    getUserProfileRequestState,
    userModel,
    isConnected,
  ];
}
