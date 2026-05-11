import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';

class ContractorServicesModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final List<ContractorServiceModel> services;

  const ContractorServicesModel({
    required this.currentPage,
    required this.totalPages,
    required this.services,
  });

  factory ContractorServicesModel.fromJson(Map<String, dynamic> json) =>
      ContractorServicesModel(
        currentPage: json["current_page"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
        services: (json["services"] as List<dynamic>? ?? [])
            .map(
              (e) => ContractorServiceModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
  const ContractorServicesModel.empty()
    : this(currentPage: 0, totalPages: 0, services: const []);

  ContractorServicesModel copyWith({List<ContractorServiceModel>? services}) {
    return ContractorServicesModel(
      currentPage: currentPage,
      totalPages: totalPages,
      services: services ?? this.services,
    );
  }

  @override
  List<Object> get props => [currentPage, totalPages, services];
}
