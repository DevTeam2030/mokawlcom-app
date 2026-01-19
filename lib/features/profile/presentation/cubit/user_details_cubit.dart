import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/profile/data/models/add_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final ProfileRepo profileRepo;
  final ImagePicker _imagePicker;

  UserDetailsCubit({required this.profileRepo, ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker(),
      super(const UserDetailsState());

  Future<void> getUserOffers() async {
    emit(state.copyWith(getUserOffersState: RequestStatus.loading));
    final result = await profileRepo.getUserOffers(
      page: state.userOffersCurrentPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.success,
          userOffersModel: userOffersModel,
        ),
      ),
    );
  }

  Future<void> loadMoreUserOffers() async {
    if (state.userOffersCurrentPage >= state.userOffersModel.totalPages ||
        state.getUserOffersState.isLoadingMore) {
      return;
    }
    emit(state.copyWith(getUserOffersState: RequestStatus.loadingMore));
    final result = await profileRepo.getUserOffers(
      page: state.userOffersCurrentPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.success,
          userOffersModel: userOffersModel.copyWith(
            offers: [
              ...state.userOffersModel.offers,
              ...userOffersModel.offers,
            ],
          ),
          userOffersCurrentPage: userOffersModel.currentPage,
        ),
      ),
    );
  }

  Future<void> getContractorServices() async {
    emit(
      state.copyWith(
        getContractorServicesState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await profileRepo.getContractorServices(
      page: state.contractorServicesCurrentPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getContractorServicesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorServices) => emit(
        state.copyWith(
          getContractorServicesState: RequestStatus.success,
          contractorServicesModel: contractorServices,
          contractorServicesCurrentPage: contractorServices.currentPage,
        ),
      ),
    );
  }

  Future<void> loadMoreContractorServices() async {
    if (state.contractorServicesCurrentPage >=
            state.contractorServicesModel.totalPages ||
        state.getContractorServicesState.isLoadingMore) {
      return;
    }
    emit(state.copyWith(getContractorServicesState: RequestStatus.loadingMore));
    final result = await profileRepo.getContractorServices(
      page: state.contractorServicesCurrentPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getContractorServicesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorServices) => emit(
        state.copyWith(
          getContractorServicesState: RequestStatus.success,
          contractorServicesModel: contractorServices.copyWith(
            services: [
              ...state.contractorServicesModel.services,
              ...contractorServices.services,
            ],
          ),
          contractorServicesCurrentPage: contractorServices.currentPage,
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    if (state.hasReachedMaxImages) {
      emit(
        state.copyWith(
          imageErrorMessage:
              '${LocaleKeys.maxImagesReached} ${state.maxImages}',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(isImageLoading: true));

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
        limit: state.maxImages,
        
      );

      if (pickedFiles.isEmpty) {
        emit(state.copyWith(isImageLoading: false));
        return;
      }

      final List<File> validImages = [];
      final int remainingSlots = state.maxImages - state.selectedImages.length;

      for (int i = 0; i < pickedFiles.length && i < remainingSlots; i++) {
        final file = File(pickedFiles[i].path);
        final fileSizeInMB = await file.length() / (1024 * 1024);

        if (fileSizeInMB > state.maxSizeInMB) {
          emit(
            state.copyWith(
              isImageLoading: false,
              imageErrorMessage:
                  '${LocaleKeys.imageSizeExceeded} ${state.maxSizeInMB}MB',
            ),
          );
          return;
        }

        validImages.add(file);
      }

      final updatedImages = [...state.selectedImages, ...validImages];

      if (updatedImages.length > state.maxImages) {
        emit(
          state.copyWith(
            isImageLoading: false,
            imageErrorMessage:
                '${LocaleKeys.maxImagesReached} ${state.maxImages}',
          ),
        );
        return;
      }

      emit(
        state.copyWith(selectedImages: updatedImages, isImageLoading: false),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isImageLoading: false,
          imageErrorMessage: LocaleKeys.errorPickingImages,
        ),
      );
    }
  }

  void removeImage(int index) {
    if (index < 0 || index >= state.selectedImages.length) return;

    final updatedImages = List<File>.from(state.selectedImages);
    updatedImages.removeAt(index);

    emit(state.copyWith(selectedImages: updatedImages));
  }

  Future<void> addService({
    required String classificationId,
    required String name,
    required String description,
    required String price,
  }) async {
    emit(state.copyWith(addNewServiceState: RequestStatus.loading));
    final result = await profileRepo.addService(
      addServiceRequestModel: AddServiceRequestModel(
        name: name,
        description: description,
        price: price,
        images: state.selectedImages,
        classificationId: classificationId,
      ),
      onSendProgress: (sent, total) {
        emit(state.copyWith(imageUploadProgress: sent / total));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addNewServiceState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
          imageUploadProgress: 0.0,
        ),
      ),
      (succesMessage) => emit(
        state.copyWith(
          addNewServiceState: RequestStatus.success,
          imageUploadProgress: 0.0,
          successMessage: succesMessage,
        ),
      ),
    );
  }
}
