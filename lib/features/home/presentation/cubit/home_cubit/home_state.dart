import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classifications_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/services_model.dart';

class HomeState extends Equatable {
  final RequestStatus getBannersState;
  final RequestStatus addOfferPriceState;
  final File? file;
  final String addOfferPriceMessage;
  final List<String> banners;
  final String bannersErrorMessage;
  final RequestStatus getClassificationsState;
  final ClassificationsModel classificationsModel;
  final String classificationsErrorMessage;
  final int classificationsPage;
  final int classificationsTotalPages;
  final RequestStatus getServicesState;
  final ServicesModel servicesModel;
  final String servicesErrorMessage;
  final int servicesPage;
  final int servicesTotalPages;
  final bool isFileLoading;
  final double progress;
  final bool isConnected;

  const HomeState({
    this.getBannersState = RequestStatus.initial,
    this.getClassificationsState = RequestStatus.initial,
    this.classificationsModel = const ClassificationsModel.empty(),
    this.banners = const [],
    this.bannersErrorMessage = '',
    this.classificationsErrorMessage = '',
    this.classificationsPage = 1,
    this.classificationsTotalPages = 1,
    this.getServicesState = RequestStatus.initial,
    this.servicesModel = const ServicesModel.empty(),
    this.servicesErrorMessage = '',
    this.servicesPage = 1,
    this.servicesTotalPages = 1,
    this.file,
    this.addOfferPriceState = RequestStatus.initial,
    this.addOfferPriceMessage = '',
    this.isFileLoading = false,
    this.progress = 0,
    this.isConnected = true,
  });

  HomeState copyWith({
    RequestStatus? getBannersState,
    RequestStatus? getClassificationsState,
    ClassificationsModel? classificationsModel,
    List<String>? banners,
    String? bannersErrorMessage,
    String? classificationsErrorMessage,
    int? classificationsPage,
    int? classificationsTotalPages,
    RequestStatus? getServicesState,
    ServicesModel? servicesModel,
    String? servicesErrorMessage,
    int? servicesPage,
    int? servicesTotalPages,
    File? file,
    RequestStatus? addOfferPriceState,
    String? addOfferPriceMessage,
    bool? isFileLoading,
    double? progress,
    bool? isConnected,
  }) {
    return HomeState(
      getBannersState: getBannersState ?? this.getBannersState,
      getClassificationsState:
          getClassificationsState ?? this.getClassificationsState,
      classificationsModel: classificationsModel ?? this.classificationsModel,
      banners: banners ?? this.banners,
      bannersErrorMessage: bannersErrorMessage ?? this.bannersErrorMessage,
      classificationsErrorMessage: classificationsErrorMessage ?? this.classificationsErrorMessage,
      classificationsPage: classificationsPage ?? this.classificationsPage,
      classificationsTotalPages: classificationsTotalPages ?? this.classificationsTotalPages,
      getServicesState: getServicesState ?? this.getServicesState,
      servicesModel: servicesModel ?? this.servicesModel,
      servicesErrorMessage: servicesErrorMessage ?? this.servicesErrorMessage,
      servicesPage: servicesPage ?? this.servicesPage,
      servicesTotalPages: servicesTotalPages ?? this.servicesTotalPages,
      file: file ?? this.file,
      addOfferPriceState: addOfferPriceState ?? this.addOfferPriceState,
      addOfferPriceMessage: addOfferPriceMessage ?? this.addOfferPriceMessage,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      progress: progress ?? this.progress,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [
    getBannersState,
    getClassificationsState,
    classificationsModel,
    banners,
    bannersErrorMessage,
    classificationsErrorMessage,
    classificationsPage,
    classificationsTotalPages,  
    getServicesState,
    servicesModel,
    servicesErrorMessage,
    servicesPage,
    servicesTotalPages,
    file,
    addOfferPriceState,
    addOfferPriceMessage,
    isFileLoading,
    progress,
    isConnected,
  ];
}
