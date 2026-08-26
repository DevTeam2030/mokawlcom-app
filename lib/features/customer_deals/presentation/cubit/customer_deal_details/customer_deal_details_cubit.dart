import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_reply_to_contractor_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/initial_deal_reply_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_reply_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/repo/customer_deals_repo.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deal_details/customer_deal_details_state.dart';

class CustomerDealDetailsCubit extends Cubit<CustomerDealDetailsState> {
  CustomerDealDetailsCubit({required this.customerDealsRepo})
    : super(const CustomerDealDetailsState());

  final CustomerDealsRepo customerDealsRepo;

  Future<void> getMyDealDetails({required int dealId}) async {
    if (isClosed || state.status.isLoading || state.status.isSuccess) return;

    await _loadDetails(dealId, preserveContent: false);
  }

  Future<void> refreshMyDealDetails({
    required int dealId,
    bool preserveContent = false,
  }) async {
    if (isClosed || state.status.isLoading || state.isRefreshingDetails) return;

    await _loadDetails(dealId, preserveContent: preserveContent);
  }

  Future<void> _loadDetails(int dealId, {required bool preserveContent}) async {
    emit(
      state.copyWith(
        status: preserveContent ? state.status : RequestStatus.loading,
        isRefreshingDetails: preserveContent,
        errorMessage: '',
        isConnected: true,
      ),
    );

    final result = await customerDealsRepo.getMyDealDetails(dealId: dealId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: preserveContent ? state.status : RequestStatus.error,
          isRefreshingDetails: false,
          errorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (response) => emit(
        state.copyWith(
          deal: response.deal,
          replies: _deduplicate(response.replies.replies),
          currentPage: response.replies.currentPage,
          totalPages: response.replies.totalPages,
          totalItems: response.replies.totalItems,
          status: RequestStatus.success,
          isRefreshingDetails: false,
          errorMessage: '',
          isConnected: true,
        ),
      ),
    );
  }

  void toggleCustomerReplyForm(int contractorId) {
    if (isClosed || _isCustomerThreadSubmitting(contractorId)) return;

    final isClosing = state.activeCustomerReplyContractorId == contractorId;
    final anotherThreadIsSubmitting =
        state.customerReplySubmissionStatus.isLoading &&
        state.submittingContractorId != contractorId;
    emit(
      state.copyWith(
        activeCustomerReplyContractorId: isClosing ? null : contractorId,
        clearActiveCustomerReplyContractorId: isClosing,
        customerReplySubmissionStatus: anotherThreadIsSubmitting
            ? state.customerReplySubmissionStatus
            : RequestStatus.initial,
        customerReplySuccessMessage: anotherThreadIsSubmitting
            ? state.customerReplySuccessMessage
            : '',
        customerReplyErrorMessage: anotherThreadIsSubmitting
            ? state.customerReplyErrorMessage
            : '',
        customerReplyFiles: const [],
        isCustomerReplyFileLoading: false,
        customerReplyFileErrorMessage: '',
      ),
    );
  }

  Future<void> pickCustomerReplyAttachment(int contractorId) async {
    if (isClosed ||
        state.activeCustomerReplyContractorId != contractorId ||
        _isCustomerThreadSubmitting(contractorId) ||
        state.isCustomerReplyFileLoading) {
      return;
    }

    emit(
      state.copyWith(
        isCustomerReplyFileLoading: true,
        customerReplyFileErrorMessage: '',
      ),
    );
    try {
      final file = await FilePickerService.pickFile();
      if (isClosed) return;
      if (file == null) {
        emit(state.copyWith(isCustomerReplyFileLoading: false));
        return;
      }

      final isDuplicate = state.customerReplyFiles.any(
        (selectedFile) => selectedFile.absolute.path == file.absolute.path,
      );
      emit(
        state.copyWith(
          customerReplyFiles: isDuplicate
              ? state.customerReplyFiles
              : [...state.customerReplyFiles, file],
          isCustomerReplyFileLoading: false,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isCustomerReplyFileLoading: false,
          customerReplyFileErrorMessage: error.toString(),
        ),
      );
    }
  }

  void removeCustomerReplyAttachment(int contractorId, int index) {
    if (isClosed ||
        state.activeCustomerReplyContractorId != contractorId ||
        _isCustomerThreadSubmitting(contractorId) ||
        index < 0 ||
        index >= state.customerReplyFiles.length) {
      return;
    }

    final updatedFiles = List<File>.from(state.customerReplyFiles)
      ..removeAt(index);
    emit(
      state.copyWith(
        customerReplyFiles: updatedFiles,
        customerReplyFileErrorMessage: '',
      ),
    );
  }

  Future<void> replyToContractor({
    required int dealId,
    required int contractorId,
    required String price,
    required String message,
  }) async {
    if (isClosed ||
        state.activeCustomerReplyContractorId != contractorId ||
        _isCustomerThreadSubmitting(contractorId)) {
      return;
    }

    emit(
      state.copyWith(
        submittingContractorId: contractorId,
        customerReplySubmissionStatus: RequestStatus.loading,
        customerReplySuccessMessage: '',
        customerReplyErrorMessage: '',
        isConnected: true,
      ),
    );
    final result = await customerDealsRepo.replyToContractor(
      request: CustomerReplyToContractorRequestModel(
        dealId: dealId,
        contractorId: contractorId,
        price: price.trim(),
        message: message.trim(),
        filePaths: state.customerReplyFiles
            .map((file) => file.path)
            .toList(growable: false),
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          customerReplySubmissionStatus: RequestStatus.error,
          customerReplyErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (response) => emit(
        state.copyWith(
          clearActiveCustomerReplyContractorId: true,
          customerReplySubmissionStatus: RequestStatus.success,
          customerReplySuccessMessage: response.message,
          customerReplyFiles: const [],
          isCustomerReplyFileLoading: false,
          customerReplyFileErrorMessage: '',
        ),
      ),
    );
  }

  bool _isCustomerThreadSubmitting(int contractorId) {
    return state.customerReplySubmissionStatus.isLoading &&
        state.submittingContractorId == contractorId;
  }

  Future<void> pickAttachment() async {
    if (isClosed ||
        state.replySubmissionStatus.isLoading ||
        state.isFileLoading) {
      return;
    }

    emit(state.copyWith(isFileLoading: true, fileErrorMessage: ''));
    try {
      final file = await FilePickerService.pickFile();
      if (isClosed) return;
      if (file == null) {
        emit(state.copyWith(isFileLoading: false));
        return;
      }

      final isDuplicate = state.selectedFiles.any(
        (selectedFile) => selectedFile.absolute.path == file.absolute.path,
      );
      emit(
        state.copyWith(
          selectedFiles: isDuplicate
              ? state.selectedFiles
              : [...state.selectedFiles, file],
          isFileLoading: false,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isFileLoading: false,
          fileErrorMessage: error.toString(),
        ),
      );
    }
  }

  void removeAttachment(int index) {
    if (isClosed || state.replySubmissionStatus.isLoading) return;
    if (index < 0 || index >= state.selectedFiles.length) return;

    final updatedFiles = List<File>.from(state.selectedFiles)..removeAt(index);
    emit(state.copyWith(selectedFiles: updatedFiles, fileErrorMessage: ''));
  }

  void prepareContractorFollowUp() {
    if (isClosed || state.replySubmissionStatus.isLoading) return;
    emit(
      state.copyWith(
        replySubmissionStatus: RequestStatus.initial,
        replySuccessMessage: '',
        replyErrorMessage: '',
        selectedFiles: const [],
        isFileLoading: false,
        fileErrorMessage: '',
        isContractorFollowUpSubmission: true,
      ),
    );
  }

  void discardContractorFollowUp() {
    if (isClosed || state.replySubmissionStatus.isLoading) return;
    emit(
      state.copyWith(
        replySubmissionStatus: RequestStatus.initial,
        replySuccessMessage: '',
        replyErrorMessage: '',
        selectedFiles: const [],
        isFileLoading: false,
        fileErrorMessage: '',
        isContractorFollowUpSubmission: false,
      ),
    );
  }

  Future<void> submitContractorReply({
    required int dealId,
    required String price,
    required String message,
    bool isFollowUp = false,
  }) async {
    if (isClosed ||
        state.replySubmissionStatus.isLoading ||
        (!isFollowUp && state.hasSubmittedInitialReply)) {
      return;
    }

    emit(
      state.copyWith(
        replySubmissionStatus: RequestStatus.loading,
        replySuccessMessage: '',
        replyErrorMessage: '',
        isContractorFollowUpSubmission: isFollowUp,
        isConnected: true,
      ),
    );
    final result = await customerDealsRepo.submitInitialReply(
      request: InitialDealReplyRequestModel(
        dealId: dealId,
        price: price.trim(),
        message: message.trim(),
        files: List<File>.unmodifiable(state.selectedFiles),
      ),
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          replySubmissionStatus: RequestStatus.error,
          replyErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (response) => emit(
        state.copyWith(
          replySubmissionStatus: RequestStatus.success,
          replySuccessMessage: response.message,
          selectedFiles: const [],
          isFileLoading: false,
          fileErrorMessage: '',
          hasSubmittedInitialReply: isFollowUp
              ? state.hasSubmittedInitialReply
              : true,
        ),
      ),
    );
  }

  List<CustomerDealReplyModel> _deduplicate(
    Iterable<CustomerDealReplyModel> replies,
  ) {
    final repliesById = <int, CustomerDealReplyModel>{};
    for (final reply in replies) {
      repliesById[reply.id] = reply;
    }
    return repliesById.values.toList(growable: false);
  }
}
