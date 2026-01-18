import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/profile/data/models/user_offers_model.dart';

class UserDetailsState extends Equatable {
  final RequestStatus getUserOffersState;
  final UserOffersModel userOffersModel;
  final String errorMessage;
  final int page;
  final bool isConnected;
  const UserDetailsState({
    this.getUserOffersState = RequestStatus.initial,
    this.userOffersModel = const UserOffersModel.empty(),
    this.errorMessage = '',
    this.page = 1,
    this.isConnected = true,
  });

  UserDetailsState copyWith({
    RequestStatus? getUserOffersState,
    UserOffersModel? userOffersModel,
    String? errorMessage,
    int? page,
    bool? isConnected,
  }) {
    return UserDetailsState(
      getUserOffersState: getUserOffersState ?? this.getUserOffersState,
      userOffersModel: userOffersModel ?? this.userOffersModel,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object> get props => [
    getUserOffersState,
    userOffersModel,
    errorMessage,
    page,
    isConnected,
  ];
}
