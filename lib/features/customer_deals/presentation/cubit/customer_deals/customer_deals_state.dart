import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';

class CustomerDealsState extends Equatable {
  const CustomerDealsState({
    this.deals = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.status = RequestStatus.initial,
    this.paginationStatus = RequestStatus.initial,
    this.errorMessage = '',
    this.isConnected = true,
    RequestStatus deleteStatus = RequestStatus.initial,
    this.deletingDealId,
    this.deleteMessage = '',
  }) : _deleteStatus = deleteStatus;

  final List<CustomerDealModel> deals;
  final int currentPage;
  final int totalPages;
  final RequestStatus status;
  final RequestStatus paginationStatus;
  final String errorMessage;
  final bool isConnected;
  final RequestStatus? _deleteStatus;
  final int? deletingDealId;
  final String deleteMessage;

  RequestStatus get deleteStatus => _deleteStatus ?? RequestStatus.initial;

  bool get hasMore => currentPage < totalPages;

  CustomerDealsState copyWith({
    List<CustomerDealModel>? deals,
    int? currentPage,
    int? totalPages,
    RequestStatus? status,
    RequestStatus? paginationStatus,
    String? errorMessage,
    bool? isConnected,
    RequestStatus? deleteStatus,
    int? deletingDealId,
    String? deleteMessage,
  }) {
    return CustomerDealsState(
      deals: deals ?? this.deals,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      status: status ?? this.status,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isConnected: isConnected ?? this.isConnected,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deletingDealId: deletingDealId ?? this.deletingDealId,
      deleteMessage: deleteMessage ?? this.deleteMessage,
    );
  }

  @override
  List<Object?> get props => [
    deals,
    currentPage,
    totalPages,
    status,
    paginationStatus,
    errorMessage,
    isConnected,
    deleteStatus,
    deletingDealId,
    deleteMessage,
  ];
}
