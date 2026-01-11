import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/data/models/contractors_model.dart';

abstract class HomeDataSource {
  Future<List<String>> getBanners();
  Future<ContractorsModel> getContractors({
    required int page,
    int? classification,
    int? service,
    String? search,
  });
  Future<ContractorDetailsModel> getContractorDetails({
    required int contractorId,
  });
}

class HomeDataSourceImpl implements HomeDataSource {
  final DioHelper dioHelper;
  HomeDataSourceImpl({required this.dioHelper});
  @override
  Future<List<String>> getBanners() async {
    final result = await dioHelper.get(url: ApiConstants.getBanners);
    if (result.statusCode == 200) {
      return List<String>.from(
        result.data["data"]?.map((x) => x["image"]) ?? [],
      );
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }

  @override
  Future<ContractorsModel> getContractors({
    required int page,
    int? classification,
    int? service,
    String? search,
  }) async {
    final Map<String, dynamic> queryParameters = {"page": page};
    if (search != null) {
      queryParameters["search"] = search;
    }
    if (classification != null) {
      queryParameters["category_id"] = classification;
    }
    if (service != null) {
      queryParameters["sub_category_id"] = service;
    }

    final result = await dioHelper.get(
      url: ApiConstants.getContractors,
      queryParameters: queryParameters,
    );
    if (result.statusCode == 200) {
      return ContractorsModel.fromJson(result.data["data"]??{});
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }
  @override
  Future<ContractorDetailsModel> getContractorDetails({
    required int contractorId,
  }) async {
    final result = await dioHelper.get(
      url: ApiConstants.getContractorInfo,
      queryParameters: {"contractor_id": contractorId},
    );
    if (result.statusCode == 200) {
      return ContractorDetailsModel.fromJson(result.data["data"]??{});
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }
}
