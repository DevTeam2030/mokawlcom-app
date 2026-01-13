import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorites_model.dart';

class FavoriteState extends Equatable {
  final RequestStatus getFavoritesState;
  final RequestStatus addFavoriteState;
  final RequestStatus removeFavoriteState;
  final FavoritesModel favoritesModel;
  final int page;
  final String errorMessage;
  final String successMessage;
  final Map<int, FavoriteModel> favorites;
  final bool isConnected;

  const FavoriteState({
    this.getFavoritesState = RequestStatus.initial,
    this.addFavoriteState = RequestStatus.initial,
    this.removeFavoriteState = RequestStatus.initial,
    this.favoritesModel = const FavoritesModel.empty(),
    this.page = 1,
    this.isConnected = true,
    this.favorites = const {},
    this.errorMessage = '',
    this.successMessage = '',
  });
  FavoriteState copyWith({
    RequestStatus? getFavoritesState,
    RequestStatus? addFavoriteState,
    RequestStatus? removeFavoriteState,
    FavoritesModel? favoritesModel,
    Map<int, FavoriteModel>? favorites,
    int? page,
    bool? isConnected,
    String? errorMessage,
    String? successMessage,
  }) {
    return FavoriteState(
      getFavoritesState: getFavoritesState ?? this.getFavoritesState,
      addFavoriteState: addFavoriteState ?? this.addFavoriteState,
      removeFavoriteState: removeFavoriteState ?? this.removeFavoriteState,
      favoritesModel: favoritesModel ?? this.favoritesModel,
      favorites: favorites ?? this.favorites,
      page: page ?? this.page,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object> get props => [
    getFavoritesState,
    addFavoriteState,
    favoritesModel,
    page,
    favorites,
    isConnected,
    errorMessage,
    successMessage,
  ];
}
