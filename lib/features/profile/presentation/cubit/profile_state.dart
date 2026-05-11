part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final RequestStatus updateUserProfileRequestStatus;
  final RequestStatus getPlanRequestStatus;
  final RequestStatus getSettingsRequestStatus;
  final SettingsModel settingsModel;
  final PlanModel planModel;
  final String errorMessage;
  final String successMessage;
  final File? profileImage;
  final RequestStatus changePasswordRequestState;
  final RequestStatus deleteAccountRequestState;
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
    this.getUserProfileRequestState = RequestStatus.initial,
    this.userModel = const UserModel.empty(),
    this.isConnected = true,
    this.getPlanRequestStatus = RequestStatus.initial,
    this.planModel = const PlanModel.empty(),
    this.getSettingsRequestStatus = RequestStatus.loading,
    this.settingsModel = const SettingsModel.empty(),
  });

  ProfileState copyWith({
    RequestStatus? updateUserProfileRequestStatus,
    String? errorMessage,
    String? successMessage,
    File? profileImage,
    RequestStatus? changePasswordRequestState,
    RequestStatus? deleteAccountRequestState,
    RequestStatus? getUserProfileRequestState,
    UserModel? userModel,
    bool? isConnected,
    bool? clearProfileImage,
    RequestStatus? getPlanRequestStatus,
    PlanModel? planModel,
    RequestStatus? getSettingsRequestStatus,
    SettingsModel? settingsModel,
  }) {
    return ProfileState(
      updateUserProfileRequestStatus:
          updateUserProfileRequestStatus ?? this.updateUserProfileRequestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      profileImage: clearProfileImage == true
          ? null
          : profileImage ?? this.profileImage,
      changePasswordRequestState:
          changePasswordRequestState ?? this.changePasswordRequestState,
      deleteAccountRequestState:
          deleteAccountRequestState ?? this.deleteAccountRequestState,
      getUserProfileRequestState:
          getUserProfileRequestState ?? this.getUserProfileRequestState,
      userModel: userModel ?? this.userModel,
      isConnected: isConnected ?? this.isConnected,
      getPlanRequestStatus: getPlanRequestStatus ?? this.getPlanRequestStatus,
      planModel: planModel ?? this.planModel,
      getSettingsRequestStatus:
          getSettingsRequestStatus ?? this.getSettingsRequestStatus,
      settingsModel: settingsModel ?? this.settingsModel,
    );
  }

  @override
  List<Object?> get props => [
    updateUserProfileRequestStatus,
    errorMessage,
    profileImage,
    changePasswordRequestState,
    deleteAccountRequestState,
    getUserProfileRequestState,
    userModel,
    isConnected,
    getPlanRequestStatus,
    planModel,
    getSettingsRequestStatus,
    settingsModel,
  ];
}
