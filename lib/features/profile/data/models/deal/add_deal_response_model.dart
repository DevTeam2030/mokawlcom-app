import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';

class AddDealResponseModel extends Equatable {

  final String message;
  final DealModel dealModel;

  const AddDealResponseModel({
    required this.dealModel,
    required this.message,
  });

  factory AddDealResponseModel.fromJson(Map<String, dynamic> json) {
    return AddDealResponseModel(
      dealModel: DealModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
  @override
  List<Object> get props => [dealModel, message];
}
