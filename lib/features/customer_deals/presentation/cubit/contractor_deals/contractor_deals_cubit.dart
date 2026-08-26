import 'package:bloc/bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/repo/customer_deals_repo.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/contractor_deals/contractor_deals_state.dart';

class ContractorDealsCubit extends Cubit<ContractorDealsState> {
  ContractorDealsCubit({required this.customerDealsRepo})
    : super(const ContractorDealsState());

  final CustomerDealsRepo customerDealsRepo;

  Future<void> getContractorDeals() async {
    if (isClosed ||
        state.status.isLoading ||
        state.paginationStatus.isLoadingMore) {
      return;
    }
    await _loadFirstPage(clearExisting: false);
  }

  Future<void> refreshContractorDeals() async {
    if (isClosed ||
        state.status.isLoading ||
        state.paginationStatus.isLoadingMore) {
      return;
    }
    await _loadFirstPage(clearExisting: true);
  }

  Future<void> _loadFirstPage({required bool clearExisting}) async {
    emit(
      state.copyWith(
        deals: clearExisting ? const [] : state.deals,
        currentPage: clearExisting ? 0 : state.currentPage,
        totalPages: clearExisting ? 0 : state.totalPages,
        status: RequestStatus.loading,
        paginationStatus: RequestStatus.initial,
        errorMessage: '',
        isConnected: true,
      ),
    );

    final result = await customerDealsRepo.getContractorDeals(page: 1);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorDeals) => emit(
        state.copyWith(
          deals: _deduplicate(contractorDeals.deals),
          currentPage: contractorDeals.currentPage,
          totalPages: contractorDeals.totalPages,
          status: RequestStatus.success,
          paginationStatus: RequestStatus.initial,
          errorMessage: '',
          isConnected: true,
        ),
      ),
    );
  }

  Future<void> loadMoreContractorDeals() async {
    if (isClosed ||
        state.status.isLoading ||
        state.paginationStatus.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(
      state.copyWith(
        paginationStatus: RequestStatus.loadingMore,
        errorMessage: '',
        isConnected: true,
      ),
    );
    final result = await customerDealsRepo.getContractorDeals(
      page: state.currentPage + 1,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          paginationStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (contractorDeals) => emit(
        state.copyWith(
          deals: _deduplicate([...state.deals, ...contractorDeals.deals]),
          currentPage: contractorDeals.currentPage,
          totalPages: contractorDeals.totalPages,
          paginationStatus: RequestStatus.success,
          errorMessage: '',
          isConnected: true,
        ),
      ),
    );
  }

  List<ContractorDealModel> _deduplicate(Iterable<ContractorDealModel> deals) {
    final dealsById = <int, ContractorDealModel>{};
    for (final deal in deals) {
      dealsById[deal.id] = deal;
    }
    return dealsById.values.toList(growable: false);
  }
}
