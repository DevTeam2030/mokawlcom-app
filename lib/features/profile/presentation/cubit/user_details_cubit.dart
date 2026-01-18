import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/profile/data/models/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final ProfileRepo profileRepo;
  UserDetailsCubit({required this.profileRepo})
    : super(const UserDetailsState());

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
}
