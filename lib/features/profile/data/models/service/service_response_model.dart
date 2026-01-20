import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';

class ServiceResponseModel extends Equatable {
  final String message;
  final ContractorServiceModel contractorServiceModel;

  const ServiceResponseModel({
    required this.message,
    required this.contractorServiceModel,
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    return ServiceResponseModel(
      message: json['message'],
      contractorServiceModel: ContractorServiceModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }

  @override
  List<Object> get props => [message, contractorServiceModel];
}
