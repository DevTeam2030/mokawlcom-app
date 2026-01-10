import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';

class ServicesModel extends Equatable {
  final int totalPages;
  final int currentPage;
  final List<ServiceModel> services;

  const ServicesModel({
    required this.totalPages,
    required this.currentPage,
    required this.services,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
    totalPages: json["data"]?["total_pages"],
    currentPage: json["data"]?["current_page"],
    services: List<ServiceModel>.from(
      (json["data"]?["categories"] as List<dynamic>? ?? []).map(
        (x) => ServiceModel.fromJson(x),
      ),
    ),
  );
  const ServicesModel.empty() : this(
    totalPages: 0,
    currentPage: 0,
    services: const [],
  );

  ServicesModel copyWith({
    List<ServiceModel>? services,
  }) {
    return ServicesModel(
      totalPages: totalPages ,
      currentPage: currentPage ,
      services: services ?? this.services,
    );
  }

  @override
  List<Object> get props => [totalPages, currentPage, services];
}
