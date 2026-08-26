import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_response_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_reply_to_contractor_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deals_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/initial_deal_reply_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/update_customer_deal_request_model.dart';

abstract class CustomerDealsDataSource {
  Future<AddCustomerDealResponseModel> addCustomerDeal({
    required AddCustomerDealRequestModel request,
  });

  Future<AddCustomerDealResponseModel> updateCustomerDeal({
    required UpdateCustomerDealRequestModel request,
  });

  Future<AddCustomerDealResponseModel> submitInitialReply({
    required InitialDealReplyRequestModel request,
  });

  Future<AddCustomerDealResponseModel> replyToContractor({
    required CustomerReplyToContractorRequestModel request,
  });

  Future<String> deleteCustomerDeal({required int dealId});

  Future<String> deleteDealAttachment({required int attachmentId});

  Future<ContractorDealsModel> getContractorDeals({required int page});

  Future<CustomerDealsModel> getMyDeals({required int page});

  Future<CustomerDealDetailsResponseModel> getMyDealDetails({
    required int dealId,
    int page = 1,
  });
}

class CustomerDealsDataSourceImpl implements CustomerDealsDataSource {
  CustomerDealsDataSourceImpl({required this.dioHelper});

  final DioHelper dioHelper;

  @override
  Future<AddCustomerDealResponseModel> addCustomerDeal({
    required AddCustomerDealRequestModel request,
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('title', request.title),
      MapEntry('details', request.details),
      for (var index = 0; index < request.categoryIds.length; index++)
        MapEntry('category_ids[$index]', request.categoryIds[index].toString()),
    ]);

    await _addFiles(formData, request.files);

    final response = await dioHelper.post(
      url: ApiConstants.addUserDeal,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
      },
      data: formData,
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};

    final parsedResponse = AddCustomerDealResponseModel.fromJson(responseData);
    if (response.statusCode == 200 && parsedResponse.status == 200) {
      return parsedResponse;
    }

    throw ServerException(errorMessage: parsedResponse.message);
  }

  @override
  Future<AddCustomerDealResponseModel> updateCustomerDeal({
    required UpdateCustomerDealRequestModel request,
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('id', request.id.toString()),
      MapEntry('title', request.title),
      MapEntry('details', request.details),
      for (var index = 0; index < request.categoryIds.length; index++)
        MapEntry('category_ids[$index]', request.categoryIds[index].toString()),
    ]);

    await _addFiles(formData, request.newFiles);

    final response = await dioHelper.post(
      url: ApiConstants.updateUserDeal,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
      },
      data: formData,
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final parsedResponse = AddCustomerDealResponseModel.fromJson(responseData);

    if (response.statusCode == 200 && parsedResponse.status == 200) {
      return parsedResponse;
    }
    throw ServerException(errorMessage: parsedResponse.message);
  }

  @override
  Future<AddCustomerDealResponseModel> submitInitialReply({
    required InitialDealReplyRequestModel request,
  }) async {
    final formData = FormData.fromMap({
      'deal_id': request.dealId.toString(),
      'price': request.price,
      'message': request.message,
    });
    await _addFiles(formData, request.files);

    final response = await dioHelper.post(
      url: ApiConstants.replyDeal,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
      },
      data: formData,
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final parsedResponse = AddCustomerDealResponseModel.fromJson(responseData);
    final hasResponseStatus = responseData.containsKey('status');

    if (response.statusCode == 200 &&
        (!hasResponseStatus || parsedResponse.status == 200)) {
      return parsedResponse;
    }
    throw ServerException(errorMessage: parsedResponse.message);
  }

  @override
  Future<AddCustomerDealResponseModel> replyToContractor({
    required CustomerReplyToContractorRequestModel request,
  }) async {
    final price = request.price.trim();
    final fields = <String, dynamic>{
      'deal_id': request.dealId.toString(),
      'contractor_id': request.contractorId.toString(),
      'message': request.message.trim(),
    };
    if (price.isNotEmpty) fields['price'] = price;
    final formData = FormData.fromMap(fields);
    await _addFilePaths(formData, request.filePaths);

    final response = await dioHelper.post(
      url: ApiConstants.replyToContractor,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
      },
      data: formData,
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final parsedResponse = AddCustomerDealResponseModel.fromJson(responseData);
    final hasResponseStatus = responseData.containsKey('status');

    if (response.statusCode == 200 &&
        (!hasResponseStatus || parsedResponse.status == 200)) {
      return parsedResponse;
    }
    throw ServerException(errorMessage: parsedResponse.message);
  }

  @override
  Future<String> deleteCustomerDeal({required int dealId}) async {
    final response = await dioHelper.post(
      url: ApiConstants.deleteUserDeal,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
      },
      data: {'id': dealId},
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final responseStatus = int.tryParse(
      responseData['status']?.toString() ?? '',
    );
    final message = responseData['message']?.toString() ?? '';

    final hasResponseStatus = responseData.containsKey('status');
    if (response.statusCode == 200 &&
        (!hasResponseStatus || responseStatus == 200)) {
      return message;
    }
    throw ServerException(errorMessage: message);
  }

  @override
  Future<String> deleteDealAttachment({required int attachmentId}) async {
    final response = await dioHelper.post(
      url: ApiConstants.deleteDealAttachment,
      headers: {
        'Authorization': 'Bearer ${AppConstants.token}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      data: {'id': attachmentId},
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final responseStatus = int.tryParse(
      responseData['status']?.toString() ?? '',
    );
    final message = responseData['message']?.toString() ?? '';

    final hasResponseStatus = responseData.containsKey('status');
    if (response.statusCode == 200 &&
        (!hasResponseStatus || responseStatus == 200)) {
      return message;
    }
    throw ServerException(errorMessage: message);
  }

  @override
  Future<ContractorDealsModel> getContractorDeals({required int page}) async {
    final response = await dioHelper.get(
      url: ApiConstants.contractorDeals,
      queryParameters: {'page': page},
      headers: {'Authorization': 'Bearer ${AppConstants.token}'},
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};

    if (response.statusCode == 200) {
      final data = responseData['data'];
      return ContractorDealsModel.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : const {},
      );
    }
    throw ServerException(
      errorMessage: responseData['message']?.toString() ?? '',
    );
  }

  @override
  Future<CustomerDealsModel> getMyDeals({required int page}) async {
    final response = await dioHelper.get(
      url: ApiConstants.myDeals,
      queryParameters: {'page': page},
      headers: {'Authorization': 'Bearer ${AppConstants.token}'},
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};

    if (response.statusCode == 200) {
      final data = responseData['data'];
      return CustomerDealsModel.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : const {},
      );
    }

    throw ServerException(
      errorMessage: responseData['message']?.toString() ?? '',
    );
  }

  @override
  Future<CustomerDealDetailsResponseModel> getMyDealDetails({
    required int dealId,
    int page = 1,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.myDealDetails,
      queryParameters: {'id': dealId},
      headers: {'Authorization': 'Bearer ${AppConstants.token}'},
    );
    final responseData = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};

    if (response.statusCode == 200) {
      final parsedResponse = CustomerDealDetailsResponseModel.fromJson(
        responseData,
      );
      return parsedResponse;
    }

    throw ServerException(
      errorMessage: responseData['message']?.toString() ?? '',
    );
  }

  Future<void> _addFiles(FormData formData, List<File> files) async {
    await _addFilePaths(
      formData,
      files.map((file) => file.path).toList(growable: false),
    );
  }

  Future<void> _addFilePaths(FormData formData, List<String> filePaths) async {
    for (var index = 0; index < filePaths.length; index++) {
      final file = File(filePaths[index]);
      final fileName = file.uri.pathSegments.isEmpty
          ? file.path
          : file.uri.pathSegments.last;
      formData.files.add(
        MapEntry(
          'files[$index]',
          await MultipartFile.fromFile(file.path, filename: fileName),
        ),
      );
    }
  }
}
