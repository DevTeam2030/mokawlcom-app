import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_attachment_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';

class AddCustomerDealState extends Equatable {
  const AddCustomerDealState({
    this.categories = const [],
    this.selectedCategories = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    RequestStatus categoryStatus = RequestStatus.initial,
    RequestStatus paginationStatus = RequestStatus.initial,
    this.categoryErrorMessage = '',
    this.isConnected = true,
    RequestStatus submissionStatus = RequestStatus.initial,
    this.submissionSuccessMessage = '',
    this.submissionErrorMessage = '',
    this.selectedFiles = const [],
    this.isFileLoading = false,
    this.fileErrorMessage = '',
    this.existingAttachments = const [],
    RequestStatus existingAttachmentsStatus = RequestStatus.initial,
    this.existingAttachmentsErrorMessage = '',
    RequestStatus attachmentDeleteStatus = RequestStatus.initial,
    this.deletingAttachmentId,
    this.attachmentDeleteMessage = '',
  }) : _categoryStatus = categoryStatus,
       _paginationStatus = paginationStatus,
       _submissionStatus = submissionStatus,
       _existingAttachmentsStatus = existingAttachmentsStatus,
       _attachmentDeleteStatus = attachmentDeleteStatus;

  final List<ClassificationModel> categories;
  final List<ClassificationModel> selectedCategories;
  final int currentPage;
  final int totalPages;
  final RequestStatus? _categoryStatus;
  final RequestStatus? _paginationStatus;
  final String categoryErrorMessage;
  final bool isConnected;
  final RequestStatus? _submissionStatus;
  final String submissionSuccessMessage;
  final String submissionErrorMessage;
  final List<File> selectedFiles;
  final bool isFileLoading;
  final String fileErrorMessage;
  final List<CustomerDealAttachmentModel> existingAttachments;
  final RequestStatus? _existingAttachmentsStatus;
  final String existingAttachmentsErrorMessage;
  final RequestStatus? _attachmentDeleteStatus;
  final int? deletingAttachmentId;
  final String attachmentDeleteMessage;

  RequestStatus get categoryStatus => _categoryStatus ?? RequestStatus.initial;
  RequestStatus get paginationStatus =>
      _paginationStatus ?? RequestStatus.initial;
  RequestStatus get submissionStatus =>
      _submissionStatus ?? RequestStatus.initial;
  RequestStatus get existingAttachmentsStatus =>
      _existingAttachmentsStatus ?? RequestStatus.initial;
  RequestStatus get attachmentDeleteStatus =>
      _attachmentDeleteStatus ?? RequestStatus.initial;

  AddCustomerDealState copyWith({
    List<ClassificationModel>? categories,
    List<ClassificationModel>? selectedCategories,
    int? currentPage,
    int? totalPages,
    RequestStatus? categoryStatus,
    RequestStatus? paginationStatus,
    String? categoryErrorMessage,
    bool? isConnected,
    RequestStatus? submissionStatus,
    String? submissionSuccessMessage,
    String? submissionErrorMessage,
    List<File>? selectedFiles,
    bool? isFileLoading,
    String? fileErrorMessage,
    List<CustomerDealAttachmentModel>? existingAttachments,
    RequestStatus? existingAttachmentsStatus,
    String? existingAttachmentsErrorMessage,
    RequestStatus? attachmentDeleteStatus,
    int? deletingAttachmentId,
    bool clearDeletingAttachmentId = false,
    String? attachmentDeleteMessage,
  }) {
    return AddCustomerDealState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      categoryErrorMessage: categoryErrorMessage ?? this.categoryErrorMessage,
      isConnected: isConnected ?? this.isConnected,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionSuccessMessage:
          submissionSuccessMessage ?? this.submissionSuccessMessage,
      submissionErrorMessage:
          submissionErrorMessage ?? this.submissionErrorMessage,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      fileErrorMessage: fileErrorMessage ?? this.fileErrorMessage,
      existingAttachments: existingAttachments ?? this.existingAttachments,
      existingAttachmentsStatus:
          existingAttachmentsStatus ?? this.existingAttachmentsStatus,
      existingAttachmentsErrorMessage:
          existingAttachmentsErrorMessage ??
          this.existingAttachmentsErrorMessage,
      attachmentDeleteStatus:
          attachmentDeleteStatus ?? this.attachmentDeleteStatus,
      deletingAttachmentId: clearDeletingAttachmentId
          ? null
          : deletingAttachmentId ?? this.deletingAttachmentId,
      attachmentDeleteMessage:
          attachmentDeleteMessage ?? this.attachmentDeleteMessage,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    selectedCategories,
    currentPage,
    totalPages,
    categoryStatus,
    paginationStatus,
    categoryErrorMessage,
    isConnected,
    submissionStatus,
    submissionSuccessMessage,
    submissionErrorMessage,
    selectedFiles,
    isFileLoading,
    fileErrorMessage,
    existingAttachments,
    existingAttachmentsStatus,
    existingAttachmentsErrorMessage,
    attachmentDeleteStatus,
    deletingAttachmentId,
    attachmentDeleteMessage,
  ];
}
