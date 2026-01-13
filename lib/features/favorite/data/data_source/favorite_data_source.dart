import 'package:mokawlcom_app/core/network/api_constants.dart';
import 'package:mokawlcom_app/core/network/dio_helper.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';

abstract class FavoriteDataSource {
  Future<FavoritesModel> getFavorites({required int page});
  Future<String> addFavorite({required int contractorId});
  Future<String> removeFavorite({required int contractorId});
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

  @override
  Future<String> addFavorite({required int contractorId}) async {
    final result = await dioHelper.post(
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      url: ApiConstants.addFavorite,
      query: {"contractor_id": contractorId},
    );
    if (result.statusCode == 200) {
      return result.data["message"] ?? "";
    }
    throw ServerException(errorMessage: result.data["message"] ?? "");
  }

  @override
  Future<String> removeFavorite({required int contractorId}) async {
    final result = await dioHelper.post(
      headers: {"Authorization": "Bearer ${AppConstants.token}"},
      url: ApiConstants.removeFavorite,
      query: {"contractor_id": contractorId},
    );
    if (result.statusCode == 200) {
      return result.data["message"] ?? "";
    }
    throw ServerException(errorMessage: result.data["message"] ?? "");
  }
}
