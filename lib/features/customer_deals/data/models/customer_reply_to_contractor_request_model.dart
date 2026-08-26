import 'package:equatable/equatable.dart';

class CustomerReplyToContractorRequestModel extends Equatable {
  const CustomerReplyToContractorRequestModel({
    required this.dealId,
    required this.contractorId,
    required this.price,
    required this.message,
    required this.filePaths,
  });

  final int dealId;
  final int contractorId;
  final String price;
  final String message;
  final List<String> filePaths;

  @override
  List<Object> get props => [dealId, contractorId, price, message, filePaths];
}
