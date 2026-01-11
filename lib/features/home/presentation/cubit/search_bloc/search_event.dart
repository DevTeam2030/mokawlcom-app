part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetContractorsEvent extends SearchEvent {
  final int? classificationId;
  final int? serviceId;
  GetContractorsEvent({this.classificationId, this.serviceId});

  @override
  List<Object?> get props => [classificationId, serviceId];
}

class SearchContractorsEvent extends SearchEvent {
  final String query;
  final int? classificationId;
  final int? serviceId;
  final int page;

  SearchContractorsEvent({
    required this.query,
    this.classificationId,
    this.serviceId,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, classificationId, serviceId, page];
}
class LoadMoreContractorsEvent extends SearchEvent {
  final int? classificationId;
  final int? serviceId;
  final int page;
  final String? query;
  LoadMoreContractorsEvent({this.classificationId, this.serviceId, this.page = 1, this.query});

  @override
  List<Object?> get props => [classificationId, serviceId, page, query];
}