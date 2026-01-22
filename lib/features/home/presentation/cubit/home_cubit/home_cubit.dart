import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/home/data/models/add_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final ContractorAuthRepo contractorAuthRepoImpl;
  final HomeRepo homeRepoImpl;
  HomeCubit({required this.contractorAuthRepoImpl, required this.homeRepoImpl})
    : super(const HomeState());
  Future<void> getBanners() async {
    emit(
      state.copyWith(getBannersState: RequestStatus.loading, isConnected: true),
    );

    final result = await homeRepoImpl.getBanners();
    result.fold(
      (failure) => emit(
        state.copyWith(
          getBannersState: RequestStatus.error,
          bannersErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (banners) => emit(
        state.copyWith(
          getBannersState: RequestStatus.success,
          banners: banners,
        ),
      ),
    );
  }

  Future<void> getClassifications() async {
    if (state.classificationsModel.classifications.isNotEmpty) {
      return;
    }
    emit(
      state.copyWith(
        getClassificationsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getClassifications(
      page: state.classificationsPage,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.error,
          classificationsErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.success,
          classificationsModel: classificationsModel,
          classificationsPage: classificationsModel.currentPage,
          classificationsTotalPages: classificationsModel.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMoreClassifications() async {
    if (state.classificationsPage >= state.classificationsTotalPages ||
        state.getClassificationsState.isLoading) {
      return;
    }
    emit(
      state.copyWith(
        getClassificationsState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getClassifications(
      page: state.classificationsPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getClassificationsState: RequestStatus.error,
          classificationsErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) {
        final List<ClassificationModel> updatedClassifications = [
          ...state.classificationsModel.classifications,
          ...classificationsModel.classifications,
        ];
        emit(
          state.copyWith(
            getClassificationsState: RequestStatus.success,
            classificationsModel: classificationsModel.copyWith(
              classifications: updatedClassifications,
            ),
            classificationsPage: classificationsModel.currentPage,
            classificationsTotalPages: classificationsModel.totalPages,
          ),
        );
      },
    );
  }

  Future<void> getServices({
    required int classificationId,
  }) async {
    emit(
      state.copyWith(
        getServicesState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getServices(
      page: state.servicesPage,
      classificationId: classificationId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getServicesState: RequestStatus.error,
          servicesErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (servicesModel) => emit(
        state.copyWith(
          getServicesState: RequestStatus.success,
          servicesModel: servicesModel,
          servicesPage: servicesModel.currentPage,
          servicesTotalPages: servicesModel.totalPages,
        ),
      ),
    );
  }

  Future<void> loadMoreServices({
    required int classificationId,
  }) async {
    if (state.servicesPage >= state.servicesTotalPages ||
        state.getServicesState.isLoading) {
      return;
    }
    emit(
      state.copyWith(
        getServicesState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getServices(
      page: state.servicesPage + 1,
      classificationId: classificationId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getServicesState: RequestStatus.error,
          servicesErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (servicesModel) {
        final List<ServiceModel> updatedServices = [
          ...state.servicesModel.services,
          ...servicesModel.services,
        ];
        emit(
          state.copyWith(
            getServicesState: RequestStatus.success,
            servicesModel: servicesModel.copyWith(services: updatedServices),
            servicesPage: servicesModel.currentPage,
            servicesTotalPages: servicesModel.totalPages,
          ),
        );
      },
    );
  }

   
}
