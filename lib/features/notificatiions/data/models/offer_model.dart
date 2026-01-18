import 'package:equatable/equatable.dart';

class OfferModel extends Equatable {
  final int id;
  final int offerId;
  final String title;
  final String message;
  final String date;
  final String time;
  final bool status;
  final bool isPdf;
  final String url;
  final String offerUserName;
  final num price;

  const OfferModel({
    required this.id,
    required this.offerId,
    required this.title,
    required this.message,
    required this.date,
    required this.time,
    required this.status,
    required this.offerUserName,
    required this.price,
    required this.isPdf,
    required this.url,
  });
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json["id"] ?? 0,
      offerId: json["offer_id"] ?? 0,
      title: json["title_offer"] ?? "",
      message: json["message"] ?? "",
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      status: json["status"] ?? false,
      offerUserName: json["offer_user_name"] ?? "",
      isPdf: json["is_pdf"] ?? false,
      url: json["file"] ?? "",
      price: json["price"] ?? 0,
    );
  }
  @override
  List<Object> get props => [
    id,
    offerId,
    title,
    message,
    date,
    time,
    offerUserName,
    isPdf,
    url,
    price,
  ];
}
