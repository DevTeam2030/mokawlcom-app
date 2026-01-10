import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/error/server_exception.dart';

abstract class HomeDataSource {
  Future<List<String>> getBanners();
}

class HomeDataSourceImpl implements HomeDataSource {
  final DioHelper dioHelper;
  HomeDataSourceImpl({required this.dioHelper});
  @override
  Future<List<String>> getBanners() async {
    final result = await dioHelper.get(url: ApiConstants.getBanners);
    if (result.statusCode == 200) {
      return List<String>.from(result.data["data"]?.map((x) => x["image"]) ?? []);
    } else {
      throw ServerException(errorMessage: result.data["message"] ?? "");
    }
  }
}
