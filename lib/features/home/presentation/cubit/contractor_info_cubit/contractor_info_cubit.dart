import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_details_model.dart';
import 'package:mokawlcom_app/features/home/data/repo/home_repo.dart';

part 'contractor_info_state.dart';

class ContractorInfoCubit extends Cubit<ContractorInfoState> {
  final HomeRepo homeRepo;
  ContractorInfoCubit({required this.homeRepo})
    : super(const ContractorInfoState());

  Future<void> getContractorDetails({required int contractorId}) async {
    emit(
      state.copyWith(
        getContractorDetailsState: RequestStatus.loading,
        isConnected: true,
      ),
    );
    final result = await homeRepo.getContractorDetails(
      contractorId: contractorId,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getContractorDetailsState: RequestStatus.error,
            errorMessage: failure.errorMessage,
            isConnected: failure.isConnected,
          ),
        );
      },
      (contractorDetails) {
        emit(
          state.copyWith(
            getContractorDetailsState: RequestStatus.success,
            contractorDetails: contractorDetails,
            rating: contractorDetails.rating.toDouble(),
            isSaved: contractorDetails.isSaved,
          ),
        );
      },
    );
  }

  void toggleFavorite() => emit(state.copyWith(isSaved: !state.isSaved));
}
