import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/pick_image_service.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/add_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/edit_service_request_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/service/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final ProfileRepo profileRepo;

  UserDetailsCubit({required this.profileRepo})
      : super(const UserDetailsState());

  Future<void> getUserOffers() async {
    emit(
      state.copyWith(
        getUserOffersState: RequestStatus.loading,
        isConnected: true,
      ),
    );
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
      emit(state.copyWith(isImageLoading: true, imageErrorMessage: ''));

      final List<File> pickedFiles =
          await ImagePickerService.pickMultipleImages();

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
                  '${LocaleKeys.imageSizeExceeded} ${state.maxSizeInMB} MB',
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

  void clearImages() {
    emit(state.copyWith(selectedImages: []));
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
      (serviceResponseModel) {
        final updatedServices = List<ContractorServiceModel>.from(
          state.contractorServicesModel.services,
        );
        updatedServices.insert(0, serviceResponseModel.contractorServiceModel);
        emit(
          state.copyWith(
            addNewServiceState: RequestStatus.success,
            imageUploadProgress: 0.0,
            successMessage: serviceResponseModel.message,
            contractorServicesModel: state.contractorServicesModel.copyWith(
              services: updatedServices,
            ),
          ),
        );
      },
    );
  }

  Future<void> editService({
    required int serviceId,
    required int index,
    required String classificationId,
    required String name,
    required String description,
    required String price,
  }) async {
    emit(state.copyWith(editServiceState: RequestStatus.loading));
    final result = await profileRepo.editService(
      editServiceRequestModel: EditServiceRequestModel(
        serviceId: serviceId,
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
          editServiceState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
          imageUploadProgress: 0.0,
        ),
      ),
      (serviceResponseModel) {
        final updatedServices = List<ContractorServiceModel>.from(
          state.contractorServicesModel.services,
        );
        updatedServices[index] = serviceResponseModel.contractorServiceModel;
        emit(
          state.copyWith(
            editServiceState: RequestStatus.success,
            imageUploadProgress: 0.0,
            successMessage: serviceResponseModel.message,
            contractorServicesModel: state.contractorServicesModel.copyWith(
              services: updatedServices,
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteService({
    required int serviceId,
    required int index,
  }) async {
    final oldState = state;
    final updatedServices = List<ContractorServiceModel>.from(
      state.contractorServicesModel.services,
    );
    updatedServices.removeAt(index);
    emit(
      state.copyWith(
        deleteServiceState: RequestStatus.loading,
        contractorServicesModel: state.contractorServicesModel.copyWith(
          services: updatedServices,
        ),
      ),
    );
    final result = await profileRepo.deleteService(serviceId: serviceId);
    result.fold(
      (failure) => emit(
        oldState.copyWith(
          deleteServiceState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) => emit(
        state.copyWith(
          deleteServiceState: RequestStatus.success,
          successMessage: message,
        ),
      ),
    );
  }

  Future<void> getDeals() async {
    emit(
      state.copyWith(getDealsState: RequestStatus.loading, isConnected: true),
    );
    final result = await profileRepo.getDeals(page: state.dealsCurrentPage);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getDealsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (dealsModel) => emit(
        state.copyWith(
          getDealsState: RequestStatus.success,
          dealsModel: dealsModel,
          dealsCurrentPage: dealsModel.currentPage,
        ),
      ),
    );
  }

  Future<void> loadMoreDeals() async {
    if (state.dealsCurrentPage >= state.dealsModel.totalPages ||
        state.getDealsState.isLoadingMore) {
      return;
    }
    emit(state.copyWith(getDealsState: RequestStatus.loadingMore));
    final result = await profileRepo.getDeals(page: state.dealsCurrentPage + 1);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getDealsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (dealsModel) => emit(
        state.copyWith(
          getDealsState: RequestStatus.success,
          dealsModel: dealsModel.copyWith(
            deals: [...state.dealsModel.deals, ...dealsModel.deals],
          ),
          dealsCurrentPage: dealsModel.currentPage,
        ),
      ),
    );
  }

  Future<void> addDeal({
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(addDealState: RequestStatus.loading));
    final result = await profileRepo.addDeal(
      title: title,
      description: description,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addDealState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) => emit(
        state.copyWith(
          addDealState: RequestStatus.success,
          successMessage: message,
        ),
      ),
    );
  }

  Future<void> deleteDeal({required int dealId}) async {
    final oldState = state;
    final updatedDeals = List<DealModel>.from(state.dealsModel.deals);
    updatedDeals.removeWhere((deal) => deal.id == dealId);
    emit(
      state.copyWith(
        deleteDealState: RequestStatus.loading,
        dealsModel: state.dealsModel.copyWith(deals: updatedDeals),
      ),
    );
    final result = await profileRepo.deleteDeal(dealId: dealId);
    result.fold(
      (failure) => emit(
        oldState.copyWith(
          deleteDealState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) => emit(
        state.copyWith(
          deleteDealState: RequestStatus.success,
          successMessage: message,
        ),
      ),
    );
  }

  Future<void> editDeal({
    required int dealId,
    required int index,
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(editDealState: RequestStatus.loading));
    final result = await profileRepo.editDeal(
      dealId: dealId,
      title: title,
      description: description,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          editDealState: RequestStatus.error,
          errorMessage: failure.errorMessage,
        ),
      ),
      (message) {
        final updatedDeals = List<DealModel>.from(state.dealsModel.deals);
        updatedDeals[index] = updatedDeals[index].copyWith(
          title: title,
          description: description,
        );
        emit(
          state.copyWith(
            editDealState: RequestStatus.success,
            successMessage: message,
            dealsModel: state.dealsModel.copyWith(deals: updatedDeals),
          ),
        );
      },
    );
  }
}
