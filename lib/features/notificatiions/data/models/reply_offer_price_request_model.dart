import 'dart:io';

import 'package:equatable/equatable.dart';

class ReplyOfferPriceRequestModel extends Equatable {
  final String offerId;
  final String price;
  final String title;
  final String message;
  final File? file;

  const ReplyOfferPriceRequestModel({
    required this.offerId,
    required this.price,
    required this.message,
    required this.title,
    this.file,
  });

  Map<String, dynamic> toJson() => {
    "offer_id": offerId,
    "price": price,
    "title": title,
    "message": message,
  };
  @override
  List<Object?> get props => [offerId, price, title, message, file];
}
