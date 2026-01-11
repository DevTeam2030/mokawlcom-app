import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_model.dart';

class ContractorsModel extends Equatable {
  final List<ContractorModel> contractors;
  final int totalPages;
  final int currentPage;

  const ContractorsModel({
    required this.contractors,
    required this.totalPages,
    required this.currentPage,
  });

  factory ContractorsModel.fromJson(Map<String, dynamic> json) =>
      ContractorsModel(
        contractors: List<ContractorModel>.from(
          (json['contractors'] as List<dynamic>? ?? []).map(
            (x) => ContractorModel.fromJson(x),
          ),
        ),
        totalPages: json['total_pages'] ?? 1,
        currentPage: json['current_page'] ?? 1,
      );
  const ContractorsModel.empty()
    : this(contractors: const [], totalPages: 1, currentPage: 1);

  ContractorsModel copyWith({List<ContractorModel>? contractors}) {
    return ContractorsModel(
      contractors: contractors ?? this.contractors,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }

  @override
  List<Object> get props => [contractors, totalPages, currentPage];
}
