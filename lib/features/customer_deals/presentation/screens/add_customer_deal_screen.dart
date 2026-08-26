import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_attachment_model.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/add_customer_deal/add_customer_deal_cubit.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/add_customer_deal/add_customer_deal_state.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_attachments_picker.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_form_validators.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:vector_graphics/vector_graphics.dart';

@RoutePage()
class AddCustomerDealScreen extends StatelessWidget {
  const AddCustomerDealScreen({super.key, this.deal});

  final CustomerDealModel? deal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddCustomerDealCubit>(
      create: (_) {
        final cubit = getIt<AddCustomerDealCubit>();
        if (deal != null) unawaited(cubit.initializeEdit(deal!));
        cubit.getClassifications();
        return cubit;
      },
      child: _AddCustomerDealForm(deal: deal),
    );
  }
}

class _AddCustomerDealForm extends StatefulWidget {
  const _AddCustomerDealForm({this.deal});

  final CustomerDealModel? deal;

  @override
  State<_AddCustomerDealForm> createState() => _AddCustomerDealFormState();
}

class _AddCustomerDealFormState extends State<_AddCustomerDealForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _showCategoryError = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController(text: widget.deal?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.deal?.details ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.deal == null ? LocaleKeys.addDeal : LocaleKeys.editDeal,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AddCustomerDealCubit, AddCustomerDealState>(
              listenWhen: (previous, current) =>
                  previous.submissionStatus != current.submissionStatus,
              listener: (context, state) async {
                if (state.submissionStatus.isError) {
                  await showDialog<void>(
                    context: context,
                    builder: (_) => ErrorDialog(
                      theme: theme,
                      message: state.submissionErrorMessage.isNotEmpty
                          ? state.submissionErrorMessage
                          : LocaleKeys.generalError,
                    ),
                  );
                } else if (state.submissionStatus.isSuccess) {
                  await showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => SuccessDialog(
                      theme: theme,
                      text: LocaleKeys.back,
                      message: state.submissionSuccessMessage,
                    ),
                  );
                  if (context.mounted) context.pop<bool>(true);
                }
              },
            ),
            BlocListener<AddCustomerDealCubit, AddCustomerDealState>(
              listenWhen: (previous, current) =>
                  previous.attachmentDeleteStatus !=
                  current.attachmentDeleteStatus,
              listener: (context, state) async {
                if (state.attachmentDeleteStatus.isError) {
                  await showDialog<void>(
                    context: context,
                    builder: (_) => ErrorDialog(
                      theme: theme,
                      message: state.attachmentDeleteMessage.isNotEmpty
                          ? state.attachmentDeleteMessage
                          : LocaleKeys.generalError,
                    ),
                  );
                } else if (state.attachmentDeleteStatus.isSuccess) {
                  await showDialog<void>(
                    context: context,
                    builder: (_) => SuccessDialog(
                      theme: theme,
                      text: LocaleKeys.back,
                      message: state.attachmentDeleteMessage,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<AddCustomerDealCubit, AddCustomerDealState>(
            builder: (context, state) {
              final isSubmitting = state.submissionStatus.isLoading;
              final visibleExistingAttachments = state.existingAttachments
                  .where((attachment) => attachment.file.trim().isNotEmpty)
                  .toList(growable: false);
              return Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  children: [
                    Text(
                      LocaleKeys.selectCategories,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategorySelector(theme, state),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.dealTitle,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _titleController,
                      type: TextInputType.text,
                      fieldName: LocaleKeys.dealTitle,
                      hintText: LocaleKeys.dealTitle,
                      enabled: !isSubmitting,
                      validator: (value) => validateRequiredDealField(
                        value,
                        LocaleKeys.dealTitle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.dealDetails,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      controller: _descriptionController,
                      type: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                      fieldName: LocaleKeys.dealDetails,
                      hintText: LocaleKeys.dealDetails,
                      enabled: !isSubmitting,
                      validator: (value) => validateRequiredDealField(
                        value,
                        LocaleKeys.dealDetails,
                      ),
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
                    if (widget.deal != null &&
                        (visibleExistingAttachments.isNotEmpty ||
                            state.existingAttachmentsStatus.isLoading ||
                            state.existingAttachmentsStatus.isError)) ...[
                      _buildExistingAttachments(
                        theme: theme,
                        state: state,
                        attachments: visibleExistingAttachments,
                        enabled: !isSubmitting,
                      ),
                      const SizedBox(height: 12),
                    ],
                    DealAttachmentsPicker(
                      files: state.selectedFiles,
                      isLoading: state.isFileLoading,
                      errorMessage: state.fileErrorMessage,
                      enabled: !isSubmitting,
                      onPick: context
                          .read<AddCustomerDealCubit>()
                          .pickAttachment,
                      onRemove: context
                          .read<AddCustomerDealCubit>()
                          .removeAttachment,
                    ),
                    const SizedBox(height: 30),
                    IgnorePointer(
                      ignoring: isSubmitting,
                      child: PrimaryButton(
                        onPressed: _submit,
                        text: widget.deal == null
                            ? LocaleKeys.save
                            : LocaleKeys.editDeal,
                        isLoading: isSubmitting,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExistingAttachments({
    required ThemeData theme,
    required AddCustomerDealState state,
    required List<CustomerDealAttachmentModel> attachments,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (attachments.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: attachments
                .map(
                  (attachment) => _buildExistingAttachmentItem(
                    attachment: attachment,
                    enabled:
                        enabled && !state.existingAttachmentsStatus.isLoading,
                    isDeleting:
                        state.attachmentDeleteStatus.isLoading &&
                        state.deletingAttachmentId == attachment.id,
                  ),
                )
                .toList(growable: false),
          ),
        if (state.existingAttachmentsStatus.isLoading) ...[
          if (attachments.isNotEmpty) const SizedBox(height: 8),
          const LinearProgressIndicator(color: ColorsManager.primaryColor),
        ] else if (state.existingAttachmentsStatus.isError) ...[
          if (attachments.isNotEmpty) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.existingAttachmentsErrorMessage,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.errorLight,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context
                    .read<AddCustomerDealCubit>()
                    .loadExistingAttachments(dealId: widget.deal!.id),
                child: Text(LocaleKeys.oopsRetry),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildExistingAttachmentItem({
    required CustomerDealAttachmentModel attachment,
    required bool enabled,
    required bool isDeleting,
  }) {
    final attachmentId = attachment.id;
    final canDelete =
        enabled && attachmentId != null && attachmentId > 0 && !isDeleting;

    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: ColorsManager.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorsManager.secondaryColor,
                  width: .8,
                ),
              ),
              child: attachment.isPdf
                  ? const VectorGraphic(
                      loader: AssetBytesLoader(AssetsManager.pdf),
                      width: 46,
                      height: 46,
                    )
                  : CustomCachedNetworkImage(
                      imageUrl: attachment.file.trim(),
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (attachmentId != null && attachmentId > 0)
            PositionedDirectional(
              top: 4,
              end: 4,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: canDelete
                      ? () => _confirmDeleteExistingAttachment(attachmentId)
                      : null,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: isDeleting
                        ? const Padding(
                            padding: EdgeInsets.all(5),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorsManager.errorLight,
                            ),
                          )
                        : const Icon(
                            Icons.close,
                            size: 17,
                            color: ColorsManager.errorLight,
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteExistingAttachment(int attachmentId) async {
    final cubit = context.read<AddCustomerDealCubit>();
    if (cubit.state.attachmentDeleteStatus.isLoading) return;

    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final deleteTitle = isArabic ? 'حذف المرفق' : 'Delete attachment';
    final deleteMessage = isArabic
        ? 'هل تريد حذف هذا المرفق فقط؟'
        : 'Do you want to delete this attachment only?';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.errorLight.withValues(alpha: .1),
                ),
                child: const Icon(
                  MyIcons.trash,
                  color: ColorsManager.errorLight,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                deleteTitle,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                deleteMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.grayText,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: ColorsManager.primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        LocaleKeys.cancel,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.errorLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        deleteTitle,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await cubit.deleteExistingAttachment(attachmentId: attachmentId);
    }
  }

  Widget _buildCategorySelector(ThemeData theme, AddCustomerDealState state) {
    final cubit = context.read<AddCustomerDealCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownField<ClassificationModel>(
          theme: theme,
          hintText: LocaleKeys.selectCategories,
          multiSelect: true,
          selectedValues: state.selectedCategories,
          items: state.categories
              .map(
                (category) => DropdownMenuItem<ClassificationModel>(
                  value: category,
                  child: Text(category.name),
                ),
              )
              .toList(),
          onMultiChanged: (values) {
            cubit.updateSelectedCategories(values);
            if (_showCategoryError && values.isNotEmpty) {
              setState(() => _showCategoryError = false);
            }
          },
          onLoadMore: cubit.loadMoreClassifications,
          isLoadingMore: state.paginationStatus.isLoadingMore,
          hasMoreData: state.currentPage < state.totalPages,
          readOnly: state.submissionStatus.isLoading,
        ),
        if (_showCategoryError) ...[
          const SizedBox(height: 8),
          Text(
            LocaleKeys.categorySelectionRequired,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.errorLight,
            ),
          ),
        ],
        if (state.categoryStatus.isLoading) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(color: ColorsManager.primaryColor),
        ] else if (state.categoryStatus.isError &&
            state.categories.isEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.categoryErrorMessage,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: ColorsManager.errorLight,
                  ),
                ),
              ),
              TextButton(
                onPressed: cubit.getClassifications,
                child: Text(LocaleKeys.oopsRetry),
              ),
            ],
          ),
        ] else if (state.categoryStatus.isSuccess &&
            state.categories.isEmpty) ...[
          const SizedBox(height: 8),
          Text(
            LocaleKeys.noCategoriesAvailable,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.grayText,
            ),
          ),
        ],
        if (state.selectedCategories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.selectedCategories.map((category) {
              return Chip(
                label: Text(
                  category.name,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: ColorsManager.primaryColor,
                deleteIconColor: Colors.white,
                onDeleted: state.submissionStatus.isLoading
                    ? null
                    : () {
                        cubit.updateSelectedCategories(
                          state.selectedCategories
                              .where((item) => item.id != category.id)
                              .toList(),
                        );
                      },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<AddCustomerDealCubit>();
    final hasCategory = cubit.state.selectedCategories.isNotEmpty;
    final formIsValid = _formKey.currentState?.validate() ?? false;

    if (!formIsValid || !hasCategory) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
        _showCategoryError = !hasCategory;
      });
      return;
    }

    cubit.submit(
      title: _titleController.text.trim(),
      details: _descriptionController.text.trim(),
      dealId: widget.deal?.id,
    );
  }
}
