import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/shared/data/models/app_version_model.dart';

abstract class AppDataSource {
  Future<AppVersionModel> getAppVersion();
}

class AppDataSourceImpl implements AppDataSource {
  final DioHelper dioHelper;

  AppDataSourceImpl({required this.dioHelper});

  @override
  Future<AppVersionModel> getAppVersion() async {
    final result = await dioHelper.get(
      url: ApiConstants.appVerionEndpoint,
    );

    if (result.statusCode == 200) {
      return AppVersionModel.fromJson(
        result.data['data'] as Map<String, dynamic>? ?? const {},
      );
    } else {
      throw ServerException(errorMessage: result.data['message'] ?? '');
    }
  }
}
