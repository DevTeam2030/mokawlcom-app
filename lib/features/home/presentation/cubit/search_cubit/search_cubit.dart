import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepo homeRepoImpl;

  SearchCubit({required this.homeRepoImpl}) : super(const SearchState());

  Future<void> getContractors({int? classificationId, int? serviceId}) async {
    emit(
      state.copyWith(
        getContractorsState: RequestStatus.loading,
        isConnected: true,
      ),
    );

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage,
      classification: classificationId,
      service: serviceId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorsModel) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.success,
          contractorsModel: contractorsModel,
        ),
      ),
    );
  }

  Future<void> searchContractors({
    required String query,
    int? classificationId,
    int? serviceId,
  }) async {
    emit(
      state.copyWith(
        getContractorsState: RequestStatus.loading,
        isConnected: true,
      ),
    );

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage,
      search: query,
      classification: classificationId,
      service: serviceId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorsModel) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.success,
          contractorsModel: contractorsModel,
        ),
      ),
    );
  }

  Future<void> loadMoreContractors({
    int? classificationId,
    int? serviceId,
    String? query,
  }) async {
    if (state.getContractorsState.isLoadingMore ||
        state.currentPage >= state.contractorsModel.totalPages) {
      return;
    }

    emit(state.copyWith(getContractorsState: RequestStatus.loadingMore));

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage + 1,
      search: query,
      classification: classificationId,
      service: serviceId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getContractorsState: RequestStatus.error,
            errorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (contractorsModel) {
        final updatedContractors = [
          ...state.contractorsModel.contractors,
          ...contractorsModel.contractors,
        ];

        emit(
          state.copyWith(
            getContractorsState: RequestStatus.success,
            contractorsModel: contractorsModel.copyWith(
              contractors: updatedContractors,
            ),
            currentPage: contractorsModel.currentPage,
          ),
        );
      },
    );
  }
}
