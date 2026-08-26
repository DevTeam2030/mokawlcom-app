import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deal_model.dart';

class ContractorDealsModel extends Equatable {
  const ContractorDealsModel({
    required this.deals,
    required this.totalPages,
    required this.currentPage,
  });

  final List<ContractorDealModel> deals;
  final int totalPages;
  final int currentPage;

  factory ContractorDealsModel.fromJson(Map<String, dynamic> json) {
    final rawDeals = json['deals'];
    return ContractorDealsModel(
      deals: rawDeals is List
          ? rawDeals
                .whereType<Map>()
                .map(
                  (deal) => ContractorDealModel.fromJson(
                    Map<String, dynamic>.from(deal),
                  ),
                )
                .toList(growable: false)
          : const [],
      totalPages: int.tryParse(json['total_pages']?.toString() ?? '') ?? 0,
      currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 0,
    );
  }

  @override
  List<Object> get props => [deals, totalPages, currentPage];
}
