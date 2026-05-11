part of 'contractor_info_cubit.dart';

class ContractorInfoState extends Equatable {
  final RequestStatus getContractorDetailsState;
  final RequestStatus rateContractorState;
  final RequestStatus addOfferPriceState;
  final String addOfferPriceMessage;
  final bool isFileLoading;
  final double progress;
  final File? file;

  final ContractorDetailsModel contractorDetails;
  final String errorMessage;
  final bool isSaved;
  final double rating;
  final bool isConnected;

  const ContractorInfoState({
    this.getContractorDetailsState = RequestStatus.initial,
    this.rateContractorState = RequestStatus.initial,
    this.addOfferPriceState = RequestStatus.initial,
    this.addOfferPriceMessage = '',
    this.isFileLoading = false,
    this.progress = 0,
    this.file,
    this.contractorDetails = const ContractorDetailsModel.empty(),
    this.errorMessage = "",
    this.isSaved = false,
    this.rating = 0,
    this.isConnected = true,
  });

  ContractorInfoState copyWith({
    RequestStatus? getContractorDetailsState,
    RequestStatus? rateContractorState,
    RequestStatus? addOfferPriceState,
    String? addOfferPriceMessage,
    bool? isFileLoading,
    double? progress,
    File? file,
    ContractorDetailsModel? contractorDetails,
    String? errorMessage,
    bool? isSaved,
    double? rating,
    bool? isConnected,
    bool clearFile = false,
  }) {
    return ContractorInfoState(
      getContractorDetailsState:
          getContractorDetailsState ?? this.getContractorDetailsState,
      rateContractorState: rateContractorState ?? this.rateContractorState,
      addOfferPriceState: addOfferPriceState ?? this.addOfferPriceState,
      addOfferPriceMessage: addOfferPriceMessage ?? this.addOfferPriceMessage,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      progress: progress ?? this.progress,
      file: clearFile ? null : file ?? this.file,
      contractorDetails: contractorDetails ?? this.contractorDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaved: isSaved ?? this.isSaved,
      rating: rating ?? this.rating,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    getContractorDetailsState,
    rateContractorState,
    addOfferPriceState,
    addOfferPriceMessage,
    isFileLoading,
    progress,
    file,
    contractorDetails,
    errorMessage,
    isSaved,
    rating,
    isConnected,
  ];
}
