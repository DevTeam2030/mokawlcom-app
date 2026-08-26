import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_attachment_model.dart';

class CustomerDealReplyModel extends Equatable {
  const CustomerDealReplyModel({
    required this.id,
    required this.price,
    required this.message,
    required this.senderType,
    required this.userName,
    required this.contractorId,
    required this.contractorName,
    required this.date,
    required this.time,
    required this.attachments,
  });

  final int id;
  final num price;
  final String message;
  final String senderType;
  final String userName;
  final int? contractorId;
  final String contractorName;
  final String date;
  final String time;
  final List<CustomerDealAttachmentModel> attachments;

  factory CustomerDealReplyModel.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'];
    return CustomerDealReplyModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      price: json['price'] is num
          ? json['price'] as num
          : num.tryParse(json['price']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      contractorId: int.tryParse(json['contractor_id']?.toString() ?? ''),
      contractorName: json['contractor_name']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
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
    price,
    message,
    senderType,
    userName,
    contractorId,
    contractorName,
    date,
    time,
    attachments,
  ];
}
