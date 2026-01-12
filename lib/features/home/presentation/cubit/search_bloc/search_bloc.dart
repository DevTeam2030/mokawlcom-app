import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_bloc/search_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepo homeRepoImpl;

  SearchBloc({required this.homeRepoImpl}) : super(const SearchState()) {
    on<SearchContractorsEvent>(
      _searchContractorsEvent,
      transformer: debounceRestartable<SearchContractorsEvent>(
        (event) => (event.ignoreDebounce ?? false)
            ? Duration.zero
            : const Duration(milliseconds: 500),
      ),
    );
    on<GetContractorsEvent>(_getContractorsEvent);
    on<LoadMoreContractorsEvent>(_loadMoreContractorsEvent);
    //on<RateContractorEvent>(_rateContractorEvent);
  }

  FutureOr<void> _getContractorsEvent(
    GetContractorsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        getContractorsState: RequestStatus.loading,
        isConnected: true,
        currentPage: 1,
        contractorsModel: const ContractorsModel.empty(),
      ),
    );

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage,
      classification: event.classificationId,
      service: event.serviceId,
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

  FutureOr<void> _searchContractorsEvent(
    SearchContractorsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        searchContractorsState: RequestStatus.loading,
        getContractorsState: RequestStatus.loading,
        isConnected: true,
        currentPage: 1,
        contractorsModel: const ContractorsModel.empty(),
      ),
    );

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage,
      search: event.query,
      classification: event.classificationId,
      service: event.serviceId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.error,
          searchContractorsState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorsModel) => emit(
        state.copyWith(
          getContractorsState: RequestStatus.success,
          searchContractorsState: RequestStatus.success,
          contractorsModel: contractorsModel,
        ),
      ),
    );
  }

  FutureOr<void> _loadMoreContractorsEvent(
    LoadMoreContractorsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.getContractorsState.isLoading ||
        state.currentPage >= state.contractorsModel.totalPages) {
      return;
    }
    emit(state.copyWith(getContractorsState: RequestStatus.loadingMore));

    final result = await homeRepoImpl.getContractors(
      page: state.currentPage + 1,
      search: event.query,
      classification: event.classificationId,
      service: event.serviceId,
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

  EventTransformer<T> debounceRestartable<T>(
    Duration Function(T event) durationMapper,
  ) {
    return (events, mapper) {
      final debouncedEvents = events
          .where((event) => durationMapper(event) != Duration.zero)
          .debounceTime(const Duration(milliseconds: 500));

      final immediateEvents = events.where(
        (event) => durationMapper(event) == Duration.zero,
      );

      return restartable<T>()(
        MergeStream<T>([debouncedEvents, immediateEvents]),
        mapper,
      );
    };
  }

  
}
