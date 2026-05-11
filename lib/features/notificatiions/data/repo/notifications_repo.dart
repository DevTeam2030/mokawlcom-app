import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_details_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notifications_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_offer_price_request_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/reply_on_offer_response_model.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/user_offers_model.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, PublicNotificationsModel>> getPublicNotifications({
    required int page,
  });
  Future<Either<Failure, OfferNotificationsModel>> getOfferNotifications({
    required int page,
  });
  Future<Either<Failure, OfferDetailsModel>> getOfferDetails({
    required int page,
    required int offerId,
  });
  Future<Either<Failure, ReplyOnOfferResponseModel>> replyOnOfferPrice({
    required ReplyOfferPriceRequestModel replyOfferPriceRequestModel,
    required void Function(double progress) onProgress,
  });
  Future<Either<Failure, UserOffersModel>> getUserOffers({required int page});
}
