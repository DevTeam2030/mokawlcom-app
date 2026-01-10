import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/cubit/home_state.dart';

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
    emit(
      state.copyWith(
        getClassificationsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await contractorAuthRepoImpl.getClassifications(page: 1);
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
          classifications: classificationsModel.classifications,
        ),
      ),
    );
  }
}
