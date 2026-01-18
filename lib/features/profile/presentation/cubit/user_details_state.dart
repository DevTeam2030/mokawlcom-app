import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_offers_model.dart';

class UserDetailsState extends Equatable {
  final RequestStatus getUserOffersState;
  final UserOffersModel userOffersModel;
  final String errorMessage;
  final int userOffersCurrentPage;
  final int contractorServicesCurrentPage;
  final bool isConnected;
  final RequestStatus getContractorServicesState;
  final ContractorServicesModel contractorServicesModel;

  const UserDetailsState({
    this.getUserOffersState = RequestStatus.initial,
    this.userOffersModel = const UserOffersModel.empty(),
    this.errorMessage = '',
    this.userOffersCurrentPage = 1,
    this.contractorServicesCurrentPage = 1,
    this.isConnected = true,
    this.getContractorServicesState = RequestStatus.initial,
    this.contractorServicesModel = const ContractorServicesModel.empty(),
  });

  UserDetailsState copyWith({
    RequestStatus? getUserOffersState,
    UserOffersModel? userOffersModel,
    String? errorMessage,
    int? userOffersCurrentPage,
    bool? isConnected,
    RequestStatus? getContractorServicesState,
    int? contractorServicesCurrentPage,
    ContractorServicesModel? contractorServicesModel,
  }) {
    return UserDetailsState(
      getUserOffersState: getUserOffersState ?? this.getUserOffersState,
      userOffersModel: userOffersModel ?? this.userOffersModel,
      errorMessage: errorMessage ?? this.errorMessage,
      userOffersCurrentPage:
          userOffersCurrentPage ?? this.userOffersCurrentPage,
      isConnected: isConnected ?? this.isConnected,
      getContractorServicesState:
          getContractorServicesState ?? this.getContractorServicesState,
      contractorServicesCurrentPage:
          contractorServicesCurrentPage ?? this.contractorServicesCurrentPage,
      contractorServicesModel:
          contractorServicesModel ?? this.contractorServicesModel,
    );
  }

  @override
  List<Object> get props => [
    getUserOffersState,
    userOffersModel,
    errorMessage,
    userOffersCurrentPage,
    isConnected,
    getContractorServicesState,
    contractorServicesCurrentPage,
    contractorServicesModel,
  ];
}
