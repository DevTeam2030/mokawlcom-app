import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/home/data/models/add_offer_price_request_model.dart';
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
  Future<void> rateContractor({
    required String contractorId,
    required String rating,
  });
  Future<String> addOfferPrice({
    required AddOfferPriceRequestModel addOfferPriceRequestModel,
    required void Function(double progress) onProgress,
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
      return ContractorsModel.fromJson(result.data["data"] ?? {});
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
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      queryParameters: {"contractor_id": contractorId},
    );
    if (result.statusCode == 200) {
      return ContractorDetailsModel.fromJson(result.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }

  @override
  Future<void> rateContractor({
    required String contractorId,
    required String rating,
  }) async {
    final result = await dioHelper.post(
      url: ApiConstants.rateContractor,
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      data: {"contractor_id": contractorId, "rate": rating},
    );
    if (result.statusCode == 200) {
      return;
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }

  @override
  Future<String> addOfferPrice({
    required AddOfferPriceRequestModel addOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap(addOfferPriceRequestModel.toJson());

    if (addOfferPriceRequestModel.file != null) {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            addOfferPriceRequestModel.file!.path,
            filename: addOfferPriceRequestModel.file!.path.split('/').last,
          ),
        ),
      );
    }

    final result = await dioHelper.post(
      url: ApiConstants.addOfferPrice,
      headers: {
        "Authorization": "Bearer ${AppConstants.token}",
        "Accept": "application/json",
      },
      data: formData,
      onSendProgress: (sent, total) {
        if (total != 0) onProgress(sent / total);
      },
    );

    if (result.statusCode == 200 || result.statusCode == 201) {
      return result.data["message"] ?? "";
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }
}
