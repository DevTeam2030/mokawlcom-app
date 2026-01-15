part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final RequestStatus updateUserProfileRequestStatus;
  final String errorMessage;
  final String successMessage;
  final File? profileImage;

  const ProfileState({
    this.updateUserProfileRequestStatus = RequestStatus.initial,
    this.errorMessage = "",
    this.successMessage = "",
    this.profileImage,
  });

  ProfileState copyWith({
    RequestStatus? updateUserProfileRequestStatus,
    String? errorMessage,
    String? successMessage,
    File? profileImage,
  }) {
    return ProfileState(
      updateUserProfileRequestStatus:
          updateUserProfileRequestStatus ?? this.updateUserProfileRequestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [
    updateUserProfileRequestStatus,
    errorMessage,
    profileImage,
  ];
}
