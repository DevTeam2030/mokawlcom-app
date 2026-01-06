import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/file_types.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/file_picker_service.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/upload_file_model.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/upload_file/upload_file_section.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class UploadFileBottomSheet extends StatefulWidget {
  const UploadFileBottomSheet({
    super.key,
    required this.theme,
    required this.text,
    required this.userId,
    required this.index,
  });

  final ThemeData theme;
  final String text;
  final int userId;
  final int index;

  @override
  State<UploadFileBottomSheet> createState() => _UploadFileBottomSheetState();
}

class _UploadFileBottomSheetState extends State<UploadFileBottomSheet> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  String fileNumber = '';
  late final TextEditingController _expiryDateController;
  final Map<FileType, Future<void> Function()> uploadActions = {};

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _expiryDateController = TextEditingController();
    _uploadFileActions();
  }

  void _uploadFileActions() {
    uploadActions.addAll({
      FileType.commercialRegistry: () {
        return context.read<FilesCubit>().uploadCommercialRegistry(
          contractorId: widget.userId,
          fileNumber: fileNumber,
          index: widget.index,
          expiryDate: _expiryDateController.text,
        );
      },
      FileType.tradeLicense: () {
        return context.read<FilesCubit>().uploadTradeLicense(
          contractorId: widget.userId,
          fileNumber: fileNumber,
          index: widget.index,
          expiryDate: _expiryDateController.text,
        );
      },
      FileType.establishmentCertificate: () {
        return context.read<FilesCubit>().uploadEstablishmentCertificate(
          contractorId: widget.userId,
          fileNumber: fileNumber,
          index: widget.index,
          expiryDate: _expiryDateController.text,
        );
      },
      FileType.authorizedSignature: () {
        return context.read<FilesCubit>().uploadAuthorizedSignature(
          contractorId: widget.userId,
          fileNumber: fileNumber,
          index: widget.index,
          expiryDate: _expiryDateController.text,
        );
      },
    });
  }

  @override
  void dispose() {
    _expiryDateController.dispose();
    super.dispose();
  }

  FileType _getFileTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return FileType.commercialRegistry;
      case 1:
        return FileType.tradeLicense;
      case 2:
        return FileType.establishmentCertificate;
      case 3:
        return FileType.authorizedSignature;
      default:
        return FileType.commercialRegistry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                widget.text,
                style: widget.theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.text,
              style: widget.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              textInputAction: TextInputAction.next,
              type: TextInputType.number,
              fieldName: widget.text,
              onSaved: (value) => fileNumber = value!,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.expiryDate,
              style: widget.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 100),
                );
                if (pickedDate != null) {
                  final day = pickedDate.day.toString().padLeft(2, '0');
                  final month = pickedDate.month.toString().padLeft(2, '0');
                  final year = pickedDate.year.toString();
                  final formattedDate = '$year-$month-$day';
                  debugPrint(formattedDate);
                  _expiryDateController.text = formattedDate;
                }
              },
              textInputAction: TextInputAction.done,
              type: TextInputType.datetime,
              fieldName: LocaleKeys.expiryDate,
              controller: _expiryDateController,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.uploadFile,
              style: widget.theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            UploadFileSection(theme: widget.theme),
            const SizedBox(height: 10),
            BlocBuilder<FilesCubit, FilesState>(
              buildWhen: (previous, current) =>
                  previous.uploadFileState != current.uploadFileState,
              builder: (context, state) {
                return PrimaryButton(
                  isLoading: state.uploadFileState.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                      return;
                    }
                    _formKey.currentState!.save();
                    final fileType = _getFileTypeFromIndex(widget.index);
                    await uploadActions[fileType]!();
                  },
                  text: LocaleKeys.send,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
