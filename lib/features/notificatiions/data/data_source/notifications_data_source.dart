import 'package:dio/dio.dart';
import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_on_offer_response_model.dart';

abstract class NotificationsDataSource {
  Future<PublicNotificationsModel> getPublicNotifications({required int page});
  Future<OfferNotificationsModel> getOfferNotifications({required int page});
  Future<OfferDetailsModel> getOfferDetails({
    required int page,
    required int offerId,
  });
  Future<ReplyOnOfferResponseModel> replyOnOfferPrice({
    required ReplyOfferPriceRequestModel replyOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  });
}

class NotificationsDataSourceImpl implements NotificationsDataSource {
  final DioHelper dioHelper;

  NotificationsDataSourceImpl({required this.dioHelper});

  @override
  Future<PublicNotificationsModel> getPublicNotifications({
    required int page,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.getPublicNotifications,
      queryParameters: {"page": page},
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200) {
      return PublicNotificationsModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<OfferNotificationsModel> getOfferNotifications({
    required int page,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.getOfferNotifications,
      queryParameters: {"page": page},
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200) {
      return OfferNotificationsModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<OfferDetailsModel> getOfferDetails({
    required int page,
    required int offerId,
  }) async {
    final response = await dioHelper.get(
      url: ApiConstants.getOfferDetails,
      queryParameters: {"page": page, "id": offerId},
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
    );
    if (response.statusCode == 200) {
      return OfferDetailsModel.fromJson(response.data["replies"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }

  @override
  Future<ReplyOnOfferResponseModel> replyOnOfferPrice({
    required ReplyOfferPriceRequestModel replyOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  }) async {
    final formData = FormData.fromMap(replyOfferPriceRequestModel.toJson());

    if (replyOfferPriceRequestModel.file != null) {
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            replyOfferPriceRequestModel.file!.path,
            filename: replyOfferPriceRequestModel.file!.path.split('/').last,
          ),
        ),
      );
    }

    final result = await dioHelper.post(
      url: ApiConstants.replayOfferPrice,
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
      return ReplyOnOfferResponseModel.fromJson(result.data ?? {});
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }
}
