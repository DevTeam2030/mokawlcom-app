import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_attachment_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_details_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_reply_model.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deal_details/customer_deal_details_cubit.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deal_details/customer_deal_details_state.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_attachments_picker.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_form_validators.dart';
import 'package:vector_graphics/vector_graphics.dart';

enum CustomerDealDetailsMode { customer, contractor }

class _IndexedDealReply {
  const _IndexedDealReply({required this.reply, required this.originalIndex});

  final CustomerDealReplyModel reply;
  final int originalIndex;
}

class _CustomerReplyThread {
  const _CustomerReplyThread({
    required this.contractorId,
    required this.contractorName,
    required this.replies,
    required this.firstResponseIndex,
    required this.latestReplyId,
    required this.latestReplyDateTime,
  });

  final int? contractorId;
  final String contractorName;
  final List<CustomerDealReplyModel> replies;
  final int firstResponseIndex;
  final int latestReplyId;
  final DateTime? latestReplyDateTime;
}

@RoutePage()
class CustomerDealDetailsScreen extends StatelessWidget {
  const CustomerDealDetailsScreen({
    super.key,
    required this.dealId,
    this.mode = CustomerDealDetailsMode.customer,
    this.initialMyReplySent = false,
    this.onInitialReplySuccess,
  });

  final int dealId;
  final CustomerDealDetailsMode mode;
  final bool initialMyReplySent;
  final VoidCallback? onInitialReplySuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerDealDetailsCubit>(
      create: (_) =>
          getIt<CustomerDealDetailsCubit>()..getMyDealDetails(dealId: dealId),
      child: _CustomerDealDetailsView(
        dealId: dealId,
        mode: mode,
        initialMyReplySent: initialMyReplySent,
        onInitialReplySuccess: onInitialReplySuccess,
      ),
    );
  }
}

class _DealReplyForm extends StatefulWidget {
  const _DealReplyForm({
    required this.files,
    required this.isFileLoading,
    required this.fileErrorMessage,
    required this.isSubmitting,
    required this.isPriceRequired,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.onSubmit,
  });

  final List<File> files;
  final bool isFileLoading;
  final String fileErrorMessage;
  final bool isSubmitting;
  final bool isPriceRequired;
  final VoidCallback onPickAttachment;
  final ValueChanged<int> onRemoveAttachment;
  final void Function(String price, String message) onSubmit;

  @override
  State<_DealReplyForm> createState() => _DealReplyFormState();
}

class _DealReplyFormState extends State<_DealReplyForm> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _messageController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.price,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: _priceController,
            type: const TextInputType.numberWithOptions(decimal: true),
            fieldName: LocaleKeys.price,
            hintText: LocaleKeys.price,
            enabled: !widget.isSubmitting,
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (!widget.isPriceRequired && trimmed.isEmpty) return null;
              if (widget.isPriceRequired && trimmed.isEmpty) {
                return validateRequiredDealField(value, LocaleKeys.price);
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.message,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: _messageController,
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 5,
            fieldName: LocaleKeys.message,
            hintText: LocaleKeys.message,
            enabled: !widget.isSubmitting,
            validator: (value) =>
                validateRequiredDealField(value, LocaleKeys.message),
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.attachAFile,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DealAttachmentsPicker(
            files: widget.files,
            isLoading: widget.isFileLoading,
            errorMessage: widget.fileErrorMessage,
            enabled: !widget.isSubmitting,
            onPick: widget.onPickAttachment,
            onRemove: widget.onRemoveAttachment,
          ),
          const SizedBox(height: 30),
          IgnorePointer(
            ignoring: widget.isSubmitting,
            child: PrimaryButton(
              onPressed: _submit,
              text: LocaleKeys.send,
              isLoading: widget.isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (widget.isSubmitting) return;

    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!formIsValid) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    widget.onSubmit(
      _priceController.text.trim(),
      _messageController.text.trim(),
    );
  }
}

class _ReplyBottomSheet extends StatelessWidget {
  const _ReplyBottomSheet.customer({
    required this.dealId,
    required this.contractorId,
    required this.contractorName,
  }) : isCustomerReply = true,
       isFollowUp = false;

  const _ReplyBottomSheet.contractor({
    required this.dealId,
    required this.isFollowUp,
  }) : contractorId = null,
       contractorName = '',
       isCustomerReply = false;

  final int dealId;
  final int? contractorId;
  final String contractorName;
  final bool isCustomerReply;
  final bool isFollowUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<CustomerDealDetailsCubit, CustomerDealDetailsState>(
      listenWhen: (previous, current) => isCustomerReply
          ? previous.customerReplySubmissionStatus !=
                current.customerReplySubmissionStatus
          : previous.replySubmissionStatus != current.replySubmissionStatus,
      listener: (context, state) async {
        if (isCustomerReply && state.submittingContractorId != contractorId) {
          return;
        }
        if (!isCustomerReply &&
            state.isContractorFollowUpSubmission != isFollowUp) {
          return;
        }

        final status = isCustomerReply
            ? state.customerReplySubmissionStatus
            : state.replySubmissionStatus;
        final errorMessage = isCustomerReply
            ? state.customerReplyErrorMessage
            : state.replyErrorMessage;
        final successMessage = isCustomerReply
            ? state.customerReplySuccessMessage
            : state.replySuccessMessage;

        if (status.isError) {
          await showDialog<void>(
            context: context,
            builder: (_) => ErrorDialog(
              theme: theme,
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : LocaleKeys.generalError,
            ),
          );
        } else if (status.isSuccess) {
          Navigator.of(context).pop(successMessage);
        }
      },
      builder: (context, state) {
        final isSubmitting = isCustomerReply
            ? state.customerReplySubmissionStatus.isLoading &&
                  state.submittingContractorId == contractorId
            : state.replySubmissionStatus.isLoading &&
                  state.isContractorFollowUpSubmission == isFollowUp;
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        final cubit = context.read<CustomerDealDetailsCubit>();

        return PopScope(
          canPop: !isSubmitting,
          child: SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.addReply,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isCustomerReply && contractorName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        contractorName,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: ColorsManager.grayText,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _DealReplyForm(
                      files: isCustomerReply
                          ? state.customerReplyFiles
                          : state.selectedFiles,
                      isFileLoading: isCustomerReply
                          ? state.isCustomerReplyFileLoading
                          : state.isFileLoading,
                      fileErrorMessage: isCustomerReply
                          ? state.customerReplyFileErrorMessage
                          : state.fileErrorMessage,
                      isSubmitting: isSubmitting,
                      isPriceRequired: !isCustomerReply,
                      onPickAttachment: isCustomerReply
                          ? () =>
                                cubit.pickCustomerReplyAttachment(contractorId!)
                          : cubit.pickAttachment,
                      onRemoveAttachment: isCustomerReply
                          ? (index) => cubit.removeCustomerReplyAttachment(
                              contractorId!,
                              index,
                            )
                          : cubit.removeAttachment,
                      onSubmit: (price, message) {
                        if (isCustomerReply) {
                          cubit.replyToContractor(
                            dealId: dealId,
                            contractorId: contractorId!,
                            price: price,
                            message: message,
                          );
                        } else {
                          cubit.submitContractorReply(
                            dealId: dealId,
                            price: price,
                            message: message,
                            isFollowUp: isFollowUp,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CustomerDealDetailsView extends StatefulWidget {
  const _CustomerDealDetailsView({
    required this.dealId,
    required this.mode,
    required this.initialMyReplySent,
    this.onInitialReplySuccess,
  });

  final int dealId;
  final CustomerDealDetailsMode mode;
  final bool initialMyReplySent;
  final VoidCallback? onInitialReplySuccess;

  @override
  State<_CustomerDealDetailsView> createState() =>
      _CustomerDealDetailsViewState();
}

class _CustomerDealDetailsViewState extends State<_CustomerDealDetailsView> {
  int? _expandedContractorId;
  bool _hasInitializedCustomerThreadExpansion = false;

  int get dealId => widget.dealId;
  CustomerDealDetailsMode get mode => widget.mode;
  bool get initialMyReplySent => widget.initialMyReplySent;
  VoidCallback? get onInitialReplySuccess => widget.onInitialReplySuccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isContractor = mode == CustomerDealDetailsMode.contractor;
    final isCustomer = mode == CustomerDealDetailsMode.customer;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.customerDeals,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CustomerDealDetailsCubit, CustomerDealDetailsState>(
          builder: (context, state) {
            if (state.status.isInitial || state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryColor,
                ),
              );
            }

            if (state.status.isError || state.deal == null) {
              return _buildErrorState(
                context: context,
                theme: theme,
                state: state,
              );
            }

            return _buildContent(
              context: context,
              theme: theme,
              state: state,
              deal: state.deal!,
              isContractor: isContractor,
              isCustomer: isCustomer,
              isArabic: isArabic,
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required BuildContext context,
    required ThemeData theme,
    required CustomerDealDetailsState state,
  }) {
    void retry() {
      context.read<CustomerDealDetailsCubit>().getMyDealDetails(dealId: dealId);
    }

    if (!state.isConnected) {
      return NoInternetWidget(
        errorMessage: state.errorMessage,
        theme: theme,
        onPressed: retry,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(onPressed: retry, text: LocaleKeys.oopsRetry),
          ],
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required ThemeData theme,
    required CustomerDealDetailsState state,
    required CustomerDealDetailsModel deal,
    required bool isContractor,
    required bool isCustomer,
    required bool isArabic,
  }) {
    return ListView(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      children: [
        Text(
          deal.title,
          style: theme.textTheme.titleLarge!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (deal.categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: deal.categories
                .map(
                  (category) => Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsManager.lightBlueBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorsManager.borderLightBlue,
                        width: .8,
                      ),
                    ),
                    child: Text(
                      category.name,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.accentTextColor,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ],
        if (deal.date.isNotEmpty || deal.time.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: ColorsManager.grayText,
              ),
              const SizedBox(width: 6),
              Text(
                [
                  deal.date,
                  deal.time,
                ].where((value) => value.isNotEmpty).join(' - '),
                style: theme.textTheme.labelMedium!.copyWith(
                  color: ColorsManager.grayText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        _buildSectionTitle(theme, isArabic ? 'تفاصيل الصفقة' : 'Deal details'),
        const SizedBox(height: 8),
        Text(
          deal.details,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: ColorsManager.textColor,
            height: 1.5,
          ),
        ),
        if (deal.attachments.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionTitle(theme, isArabic ? 'المرفقات' : 'Attachments'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: deal.attachments
                .where((attachment) => attachment.file.trim().isNotEmpty)
                .map(
                  (attachment) =>
                      _buildAttachmentItem(attachment: attachment, size: 64),
                )
                .toList(growable: false),
          ),
        ],
        if (isContractor &&
            state.replies.isEmpty &&
            !initialMyReplySent &&
            !state.hasSubmittedInitialReply) ...[
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () => _showContractorInitialReplyBottomSheet(
              context: context,
              dealId: deal.id,
            ),
            text: LocaleKeys.addReply,
          ),
        ],
        const SizedBox(height: 24),
        _buildSectionTitle(theme, LocaleKeys.replys),
        const SizedBox(height: 8),
        if (state.replies.isEmpty) ...[
          _buildRepliesEmpty(theme, isArabic),
        ] else if (isContractor) ...[
          ..._buildConversationEntries(
            context: context,
            state: state,
            dealId: deal.id,
            theme: theme,
            replies: state.replies,
            isArabic: isArabic,
            isCustomerMode: false,
            hideContractorSenderName: false,
            showContractorFollowUp: true,
          ),
        ] else if (isCustomer)
          ..._buildCustomerConversationThreads(
            context: context,
            state: state,
            dealId: deal.id,
            theme: theme,
            replies: state.replies,
            isArabic: isArabic,
          )
        else
          _buildRepliesEmpty(theme, isArabic),
      ],
    );
  }

  List<Widget> _buildCustomerConversationThreads({
    required BuildContext context,
    required CustomerDealDetailsState state,
    required int dealId,
    required ThemeData theme,
    required List<CustomerDealReplyModel> replies,
    required bool isArabic,
  }) {
    final threads = _groupCustomerReplies(replies, isArabic: isArabic);
    _initializeCustomerThreadExpansion(threads);

    return List.generate(threads.length, (index) {
      final thread = threads[index];
      final contractorId = thread.contractorId;
      final isExpanded =
          contractorId == null || contractorId == _expandedContractorId;
      final isSubmitting =
          contractorId != null &&
          state.customerReplySubmissionStatus.isLoading &&
          state.submittingContractorId == contractorId;

      return Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: index == threads.length - 1 ? 0 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: contractorId == null
                    ? null
                    : () => _toggleCustomerThread(contractorId),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.contractorName,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (contractorId != null)
                        AnimatedRotation(
                          turns: isExpanded ? .5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: ColorsManager.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        ..._buildConversationEntries(
                          context: context,
                          state: state,
                          dealId: dealId,
                          theme: theme,
                          replies: thread.replies,
                          isArabic: isArabic,
                          isCustomerMode: true,
                          hideContractorSenderName: true,
                          showContractorFollowUp: false,
                        ),
                        if (contractorId != null) ...[
                          const SizedBox(height: 12),
                          IgnorePointer(
                            ignoring: isSubmitting,
                            child: Opacity(
                              opacity: isSubmitting ? .45 : 1,
                              child: PrimaryButton(
                                onPressed: () => _showCustomerReplyBottomSheet(
                                  context: context,
                                  dealId: dealId,
                                  contractorId: contractorId,
                                  contractorName: thread.contractorName,
                                ),
                                text: LocaleKeys.addReply,
                              ),
                            ),
                          ),
                        ],
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  void _initializeCustomerThreadExpansion(List<_CustomerReplyThread> threads) {
    if (_hasInitializedCustomerThreadExpansion) return;
    _hasInitializedCustomerThreadExpansion = true;
    for (final thread in threads) {
      if (thread.contractorId != null) {
        _expandedContractorId = thread.contractorId;
        return;
      }
    }
  }

  void _toggleCustomerThread(int contractorId) {
    setState(() {
      _expandedContractorId = _expandedContractorId == contractorId
          ? null
          : contractorId;
    });
  }

  List<_CustomerReplyThread> _groupCustomerReplies(
    List<CustomerDealReplyModel> replies, {
    required bool isArabic,
  }) {
    final groupedReplies = <int, List<_IndexedDealReply>>{};
    final firstResponseIndexes = <int, int>{};
    final ungroupedReplies = <_IndexedDealReply>[];

    for (var index = 0; index < replies.length; index++) {
      final indexedReply = _IndexedDealReply(
        reply: replies[index],
        originalIndex: index,
      );
      final contractorId = indexedReply.reply.contractorId;
      if (contractorId == null || contractorId <= 0) {
        ungroupedReplies.add(indexedReply);
        continue;
      }

      groupedReplies.putIfAbsent(contractorId, () => []).add(indexedReply);
      firstResponseIndexes.putIfAbsent(contractorId, () => index);
    }

    final threads = <_CustomerReplyThread>[];
    for (final entry in groupedReplies.entries) {
      final sortedReplies = _sortThreadReplies(entry.value);
      threads.add(
        _CustomerReplyThread(
          contractorId: entry.key,
          contractorName: _resolveContractorThreadName(
            entry.value.map((item) => item.reply),
            isArabic: isArabic,
          ),
          replies: sortedReplies,
          firstResponseIndex: firstResponseIndexes[entry.key]!,
          latestReplyId: sortedReplies
              .map((reply) => reply.id)
              .reduce((first, second) => first > second ? first : second),
          latestReplyDateTime: _latestReplyDateTime(sortedReplies),
        ),
      );
    }
    for (final item in ungroupedReplies) {
      threads.add(
        _CustomerReplyThread(
          contractorId: null,
          contractorName: _resolveContractorThreadName([
            item.reply,
          ], isArabic: isArabic),
          replies: List.unmodifiable([item.reply]),
          firstResponseIndex: item.originalIndex,
          latestReplyId: item.reply.id,
          latestReplyDateTime: _parseReplyDateTime(item.reply),
        ),
      );
    }

    final allReplyIds = replies.map((reply) => reply.id).toList();
    final canSortThreadsByReplyId =
        allReplyIds.every((id) => id > 0) &&
        allReplyIds.toSet().length == allReplyIds.length;
    threads.sort((first, second) {
      if (canSortThreadsByReplyId) {
        final comparison = second.latestReplyId.compareTo(first.latestReplyId);
        if (comparison != 0) return comparison;
      } else if (first.latestReplyDateTime != null &&
          second.latestReplyDateTime != null) {
        final comparison = second.latestReplyDateTime!.compareTo(
          first.latestReplyDateTime!,
        );
        if (comparison != 0) return comparison;
      }
      return first.firstResponseIndex.compareTo(second.firstResponseIndex);
    });

    return List.unmodifiable(threads);
  }

  DateTime? _latestReplyDateTime(List<CustomerDealReplyModel> replies) {
    DateTime? latest;
    for (final reply in replies) {
      final parsed = _parseReplyDateTime(reply);
      if (parsed != null && (latest == null || parsed.isAfter(latest))) {
        latest = parsed;
      }
    }
    return latest;
  }

  DateTime? _parseReplyDateTime(CustomerDealReplyModel reply) {
    return DateTime.tryParse(
      '${reply.date.trim()} ${reply.time.trim()}'.trim(),
    );
  }

  List<CustomerDealReplyModel> _sortThreadReplies(
    List<_IndexedDealReply> indexedReplies,
  ) {
    final sortedReplies = List<_IndexedDealReply>.of(indexedReplies);
    final ids = sortedReplies.map((item) => item.reply.id).toList();
    final canSortById =
        ids.every((id) => id > 0) && ids.toSet().length == ids.length;

    if (canSortById) {
      sortedReplies.sort((first, second) {
        final comparison = first.reply.id.compareTo(second.reply.id);
        return comparison != 0
            ? comparison
            : first.originalIndex.compareTo(second.originalIndex);
      });
    } else {
      final parsedDates = <_IndexedDealReply, DateTime>{};
      for (final item in sortedReplies) {
        final parsed = _parseReplyDateTime(item.reply);
        if (parsed == null) break;
        parsedDates[item] = parsed;
      }
      if (parsedDates.length == sortedReplies.length) {
        sortedReplies.sort((first, second) {
          final comparison = parsedDates[first]!.compareTo(
            parsedDates[second]!,
          );
          return comparison != 0
              ? comparison
              : first.originalIndex.compareTo(second.originalIndex);
        });
      }
    }

    return List.unmodifiable(sortedReplies.map((item) => item.reply));
  }

  String _resolveContractorThreadName(
    Iterable<CustomerDealReplyModel> replies, {
    required bool isArabic,
  }) {
    for (final reply in replies) {
      if (reply.senderType.toLowerCase() == 'contractor' &&
          reply.contractorName.trim().isNotEmpty) {
        return reply.contractorName.trim();
      }
    }
    for (final reply in replies) {
      if (reply.contractorName.trim().isNotEmpty) {
        return reply.contractorName.trim();
      }
    }
    return isArabic ? 'مقاول' : 'Contractor';
  }

  Widget _buildSectionTitle(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.labelMedium!.copyWith(
        color: ColorsManager.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRepliesEmpty(ThemeData theme, bool isArabic) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: ColorsManager.secondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد ردود حتى الآن' : LocaleKeys.noRepliesYet,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConversationEntries({
    required BuildContext context,
    required CustomerDealDetailsState state,
    required int dealId,
    required ThemeData theme,
    required List<CustomerDealReplyModel> replies,
    required bool isArabic,
    required bool isCustomerMode,
    required bool hideContractorSenderName,
    required bool showContractorFollowUp,
  }) {
    return List.generate(replies.length, (index) {
      final reply = replies[index];
      final fromContractor = reply.senderType.toLowerCase() == 'contractor';
      final isFirstContractorEntry =
          fromContractor &&
          replies
              .take(index)
              .every(
                (previousReply) =>
                    previousReply.senderType.toLowerCase() != 'contractor',
              );
      final isContractorReplySubmitting =
          state.replySubmissionStatus.isLoading &&
          state.isContractorFollowUpSubmission;
      final contractorName = reply.contractorName.trim();
      final contractorDisplayName = contractorName.isEmpty
          ? (isArabic ? 'مقاول' : 'Contractor')
          : contractorName;
      final customerName = reply.userName.trim();
      final customerDisplayName = customerName.isEmpty
          ? (isArabic ? 'عميل' : 'Customer')
          : customerName;
      final yourReplyLabel = isArabic ? 'ردك' : 'Your reply';
      final senderName = isCustomerMode
          ? (fromContractor && hideContractorSenderName
                ? ''
                : fromContractor
                ? contractorDisplayName
                : yourReplyLabel)
          : customerDisplayName;
      final senderLabel = !isCustomerMode && fromContractor
          ? yourReplyLabel
          : '';

      return Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: index == replies.length - 1 ? 0 : 10,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            color: fromContractor
                ? ColorsManager.surfaceColor
                : ColorsManager.lightBlueBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: fromContractor
                  ? ColorsManager.secondaryColor
                  : ColorsManager.borderLightBlue,
              width: .8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (senderName.isNotEmpty || senderLabel.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        senderName,
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (senderLabel.isNotEmpty)
                      _buildSenderBadge(theme, senderLabel, fromContractor),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Text(
                reply.message,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.textColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${LocaleKeys.price}: ${reply.price}',
                style: theme.textTheme.labelMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (reply.attachments.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: reply.attachments
                      .where((attachment) => attachment.file.trim().isNotEmpty)
                      .map(
                        (attachment) => _buildAttachmentItem(
                          attachment: attachment,
                          size: 44,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                [
                  reply.date,
                  reply.time,
                ].where((value) => value.isNotEmpty).join(' - '),
                style: theme.textTheme.labelSmall!.copyWith(
                  color: ColorsManager.grayText,
                ),
              ),
              if (showContractorFollowUp && isFirstContractorEntry) ...[
                const SizedBox(height: 12),
                IgnorePointer(
                  ignoring: isContractorReplySubmitting,
                  child: Opacity(
                    opacity: isContractorReplySubmitting ? .45 : 1,
                    child: PrimaryButton(
                      onPressed: () => _showContractorFollowUpBottomSheet(
                        context: context,
                        dealId: dealId,
                      ),
                      text: LocaleKeys.addReply,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Future<void> _showCustomerReplyBottomSheet({
    required BuildContext context,
    required int dealId,
    required int contractorId,
    required String contractorName,
  }) async {
    final cubit = context.read<CustomerDealDetailsCubit>();
    if (cubit.state.activeCustomerReplyContractorId != null) return;
    cubit.toggleCustomerReplyForm(contractorId);
    if (cubit.state.activeCustomerReplyContractorId != contractorId) return;

    final successMessage = await _openReplyBottomSheet(
      context: context,
      cubit: cubit,
      child: _ReplyBottomSheet.customer(
        dealId: dealId,
        contractorId: contractorId,
        contractorName: contractorName,
      ),
    );

    if (!context.mounted) return;
    if (cubit.state.activeCustomerReplyContractorId == contractorId) {
      cubit.toggleCustomerReplyForm(contractorId);
    }
    if (successMessage == null) return;

    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        theme: theme,
        text: LocaleKeys.back,
        message: successMessage,
      ),
    );
    if (!context.mounted) return;
    setState(() {
      _hasInitializedCustomerThreadExpansion = true;
      _expandedContractorId = contractorId;
    });
    await cubit.refreshMyDealDetails(dealId: dealId, preserveContent: true);
  }

  Future<void> _showContractorFollowUpBottomSheet({
    required BuildContext context,
    required int dealId,
  }) async {
    final cubit = context.read<CustomerDealDetailsCubit>();
    if (cubit.state.replySubmissionStatus.isLoading ||
        cubit.state.isContractorFollowUpSubmission) {
      return;
    }
    cubit.prepareContractorFollowUp();

    final successMessage = await _openReplyBottomSheet(
      context: context,
      cubit: cubit,
      child: _ReplyBottomSheet.contractor(dealId: dealId, isFollowUp: true),
    );

    if (!context.mounted) return;
    cubit.discardContractorFollowUp();
    if (successMessage == null) return;

    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        theme: theme,
        text: LocaleKeys.back,
        message: successMessage,
      ),
    );
    if (!context.mounted) return;
    await cubit.refreshMyDealDetails(dealId: dealId, preserveContent: true);
    if (!context.mounted) return;
    onInitialReplySuccess?.call();
  }

  Future<void> _showContractorInitialReplyBottomSheet({
    required BuildContext context,
    required int dealId,
  }) async {
    final cubit = context.read<CustomerDealDetailsCubit>();
    if (cubit.state.replySubmissionStatus.isLoading) return;
    cubit.discardContractorFollowUp();

    final successMessage = await _openReplyBottomSheet(
      context: context,
      cubit: cubit,
      child: _ReplyBottomSheet.contractor(dealId: dealId, isFollowUp: false),
    );

    if (!context.mounted) return;
    cubit.discardContractorFollowUp();
    if (successMessage == null) return;

    final theme = Theme.of(context);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        theme: theme,
        text: LocaleKeys.back,
        message: successMessage,
      ),
    );
    if (!context.mounted) return;
    await cubit.refreshMyDealDetails(dealId: dealId);
    if (!context.mounted) return;
    onInitialReplySuccess?.call();
  }

  Future<String?> _openReplyBottomSheet({
    required BuildContext context,
    required CustomerDealDetailsCubit cubit,
    required Widget child,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(value: cubit, child: child),
    );
  }

  Widget _buildSenderBadge(
    ThemeData theme,
    String senderLabel,
    bool fromContractor,
  ) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: fromContractor
            ? ColorsManager.lightBlueBg
            : ColorsManager.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorsManager.borderLightBlue, width: .8),
      ),
      child: Text(
        senderLabel,
        style: theme.textTheme.labelSmall!.copyWith(
          color: ColorsManager.accentTextColor,
        ),
      ),
    );
  }

  Widget _buildAttachmentItem({
    required CustomerDealAttachmentModel attachment,
    required double size,
  }) {
    final imageUrl = attachment.file.trim();
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorsManager.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorsManager.secondaryColor, width: .8),
        ),
        child: attachment.isPdf
            ? VectorGraphic(
                loader: const AssetBytesLoader(AssetsManager.pdf),
                width: size * .68,
                height: size * .68,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: size * .68,
                      color: ColorsManager.secondaryColor,
                    ),
                    CustomCachedNetworkImage(
                      imageUrl: imageUrl,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
