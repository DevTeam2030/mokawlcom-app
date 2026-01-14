import 'package:equatable/equatable.dart';

class OfferNotificationModel extends Equatable {
  final int id;
  final int offerId;
  final String title;
  final String body;
  final String date;
  final String time;
  final bool status;
  final String offerUserName;

  const OfferNotificationModel({
    required this.id,
    required this.offerId,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    required this.status,
    required this.offerUserName,
  });
  factory OfferNotificationModel.fromJson(Map<String, dynamic> json) {
    return OfferNotificationModel(
      id: json["id"] ?? 0,
      offerId: json["offer_id"] ?? 0,
      title: json["not_title"] ?? "",
      body: json["message"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? false,
      offerUserName: json["offer_user_name"] ?? "",
    );
  }
  @override
  List<Object> get props => [
    id,
    offerId,
    title,
    body,
    date,
    time,
    offerUserName,
  ];
}
