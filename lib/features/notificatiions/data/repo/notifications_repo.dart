import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, PublicNotificationsModel>> getPublicNotifications({
    required int page,
  });
}