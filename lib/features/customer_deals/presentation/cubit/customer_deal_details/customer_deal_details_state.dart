import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_reply_model.dart';

class CustomerDealDetailsState extends Equatable {
  const CustomerDealDetailsState({
    this.deal,
    this.replies = const [],
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalItems = 0,
    this.status = RequestStatus.initial,
    this.errorMessage = '',
    this.isConnected = true,
    this.replySubmissionStatus = RequestStatus.initial,
    this.replySuccessMessage = '',
    this.replyErrorMessage = '',
    this.selectedFiles = const [],
    this.isFileLoading = false,
    this.fileErrorMessage = '',
    this.hasSubmittedInitialReply = false,
    this.isContractorFollowUpSubmission = false,
    this.isRefreshingDetails = false,
    this.activeCustomerReplyContractorId,
    this.submittingContractorId,
    this.customerReplySubmissionStatus = RequestStatus.initial,
    this.customerReplySuccessMessage = '',
    this.customerReplyErrorMessage = '',
    this.customerReplyFiles = const [],
    this.isCustomerReplyFileLoading = false,
    this.customerReplyFileErrorMessage = '',
  });

  final CustomerDealDetailsModel? deal;
  final List<CustomerDealReplyModel> replies;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final RequestStatus status;
  final String errorMessage;
  final bool isConnected;
  final RequestStatus replySubmissionStatus;
  final String replySuccessMessage;
  final String replyErrorMessage;
  final List<File> selectedFiles;
  final bool isFileLoading;
  final String fileErrorMessage;
  final bool hasSubmittedInitialReply;
  final bool isContractorFollowUpSubmission;
  final bool isRefreshingDetails;
  final int? activeCustomerReplyContractorId;
  final int? submittingContractorId;
  final RequestStatus customerReplySubmissionStatus;
  final String customerReplySuccessMessage;
  final String customerReplyErrorMessage;
  final List<File> customerReplyFiles;
  final bool isCustomerReplyFileLoading;
  final String customerReplyFileErrorMessage;

  CustomerDealDetailsState copyWith({
    CustomerDealDetailsModel? deal,
    List<CustomerDealReplyModel>? replies,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    RequestStatus? status,
    String? errorMessage,
    bool? isConnected,
    RequestStatus? replySubmissionStatus,
    String? replySuccessMessage,
    String? replyErrorMessage,
    List<File>? selectedFiles,
    bool? isFileLoading,
    String? fileErrorMessage,
    bool? hasSubmittedInitialReply,
    bool? isContractorFollowUpSubmission,
    bool? isRefreshingDetails,
    int? activeCustomerReplyContractorId,
    bool clearActiveCustomerReplyContractorId = false,
    int? submittingContractorId,
    RequestStatus? customerReplySubmissionStatus,
    String? customerReplySuccessMessage,
    String? customerReplyErrorMessage,
    List<File>? customerReplyFiles,
    bool? isCustomerReplyFileLoading,
    String? customerReplyFileErrorMessage,
  }) {
    return CustomerDealDetailsState(
      deal: deal ?? this.deal,
      replies: replies ?? this.replies,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isConnected: isConnected ?? this.isConnected,
      replySubmissionStatus:
          replySubmissionStatus ?? this.replySubmissionStatus,
      replySuccessMessage: replySuccessMessage ?? this.replySuccessMessage,
      replyErrorMessage: replyErrorMessage ?? this.replyErrorMessage,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      isFileLoading: isFileLoading ?? this.isFileLoading,
      fileErrorMessage: fileErrorMessage ?? this.fileErrorMessage,
      hasSubmittedInitialReply:
          hasSubmittedInitialReply ?? this.hasSubmittedInitialReply,
      isContractorFollowUpSubmission:
          isContractorFollowUpSubmission ?? this.isContractorFollowUpSubmission,
      isRefreshingDetails: isRefreshingDetails ?? this.isRefreshingDetails,
      activeCustomerReplyContractorId: clearActiveCustomerReplyContractorId
          ? null
          : activeCustomerReplyContractorId ??
                this.activeCustomerReplyContractorId,
      submittingContractorId:
          submittingContractorId ?? this.submittingContractorId,
      customerReplySubmissionStatus:
          customerReplySubmissionStatus ?? this.customerReplySubmissionStatus,
      customerReplySuccessMessage:
          customerReplySuccessMessage ?? this.customerReplySuccessMessage,
      customerReplyErrorMessage:
          customerReplyErrorMessage ?? this.customerReplyErrorMessage,
      customerReplyFiles: customerReplyFiles ?? this.customerReplyFiles,
      isCustomerReplyFileLoading:
          isCustomerReplyFileLoading ?? this.isCustomerReplyFileLoading,
      customerReplyFileErrorMessage:
          customerReplyFileErrorMessage ?? this.customerReplyFileErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    deal,
    replies,
    currentPage,
    totalPages,
    totalItems,
    status,
    errorMessage,
    isConnected,
    replySubmissionStatus,
    replySuccessMessage,
    replyErrorMessage,
    selectedFiles,
    isFileLoading,
    fileErrorMessage,
    hasSubmittedInitialReply,
    isContractorFollowUpSubmission,
    isRefreshingDetails,
    activeCustomerReplyContractorId,
    submittingContractorId,
    customerReplySubmissionStatus,
    customerReplySuccessMessage,
    customerReplyErrorMessage,
    customerReplyFiles,
    isCustomerReplyFileLoading,
    customerReplyFileErrorMessage,
  ];
}
