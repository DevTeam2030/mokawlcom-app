import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';

class ReplyOnOfferResponseModel extends Equatable {
  final String message;
  final OfferModel offerModel;

  const ReplyOnOfferResponseModel({
    required this.message,
    required this.offerModel,
  });

  factory ReplyOnOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return ReplyOnOfferResponseModel(
      message: json["message"] ?? "",
      offerModel: OfferModel.fromJson(json["data"] ?? {}),
    );
  }

  @override
  List<Object> get props => [message, offerModel];
}
