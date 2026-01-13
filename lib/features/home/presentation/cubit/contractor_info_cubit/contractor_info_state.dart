part of 'contractor_info_cubit.dart';

class ContractorInfoState extends Equatable {
  final RequestStatus getContractorDetailsState;
  final ContractorDetailsModel contractorDetails;
  final String errorMessage;
  final bool isSaved;
  final bool isConnected;

  const ContractorInfoState({
    this.getContractorDetailsState = RequestStatus.initial,
    this.contractorDetails = const ContractorDetailsModel.empty(),
    this.errorMessage = "",
    this.isSaved = false,
    this.isConnected = true,
  });

  ContractorInfoState copyWith({
    RequestStatus? getContractorDetailsState,
    ContractorDetailsModel? contractorDetails,
    String? errorMessage,
    bool? isSaved,
    bool? isConnected,
  }) {
    return ContractorInfoState(
      getContractorDetailsState:
          getContractorDetailsState ?? this.getContractorDetailsState,
      contractorDetails: contractorDetails ?? this.contractorDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaved: isSaved ?? this.isSaved,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    getContractorDetailsState,
    contractorDetails,
    errorMessage,
    isSaved,
    isConnected,
  ];
}
