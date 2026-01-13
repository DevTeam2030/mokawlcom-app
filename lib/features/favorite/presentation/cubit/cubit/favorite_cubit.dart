import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/favorite/data/data_source/favorite_data_source.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_state.dart';
import 'package:mokawlcom_app/features/favorite/repo/favorite_repo.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo favoriteRepo;
  FavoriteCubit({required this.favoriteRepo}) : super(const FavoriteState());

  Future<void> getFavorites() async {
    emit(
      state.copyWith(
        getFavoritesState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await favoriteRepo.getFavorites(page: state.page);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getFavoritesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (favoritesModel) {
        final Map<int, FavoriteModel> favoritesMap = _generateFavoritesMap(
          favoritesModel,
        );
        emit(
          state.copyWith(
            getFavoritesState: RequestStatus.success,
            favoritesModel: favoritesModel,
            favorites: favoritesMap,
            page: favoritesModel.currentpage,
          ),
        );
      },
    );
  }

  Future<void> loadMoreFavorites() async {
    if (state.page >= state.favoritesModel.totalPages ||
        state.getFavoritesState.isLoadingMore) {
      return;
    }
    emit(
      state.copyWith(
        getFavoritesState: RequestStatus.loadingMore,
        isConnected: true,
      ),
    );
    final result = await favoriteRepo.getFavorites(page: state.page + 1);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getFavoritesState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (favoritesModel) {
        final Map<int, FavoriteModel> updatedFavorites = {
          ...state.favorites,
          ..._generateFavoritesMap(favoritesModel),
        };
        emit(
          state.copyWith(
            getFavoritesState: RequestStatus.success,
            favoritesModel: favoritesModel,
            favorites: updatedFavorites,
            page: favoritesModel.currentpage,
          ),
        );
      },
    );
  }

  Map<int, FavoriteModel> _generateFavoritesMap(FavoritesModel favoritesModel) {
    final Map<int, FavoriteModel> favoritesMap = {};
    for (var favorite in favoritesModel.favorites) {
      favoritesMap[favorite.id] = favorite;
    }
    return favoritesMap;
  }
}
