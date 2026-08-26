import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_reply_model.dart';

class CustomerDealRepliesModel extends Equatable {
  const CustomerDealRepliesModel({
    required this.replies,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  const CustomerDealRepliesModel.empty()
    : replies = const [],
      currentPage = 0,
      totalPages = 0,
      totalItems = 0;

  final List<CustomerDealReplyModel> replies;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  factory CustomerDealRepliesModel.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['list'];
    return CustomerDealRepliesModel(
      replies: rawReplies is List
          ? rawReplies
                .whereType<Map>()
                .map(
                  (reply) => CustomerDealReplyModel.fromJson(
                    Map<String, dynamic>.from(reply),
                  ),
                )
                .toList(growable: false)
          : const [],
      currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 0,
      totalPages: int.tryParse(json['total_pages']?.toString() ?? '') ?? 0,
      totalItems: int.tryParse(json['total_items']?.toString() ?? '') ?? 0,
    );
  }

  @override
  List<Object> get props => [replies, currentPage, totalPages, totalItems];
}
