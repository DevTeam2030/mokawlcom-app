import 'package:bloc/bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/repo/customer_deals_repo.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deals/customer_deals_state.dart';

class CustomerDealsCubit extends Cubit<CustomerDealsState> {
  CustomerDealsCubit({required this.customerDealsRepo})
    : super(const CustomerDealsState());

  final CustomerDealsRepo customerDealsRepo;

  Future<void> deleteCustomerDeal({
    required int dealId,
    required int? repliesCount,
  }) async {
    if (isClosed || repliesCount != 0 || state.deleteStatus.isLoading) return;

    emit(
      state.copyWith(
        deleteStatus: RequestStatus.loading,
        deletingDealId: dealId,
        deleteMessage: '',
        errorMessage: '',
        isConnected: true,
      ),
    );
    final result = await customerDealsRepo.deleteCustomerDeal(dealId: dealId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (message) => emit(
        state.copyWith(
          deleteStatus: RequestStatus.success,
          deleteMessage: message,
        ),
      ),
    );
  }

  Future<void> getMyDeals() async {
    if (state.status.isLoading || state.paginationStatus.isLoadingMore) return;
    await _loadFirstPage(clearExisting: false);
  }

  Future<void> refreshMyDeals() async {
    if (state.status.isLoading || state.paginationStatus.isLoadingMore) return;
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

    final result = await customerDealsRepo.getMyDeals(page: 1);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (customerDeals) => emit(
        state.copyWith(
          deals: _deduplicate(customerDeals.deals),
          currentPage: customerDeals.currentPage,
          totalPages: customerDeals.totalPages,
          status: RequestStatus.success,
          paginationStatus: RequestStatus.initial,
          errorMessage: '',
          isConnected: true,
        ),
      ),
    );
  }

  Future<void> loadMoreMyDeals() async {
    if (state.status.isLoading ||
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

    final result = await customerDealsRepo.getMyDeals(
      page: state.currentPage + 1,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          paginationStatus: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (customerDeals) => emit(
        state.copyWith(
          deals: _deduplicate([...state.deals, ...customerDeals.deals]),
          currentPage: customerDeals.currentPage,
          totalPages: customerDeals.totalPages,
          paginationStatus: RequestStatus.success,
          errorMessage: '',
          isConnected: true,
        ),
      ),
    );
  }

  List<CustomerDealModel> _deduplicate(Iterable<CustomerDealModel> deals) {
    final dealsById = <int, CustomerDealModel>{};
    for (final deal in deals) {
      dealsById[deal.id] = deal;
    }
    return dealsById.values.toList(growable: false);
  }
}
