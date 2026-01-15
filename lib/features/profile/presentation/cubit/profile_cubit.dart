import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/locale_keys.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(const ProfileState());

  Future<void> updateUserProfile({
    required UpdateUserProfileRequestModel updateUserProfileRequestModel,
  }) async {
    emit(state.copyWith(updateUserProfileRequestStatus: RequestStatus.loading));
    final result = await profileRepo.updateProfile(
      updateUserProfileRequestModel: updateUserProfileRequestModel,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          updateUserProfileRequestStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (successMessage) => emit(
        state.copyWith(
          updateUserProfileRequestStatus: RequestStatus.success,
          successMessage: successMessage,
        ),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final File? file = await FilePickerService.pickFile(image: true);
      emit(state.copyWith(profileImage: file));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          updateUserProfileRequestStatus: RequestStatus.error,
          // ignore: avoid_redundant_argument_values
          profileImage: null,
        ),
      );
      return;
    }
  }

  Future<void> changeProfileImage() async {
    await _pickProfileImage();
    if (state.profileImage == null) {
      emit(
        state.copyWith(
          errorMessage: LocaleKeys.pleaseSelectAnImage,
          updateUserProfileRequestStatus: RequestStatus.error,
          // ignore: avoid_redundant_argument_values
          profileImage: null,
        ),
      );
      return;
    }
    emit(state.copyWith(updateUserProfileRequestStatus: RequestStatus.loading));
    final result = await profileRepo.changeProfileImage(
      image: state.profileImage!,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          updateUserProfileRequestStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
          // ignore: avoid_redundant_argument_values
          profileImage: null,
        ),
      ),
      (successMessage) => emit(
        state.copyWith(
          updateUserProfileRequestStatus: RequestStatus.success,
          successMessage: successMessage,
        ),
      ),
    );
  }
}
