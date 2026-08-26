import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_replies_model.dart';

class CustomerDealDetailsResponseModel extends Equatable {
  const CustomerDealDetailsResponseModel({
    required this.deal,
    required this.replies,
  });

  final CustomerDealDetailsModel deal;
  final CustomerDealRepliesModel replies;

  factory CustomerDealDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawDeal = json['data'];
    final rawReplies = json['replies'];
    return CustomerDealDetailsResponseModel(
      deal: CustomerDealDetailsModel.fromJson(
        rawDeal is Map ? Map<String, dynamic>.from(rawDeal) : const {},
      ),
      replies: CustomerDealRepliesModel.fromJson(
        rawReplies is Map ? Map<String, dynamic>.from(rawReplies) : const {},
      ),
    );
  }

  @override
  List<Object> get props => [deal, replies];
}
