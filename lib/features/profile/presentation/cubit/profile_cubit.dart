import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/services/pick_image_service.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/edit_contractor_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/plan/plan_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/locale_keys.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final CacheHelper cacheHelper;
  ProfileCubit({required this.profileRepo, required this.cacheHelper})
    : super(const ProfileState());

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
      final File? file = await ImagePickerService.pickImage();
      emit(state.copyWith(profileImage: file));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.toString(),
          updateUserProfileRequestStatus: RequestStatus.error,
          clearProfileImage: true,
        ),
      );
      return;
    }
  }

  void clearProfileImage() => emit(state.copyWith(clearProfileImage: true));

  Future<void> changeProfileImage() async {
    await _pickProfileImage();
    if (state.profileImage == null) {
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

  Future<void> changePassword({
    required ChangePasswordRequestModel changePasswordRequestModel,
  }) async {
    emit(state.copyWith(changePasswordRequestState: RequestStatus.loading));
    final result = await profileRepo.changePassword(
      changePasswordRequestModel: changePasswordRequestModel,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          changePasswordRequestState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (successMessage) => emit(
        state.copyWith(
          changePasswordRequestState: RequestStatus.success,
          successMessage: successMessage,
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(deleteAccountRequestState: RequestStatus.loading));
    final result = await profileRepo.deleteAccount();
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteAccountRequestState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (successMessage) {
        cacheHelper.deleteAll();
        AppConstants.token = "";
        emit(
          state.copyWith(
            deleteAccountRequestState: RequestStatus.success,
            successMessage: successMessage,
          ),
        );
      },
    );
  }

  Future<void> editContractorProfile({
    required EditContractorProfileRequestModel
    editContractorProfileRequestModel,
  }) async {
    emit(state.copyWith(updateUserProfileRequestStatus: RequestStatus.loading));
    final result = await profileRepo.editContractorProfile(
      editContractorProfileRequestModel: editContractorProfileRequestModel,
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

  Future<void> logout() async {
    emit(state.copyWith(logoutRequestState: RequestStatus.loading));
    final result = await profileRepo.logout();
    result.fold(
      (failure) => emit(
        state.copyWith(
          logoutRequestState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (successMessage) {
        cacheHelper.deleteAll();
        AppConstants.token = "";
        emit(
          state.copyWith(
            logoutRequestState: RequestStatus.success,
            successMessage: successMessage,
          ),
        );
      },
    );
  }

  Future<void> getUserProfile() async {
    emit(
      state.copyWith(
        getUserProfileRequestState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await profileRepo.getUserProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserProfileRequestState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (userModel) => emit(
        state.copyWith(
          getUserProfileRequestState: RequestStatus.success,
          userModel: userModel,
        ),
      ),
    );
  }

  Future<void> getContractorProfile() async {
    emit(
      state.copyWith(
        getUserProfileRequestState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await profileRepo.getContractorProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserProfileRequestState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (userModel) => emit(
        state.copyWith(
          getUserProfileRequestState: RequestStatus.success,
          userModel: userModel,
        ),
      ),
    );
  }

  Future<void> getPlan() async {
    emit(state.copyWith(getPlanRequestStatus: RequestStatus.loading));
    final result = await profileRepo.getPlan();
    result.fold(
      (failure) => emit(
        state.copyWith(
          getPlanRequestStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (planModel) => emit(
        state.copyWith(
          getPlanRequestStatus: RequestStatus.success,
          planModel: planModel,
        ),
      ),
    );
  }
}
