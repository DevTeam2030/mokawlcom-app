import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_attachment_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_category_model.dart';

class CustomerDealModel extends Equatable {
  const CustomerDealModel({
    required this.id,
    required this.title,
    required this.details,
    required this.date,
    required this.time,
    required this.categories,
    required this.repliesCount,
    this.attachments = const [],
  });

  final int id;
  final String title;
  final String details;
  final String date;
  final String time;
  final List<CustomerDealCategoryModel> categories;
  final int? repliesCount;
  final List<CustomerDealAttachmentModel> attachments;

  factory CustomerDealModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    final rawAttachments = json['attachments'];
    return CustomerDealModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      categories: rawCategories is List
          ? rawCategories
                .whereType<Map>()
                .map(
                  (category) => CustomerDealCategoryModel.fromJson(
                    Map<String, dynamic>.from(category),
                  ),
                )
                .toList(growable: false)
          : const [],
      repliesCount: int.tryParse(json['replies_count']?.toString() ?? ''),
      attachments: rawAttachments is List
          ? rawAttachments
                .whereType<Map>()
                .map(
                  (attachment) => CustomerDealAttachmentModel.fromJson(
                    Map<String, dynamic>.from(attachment),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    details,
    date,
    time,
    categories,
    repliesCount,
    attachments,
  ];
}
