import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/notificatiions/data/data_source/notifications_data_source.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/repo/notifications_repo.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notifications_model.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsDataSource notificationsDataSource;

  NotificationsRepoImpl({required this.notificationsDataSource});

  @override
  Future<Either<Failure, PublicNotificationsModel>> getPublicNotifications({
    required int page,
  }) async => await safeApiCall(
    () async =>
        await notificationsDataSource.getPublicNotifications(page: page),
  );

  @override
  Future<Either<Failure, OfferNotificationsModel>> getOfferNotifications({
    required int page,
  }) async => await safeApiCall(
    () async => await notificationsDataSource.getOfferNotifications(page: page),
  );

  @override
  Future<Either<Failure, OfferDetailsModel>> getOfferDetails({
    required int page,
    required int offerId,
  }) async => await safeApiCall(
    () async => await notificationsDataSource.getOfferDetails(
      page: page,
      offerId: offerId,
    ),
  );

  @override
  Future<Either<Failure, String>> replyOnOfferPrice({
    required ReplyOfferPriceRequestModel replyOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  }) async => await safeApiCall(
    () async => await notificationsDataSource.replyOnOfferPrice(
      replyOfferPriceRequestModel: replyOfferPriceRequestModel,
      onProgress: onProgress,
    ),
  );
}
