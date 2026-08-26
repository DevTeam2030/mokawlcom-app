import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deal_model.dart';

class ContractorDealsState extends Equatable {
  const ContractorDealsState({
    this.deals = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.status = RequestStatus.initial,
    this.paginationStatus = RequestStatus.initial,
    this.errorMessage = '',
    this.isConnected = true,
  });

  final List<ContractorDealModel> deals;
  final int currentPage;
  final int totalPages;
  final RequestStatus status;
  final RequestStatus paginationStatus;
  final String errorMessage;
  final bool isConnected;

  bool get hasMore => currentPage < totalPages;

  ContractorDealsState copyWith({
    List<ContractorDealModel>? deals,
    int? currentPage,
    int? totalPages,
    RequestStatus? status,
    RequestStatus? paginationStatus,
    String? errorMessage,
    bool? isConnected,
  }) {
    return ContractorDealsState(
      deals: deals ?? this.deals,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      status: status ?? this.status,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    deals,
    currentPage,
    totalPages,
    status,
    paginationStatus,
    errorMessage,
    isConnected,
  ];
}
