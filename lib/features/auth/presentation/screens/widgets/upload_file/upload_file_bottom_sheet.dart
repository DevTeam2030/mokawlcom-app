import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _expiryDateController = TextEditingController();
  }

  @override
  void dispose() {
    _expiryDateController.dispose();
    super.dispose();
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
            BlocConsumer<FilesCubit, FilesState>(
              listenWhen: (previous, current) =>
                  previous.uploadFileState != current.uploadFileState,
              buildWhen: (previous, current) =>
                  previous.uploadFileState != current.uploadFileState ||
                  previous.isFileLoading != current.isFileLoading ||
                  previous.selectedFile != current.selectedFile ||
                  previous.progress != current.progress,
              listener: (context, state) {
                if (state.uploadFileState.isSuccess) {
                  showToast(
                    message: state.successMessage,
                    state: ToastStates.success,
                  );
                }
                if (state.uploadFileState.isError) {
                  showToast(
                    message: state.errorMessage,
                    state: ToastStates.error,
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        await context.read<FilesCubit>().pickFile();
                      },
                      child: Container(
                        height: 135,
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorsManager.secondaryColor,
                          ),
                        ),
                        child: state.isFileLoading
                            ? const Center(child: CircularProgressIndicator())
                            : state.selectedFile != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    MyIcons.file,
                                    size: 48,
                                    color: ColorsManager.primaryColor,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.selectedFile!.path.split('/').last,
                                    style: widget.theme.textTheme.bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: ColorsManager.primaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  const Icon(
                                    MyIcons.uploadfile,
                                    size: 48,
                                    color: ColorsManager.secondaryColor,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${LocaleKeys.uploadFile} PDF/JPG',
                                    style: widget.theme.textTheme.bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: ColorsManager.secondaryColor,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 98),
                    if (state.uploadFileState.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LinearProgressIndicator(
                          value: state.progress,
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                    PrimaryButton(
                      isLoading: state.uploadFileState.isLoading,
                      onPressed: state.uploadFileState.isLoading
                          ? () {}
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (state.selectedFile != null) {
                                  await context
                                      .read<FilesCubit>()
                                      .uploadCommercialRegistry(
                                        contractorId: widget.userId,
                                        fileNumber: fileNumber,
                                        index: widget.index,
                                        expiryDate: _expiryDateController.text,
                                      );
                                } else {
                                  showToast(
                                    message: "Please select a file first",
                                    state: ToastStates.error,
                                  );
                                }
                              } else {
                                setState(() {
                                  _autovalidateMode = AutovalidateMode.always;
                                });
                              }
                            },
                      text: LocaleKeys.continueKey,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
