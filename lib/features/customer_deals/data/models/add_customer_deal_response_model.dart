import 'package:equatable/equatable.dart';

class AddCustomerDealResponseModel extends Equatable {
  const AddCustomerDealResponseModel({
    required this.status,
    required this.message,
    this.dealId,
    this.title = '',
  });

  final int status;
  final String message;
  final int? dealId;
  final String title;

  factory AddCustomerDealResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : const <String, dynamic>{};

    return AddCustomerDealResponseModel(
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      dealId: int.tryParse(data['id']?.toString() ?? ''),
      title: data['title']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [status, message, dealId, title];
}
