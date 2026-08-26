import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_category_model.dart';

class ContractorDealModel extends Equatable {
  const ContractorDealModel({
    required this.id,
    required this.title,
    required this.details,
    required this.date,
    required this.time,
    required this.ownerName,
    required this.categories,
    required this.file,
    required this.isPdf,
    required this.repliesCount,
    required this.myReplySent,
  });

  final int id;
  final String title;
  final String details;
  final String date;
  final String time;
  final String ownerName;
  final List<CustomerDealCategoryModel> categories;
  final String file;
  final bool isPdf;
  final int repliesCount;
  final bool myReplySent;

  factory ContractorDealModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    return ContractorDealModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
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
      file: json['file']?.toString() ?? '',
      isPdf: _parseBool(json['is_pdf']),
      repliesCount: int.tryParse(json['replies_count']?.toString() ?? '') ?? 0,
      myReplySent: _parseBool(json['my_reply_sent']),
    );
  }

  static bool _parseBool(dynamic value) {
    final normalized = value?.toString().toLowerCase();
    return value == true || normalized == '1' || normalized == 'true';
  }

  @override
  List<Object> get props => [
    id,
    title,
    details,
    date,
    time,
    ownerName,
    categories,
    file,
    isPdf,
    repliesCount,
    myReplySent,
  ];
}
