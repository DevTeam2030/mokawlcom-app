import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notifications_model.dart';

abstract class NotificationsDataSource {
  Future<PublicNotificationsModel> getPublicNotifications({required int page});
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
      headers: {
        "Authorization": "Bearer ${AppConstants.token}",
      },
    );
    if (response.statusCode == 200) {
      return PublicNotificationsModel.fromJson(response.data["data"] ?? {});
    } else {
      throw ServerException(errorMessage: response.data["message"] ?? "");
    }
  }
}
