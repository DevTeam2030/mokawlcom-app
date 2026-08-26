import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/features/auth/data/repo/contractor/contractor_auth_repo.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/add_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/update_customer_deal_request_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/repo/customer_deals_repo.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/add_customer_deal/add_customer_deal_state.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';

class AddCustomerDealCubit extends Cubit<AddCustomerDealState> {
  AddCustomerDealCubit({
    required this.contractorAuthRepo,
    required this.customerDealsRepo,
  }) : super(const AddCustomerDealState());

  final ContractorAuthRepo contractorAuthRepo;
  final CustomerDealsRepo customerDealsRepo;

  Future<void> initializeEdit(CustomerDealModel deal) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        selectedCategories: deal.categories
            .map(
              (category) => ClassificationModel(
                id: category.id,
                numberOfServices: 0,
                name: category.name,
                image: '',
              ),
            )
            .toList(growable: false),
        existingAttachments: deal.attachments,
      ),
    );

    final visibleAttachments = deal.attachments.where(
      (attachment) => attachment.file.trim().isNotEmpty,
    );
    final hasCompleteAttachmentData =
        visibleAttachments.isNotEmpty &&
        visibleAttachments.every(
          (attachment) => attachment.id != null && attachment.id! > 0,
        );
    if (hasCompleteAttachmentData) {
      emit(
        state.copyWith(
          existingAttachmentsStatus: RequestStatus.success,
          existingAttachmentsErrorMessage: '',
        ),
      );
      return;
    }

    await loadExistingAttachments(dealId: deal.id);
  }

  Future<void> loadExistingAttachments({required int dealId}) async {
    if (isClosed || state.existingAttachmentsStatus.isLoading) return;

    emit(
      state.copyWith(
        existingAttachmentsStatus: RequestStatus.loading,
        existingAttachmentsErrorMessage: '',
      ),
    );
    final result = await customerDealsRepo.getMyDealDetails(dealId: dealId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          existingAttachmentsStatus: RequestStatus.error,
          existingAttachmentsErrorMessage: failure.errorMessage,
        ),
      ),
      (response) {
        emit(
          state.copyWith(
            existingAttachments: response.deal.attachments,
            existingAttachmentsStatus: RequestStatus.success,
            existingAttachmentsErrorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> getClassifications() async {
    if (isClosed || state.categoryStatus.isLoading) return;

    emit(
      state.copyWith(
        categoryStatus: RequestStatus.loading,
        paginationStatus: RequestStatus.initial,
        categoryErrorMessage: '',
        isConnected: true,
      ),
    );

    final result = await contractorAuthRepo.getClassifications(page: 1);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          categoryStatus: RequestStatus.error,
          categoryErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) {
        final categories = _deduplicate(classificationsModel.classifications);
        emit(
          state.copyWith(
            categories: categories,
            selectedCategories: _replaceSelectedWithLoaded(categories),
            currentPage: classificationsModel.currentPage,
            totalPages: classificationsModel.totalPages,
            categoryStatus: RequestStatus.success,
            categoryErrorMessage: '',
            isConnected: true,
          ),
        );
      },
    );
  }

  Future<void> loadMoreClassifications() async {
    if (isClosed ||
        state.categoryStatus.isLoading ||
        state.paginationStatus.isLoadingMore ||
        state.currentPage >= state.totalPages) {
      return;
    }

    emit(
      state.copyWith(
        paginationStatus: RequestStatus.loadingMore,
        categoryErrorMessage: '',
        isConnected: true,
      ),
    );

    final result = await contractorAuthRepo.getClassifications(
      page: state.currentPage + 1,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          paginationStatus: RequestStatus.error,
          categoryErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (classificationsModel) {
        final categories = _deduplicate([
          ...state.categories,
          ...classificationsModel.classifications,
        ]);
        emit(
          state.copyWith(
            categories: categories,
            selectedCategories: _replaceSelectedWithLoaded(categories),
            currentPage: classificationsModel.currentPage,
            totalPages: classificationsModel.totalPages,
            paginationStatus: RequestStatus.success,
            categoryErrorMessage: '',
            isConnected: true,
          ),
        );
      },
    );
  }

  void updateSelectedCategories(List<ClassificationModel> values) {
    if (isClosed || state.submissionStatus.isLoading) return;
    emit(state.copyWith(selectedCategories: _deduplicate(values)));
  }

  Future<void> pickAttachment() async {
    if (isClosed || state.submissionStatus.isLoading || state.isFileLoading) {
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
    if (isClosed || state.submissionStatus.isLoading) return;
    if (index < 0 || index >= state.selectedFiles.length) return;

    final updatedFiles = List<File>.from(state.selectedFiles)..removeAt(index);
    emit(state.copyWith(selectedFiles: updatedFiles, fileErrorMessage: ''));
  }

  Future<void> deleteExistingAttachment({required int attachmentId}) async {
    if (isClosed ||
        attachmentId <= 0 ||
        state.attachmentDeleteStatus.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        attachmentDeleteStatus: RequestStatus.loading,
        deletingAttachmentId: attachmentId,
        attachmentDeleteMessage: '',
        isConnected: true,
      ),
    );
    final result = await customerDealsRepo.deleteDealAttachment(
      attachmentId: attachmentId,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          attachmentDeleteStatus: RequestStatus.error,
          clearDeletingAttachmentId: true,
          attachmentDeleteMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (message) => emit(
        state.copyWith(
          existingAttachments: state.existingAttachments
              .where((attachment) => attachment.id != attachmentId)
              .toList(growable: false),
          attachmentDeleteStatus: RequestStatus.success,
          clearDeletingAttachmentId: true,
          attachmentDeleteMessage: message,
        ),
      ),
    );
  }

  Future<void> submit({
    required String title,
    required String details,
    int? dealId,
  }) async {
    if (isClosed || state.submissionStatus.isLoading) return;

    emit(
      state.copyWith(
        submissionStatus: RequestStatus.loading,
        submissionSuccessMessage: '',
        submissionErrorMessage: '',
        isConnected: true,
      ),
    );
    final categoryIds = state.selectedCategories
        .map((category) => category.id)
        .toList(growable: false);
    final files = List<File>.unmodifiable(state.selectedFiles);
    final result = dealId == null
        ? await customerDealsRepo.addCustomerDeal(
            request: AddCustomerDealRequestModel(
              title: title,
              details: details,
              categoryIds: categoryIds,
              files: files,
            ),
          )
        : await customerDealsRepo.updateCustomerDeal(
            request: UpdateCustomerDealRequestModel(
              id: dealId,
              title: title,
              details: details,
              categoryIds: categoryIds,
              newFiles: files,
            ),
          );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          submissionStatus: RequestStatus.error,
          submissionErrorMessage: failure.errorMessage,
          isConnected: failure.isConnected,
        ),
      ),
      (response) => emit(
        state.copyWith(
          submissionStatus: RequestStatus.success,
          submissionSuccessMessage: response.message,
        ),
      ),
    );
  }

  List<ClassificationModel> _deduplicate(Iterable<ClassificationModel> values) {
    final categoriesById = <int, ClassificationModel>{};
    for (final category in values) {
      categoriesById[category.id] = category;
    }
    return categoriesById.values.toList(growable: false);
  }

  List<ClassificationModel> _replaceSelectedWithLoaded(
    List<ClassificationModel> loadedCategories,
  ) {
    final loadedById = {
      for (final category in loadedCategories) category.id: category,
    };
    return state.selectedCategories
        .map((category) => loadedById[category.id] ?? category)
        .toList(growable: false);
  }
}
