import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/profile/data/repo/profile_repo.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final ProfileRepo profileRepo;
  UserDetailsCubit({required this.profileRepo})
    : super(const UserDetailsState());

  Future<void> getUserOffers() async {
    emit(state.copyWith(getUserOffersState: RequestStatus.loading));
    final result = await profileRepo.getUserOffers(page: state.page);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.success,
          userOffersModel: userOffersModel,
        ),
      ),
    );
  }

  Future<void> loadMoreUserOffers() async {
    if (state.page >= state.userOffersModel.totalPages ||
        state.getUserOffersState.isLoadingMore) {
      return;
    }
    emit(state.copyWith(getUserOffersState: RequestStatus.loadingMore));
    final result = await profileRepo.getUserOffers(page: state.page + 1);
    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: state.isConnected,
        ),
      ),
      (userOffersModel) => emit(
        state.copyWith(
          getUserOffersState: RequestStatus.success,
          userOffersModel: userOffersModel.copyWith(
            offers: [
              ...state.userOffersModel.offers,
              ...userOffersModel.offers,
            ],
          ),
          page: userOffersModel.currentPage,
        ),
      ),
    );
  }
}
