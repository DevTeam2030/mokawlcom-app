import 'package:dartz/dartz.dart';
import 'package:mokawlcom_app/core/utils/safe_api_call.dart';
import 'package:mokawlcom_app/error/failures.dart';
import 'package:mokawlcom_app/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';
import 'package:mokawlcom_app/features/favorite/repo/favorite_repo.dart';

class FavoriteRepoImpl implements FavoriteRepo {
  final FavoriteDataSource favoriteDataSource;

  FavoriteRepoImpl({required this.favoriteDataSource});

  @override
  Future<Either<Failure, FavoritesModel>> getFavorites({
    required int page,
  }) async => await safeApiCall<FavoritesModel>(
    () => favoriteDataSource.getFavorites(page: page),
  );

  @override
  Future<Either<Failure, FavoriteModel>> addFavorite({
    required int contractorId,
  }) async => await safeApiCall<FavoriteModel>(
    () => favoriteDataSource.addFavorite(contractorId: contractorId),
  );

  @override
  Future<Either<Failure, String>> removeFavorite({
    required int contractorId,
  }) async => await safeApiCall<String>(
    () => favoriteDataSource.removeFavorite(contractorId: contractorId),
  );
}
