import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/contractor_services_model.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_offers_model.dart';

class UserDetailsState extends Equatable {
  final RequestStatus getUserOffersState;
  final RequestStatus addNewServiceState;
  final UserOffersModel userOffersModel;
  final String errorMessage;
  final String successMessage;
  final int userOffersCurrentPage;
  final int contractorServicesCurrentPage;
  final bool isConnected;
  final RequestStatus getContractorServicesState;
  final ContractorServicesModel contractorServicesModel;
  final List<File> selectedImages;
  final bool isImageLoading;
  final double imageUploadProgress;
  final String imageErrorMessage;
  final int maxImages;
  final int maxSizeInMB;

  const UserDetailsState({
    this.getUserOffersState = RequestStatus.initial,
    this.addNewServiceState = RequestStatus.initial,
    this.userOffersModel = const UserOffersModel.empty(),
    this.errorMessage = '',
    this.successMessage = '',
    this.userOffersCurrentPage = 1,
    this.contractorServicesCurrentPage = 1,
    this.isConnected = true,
    this.getContractorServicesState = RequestStatus.initial,
    this.contractorServicesModel = const ContractorServicesModel.empty(),
    this.selectedImages = const [],
    this.isImageLoading = false,
    this.imageUploadProgress = 0.0,
    this.imageErrorMessage = '',
    this.maxImages = 5,
    this.maxSizeInMB = 10,
  });

  bool get hasReachedMaxImages => selectedImages.length >= maxImages;
  bool get hasImages => selectedImages.isNotEmpty;

  UserDetailsState copyWith({
    RequestStatus? getUserOffersState,
    RequestStatus? addNewServiceState,
    UserOffersModel? userOffersModel,
    String? errorMessage,
    String? successMessage,
    int? userOffersCurrentPage,
    bool? isConnected,
    RequestStatus? getContractorServicesState,
    int? contractorServicesCurrentPage,
    ContractorServicesModel? contractorServicesModel,
    List<File>? selectedImages,
    bool? isImageLoading,
    double? imageUploadProgress,
    String? imageErrorMessage,
    int? maxImages,
    int? maxSizeInMB,
  }) {
    return UserDetailsState(
      getUserOffersState: getUserOffersState ?? this.getUserOffersState,
      addNewServiceState: addNewServiceState ?? this.addNewServiceState,
      userOffersModel: userOffersModel ?? this.userOffersModel,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      userOffersCurrentPage:
          userOffersCurrentPage ?? this.userOffersCurrentPage,
      isConnected: isConnected ?? this.isConnected,
      getContractorServicesState:
          getContractorServicesState ?? this.getContractorServicesState,
      contractorServicesCurrentPage:
          contractorServicesCurrentPage ?? this.contractorServicesCurrentPage,
      contractorServicesModel:
          contractorServicesModel ?? this.contractorServicesModel,
      selectedImages: selectedImages ?? this.selectedImages,
      isImageLoading: isImageLoading ?? this.isImageLoading,
      imageUploadProgress: imageUploadProgress ?? this.imageUploadProgress,
      imageErrorMessage: imageErrorMessage ?? this.imageErrorMessage,
      maxImages: maxImages ?? this.maxImages,
      maxSizeInMB: maxSizeInMB ?? this.maxSizeInMB,
    );
  }

  @override
  List<Object?> get props => [
    getUserOffersState,
    addNewServiceState,
    userOffersModel,
    errorMessage,
    successMessage,
    userOffersCurrentPage,
    isConnected,
    getContractorServicesState,
    contractorServicesCurrentPage,
    contractorServicesModel,
    selectedImages,
    isImageLoading,
    imageUploadProgress,
    imageErrorMessage,
    maxImages,
    maxSizeInMB,
  ];
}
