import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';

class CustomerDealsModel extends Equatable {
  const CustomerDealsModel({
    required this.deals,
    required this.totalPages,
    required this.currentPage,
  });

  const CustomerDealsModel.empty()
    : deals = const [],
      totalPages = 0,
      currentPage = 0;

  final List<CustomerDealModel> deals;
  final int totalPages;
  final int currentPage;

  factory CustomerDealsModel.fromJson(Map<String, dynamic> json) {
    final rawDeals = json['deals'];
    final deals = rawDeals is List
        ? rawDeals
              .whereType<Map>()
              .map(
                (deal) =>
                    CustomerDealModel.fromJson(Map<String, dynamic>.from(deal)),
              )
              .toList(growable: false)
        : const <CustomerDealModel>[];

    return CustomerDealsModel(
      deals: deals,
      totalPages: int.tryParse(json['total_pages']?.toString() ?? '') ?? 0,
      currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 0,
    );
  }

  @override
  List<Object> get props => [deals, totalPages, currentPage];
}
