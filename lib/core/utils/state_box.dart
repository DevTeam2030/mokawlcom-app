import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';

class StateBox<T> extends Equatable {
  final RequestStatus requestState; 
  final T? data;
  final String errorMessage;

  const StateBox({
    required this.requestState,
    this.data,
    this.errorMessage = "",
  });

  bool get isInitial => requestState == RequestStatus.initial;

  bool get isLoading => requestState == RequestStatus.loading;

  bool get isSuccess => requestState == RequestStatus.success;

  bool get isError => requestState == RequestStatus.error;

  const StateBox.initial() : this(requestState: RequestStatus.initial);

  const StateBox.loading() : this(requestState: RequestStatus.loading);

  const StateBox.success({required T data})
    : this(requestState: RequestStatus.success, data: data);

  const StateBox.error({required String errorMessage})
    : this(
        requestState: RequestStatus.error,
        errorMessage: errorMessage,
      );
  const StateBox.errorWithOldData({required String errorMessage, required T oldData})
    : this(
        requestState: RequestStatus.error,
        errorMessage: errorMessage,
        data: oldData,
      );


  @override
  List<Object?> get props => [requestState, data, errorMessage];
}
