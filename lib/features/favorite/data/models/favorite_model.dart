import 'package:equatable/equatable.dart';

class FavoriteModel extends Equatable {
  final int id;
  final int contractorId;
  final String companyName;
  final String address;
  final String logo;
  final num rate;

  const FavoriteModel({
    required this.contractorId,
    required this.companyName,
    required this.address,
    required this.logo,
    required this.rate,
    required this.id,
  });
  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    id: json["id"] ?? 0,
    contractorId: json["contractor_id"] ?? 0,
    address: json["address"] ?? "",
    companyName: json["company_name"] ?? "",
    rate: json["rate"] ?? 0,
    logo: json["logo"] ?? "",
  );

  @override
  List<Object> get props => [companyName, address, logo, rate, contractorId];
}
