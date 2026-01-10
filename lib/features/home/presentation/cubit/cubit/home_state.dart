import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';

class HomeState extends Equatable {
  final RequestStatus getBannersState;
  final List<String> banners;
  final String bannersErrorMessage;
  final RequestStatus getClassificationsState;
  final List<ClassificationModel> classifications;
  final String classificationsErrorMessage;
  final bool isConnected;

  const HomeState({
    this.getBannersState = RequestStatus.initial,
    this.getClassificationsState = RequestStatus.initial,
    this.classifications = const [],
    this.banners = const [],
    this.bannersErrorMessage = '',
    this.classificationsErrorMessage = '',
    this.isConnected = true,
  });

  HomeState copyWith({
    RequestStatus? getBannersState,
    RequestStatus? getClassificationsState,
    List<ClassificationModel>? classifications,
    List<String>? banners,
    String? bannersErrorMessage,
    String? classificationsErrorMessage,
    bool? isConnected,
  }) {
    return HomeState(
      getBannersState: getBannersState ?? this.getBannersState,
      getClassificationsState:
          getClassificationsState ?? this.getClassificationsState,
      classifications: classifications ?? this.classifications,
      banners: banners ?? this.banners,
      bannersErrorMessage: bannersErrorMessage ?? this.bannersErrorMessage,
      classificationsErrorMessage: classificationsErrorMessage ?? this.classificationsErrorMessage,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    getBannersState,
    getClassificationsState,
    classifications,
    banners,
    bannersErrorMessage,
    classificationsErrorMessage,
    isConnected,
  ];
}
