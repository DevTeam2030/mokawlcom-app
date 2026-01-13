import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';

abstract class FavoriteDataSource {
  Future<FavoritesModel> getFavorites({required int page});
}

class FavoriteDataSourceImpl implements FavoriteDataSource {
  final DioHelper dioHelper;

  FavoriteDataSourceImpl({required this.dioHelper});

  @override
  Future<FavoritesModel> getFavorites({required int page}) async {
    final result = await dioHelper.get(
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      url: ApiConstants.getFavorites,
      queryParameters: {"page": page},
    );
    if (result.statusCode == 200) {
      return FavoritesModel.fromJson(result.data["data"] ?? {});
    }
    throw ServerException(errorMessage: result.data["message"] ?? "");
  }
}
