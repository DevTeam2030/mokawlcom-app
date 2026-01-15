import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/home/data/models/add_offer_price_request_model.dart';
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

  Future<void> rateContractor({
    required int contractorId,
    required double rating,
  }) async {
    final oldRating = state.rating;
    emit(
      state.copyWith(
        rateContractorState: RequestStatus.loading,
        isConnected: true,
        rating: rating,
      ),
    );
    final result = await homeRepo.rateContractor(
      contractorId: contractorId.toString(),
      rating: rating.toString(),
    );
    result.fold((failure) {
      emit(
        state.copyWith(
          rateContractorState: RequestStatus.error,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
          rating: oldRating,
        ),
      );
    }, (_) {});
  }

  void toggleFavorite() => emit(state.copyWith(isSaved: !state.isSaved));
  Future<void> pickFile() async {
    emit(
      state.copyWith(
        addOfferPriceState: RequestStatus.initial,
        isFileLoading: true,
      ),
    );
    try {
      final File? file = await FilePickerService.pickFile();
      emit(state.copyWith(file: file, isFileLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          addOfferPriceMessage: e.toString(),
          addOfferPriceState: RequestStatus.error,
          isFileLoading: false,
        ),
      );
    }
  }

  Future<void> addOfferPrice({
    required int contractorId,
    required String price,
    required String title,
    required String message,
  }) async {
    emit(state.copyWith(addOfferPriceState: RequestStatus.loading));
    final result = await homeRepo.addOfferPrice(
      addOfferPriceRequestModel: AddOfferPriceRequestModel(
        file: state.file,
        contractorId: contractorId,
        price: price,
        title: title,
        message: message,
      ),
      onProgress: (progress) {
        emit(state.copyWith(progress: progress));
      },
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addOfferPriceState: RequestStatus.error,
          addOfferPriceMessage: failure.errorMessage,
          isConnected: failure.isConnected,
          progress: 0,
        ),
      ),
      (message) => emit(
        state.copyWith(
          addOfferPriceState: RequestStatus.success,
          addOfferPriceMessage: message,
          progress: 0,
        ),
      ),
    );
  }
}
