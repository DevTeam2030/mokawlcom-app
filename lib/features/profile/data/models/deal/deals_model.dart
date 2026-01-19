import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';

class DealsModel extends Equatable {
  final int currentPage;
  final int totalPages;
  final List<DealModel> deals;

  const DealsModel({
    required this.currentPage,
    required this.totalPages,
    required this.deals,
  });

  factory DealsModel.fromJson(Map<String, dynamic> json) => DealsModel(
    currentPage: json["current_page"] ?? 0,
    totalPages: json["total_pages"] ?? 0,
    deals: (json["deals"] as List? ?? [])
        .map((e) => DealModel.fromJson(e))
        .toList(),
  );
  const DealsModel.empty()
    : this(currentPage: 0, totalPages: 0, deals: const []);
  DealsModel copyWith({List<DealModel>? deals}) => DealsModel(
    currentPage: currentPage,
    totalPages: totalPages,
    deals: deals ?? this.deals,
  );

  @override
  List<Object> get props => [currentPage, totalPages, deals];
}
