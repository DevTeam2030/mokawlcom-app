import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';

class SearchState extends Equatable {
  final RequestStatus getContractorsState;
  final ContractorsModel contractorsModel;
  final String errorMessage;
  final int currentPage;
  final bool isConnected;

  const SearchState({
    this.getContractorsState = RequestStatus.initial,
    this.contractorsModel = const ContractorsModel.empty(),
    this.errorMessage = '',
    this.currentPage = 1,
    this.isConnected = true,
  });

  SearchState copyWith({
    RequestStatus? getContractorsState,
    ContractorsModel? contractorsModel,
    String? errorMessage,
    int? currentPage,
    bool? isConnected,
  }) {
    return SearchState(
      getContractorsState: getContractorsState ?? this.getContractorsState,
      contractorsModel: contractorsModel ?? this.contractorsModel,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    getContractorsState,
    contractorsModel,
    errorMessage,
    isConnected,
  ];
}
