import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class UploadFileBottomSheet extends StatelessWidget {
  const UploadFileBottomSheet({
    super.key,
    required this.theme,
    required this.text,
  });

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const CustomTextFormField(
            textInputAction: TextInputAction.next,
            type: TextInputType.number,
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.expiryDate,
            style: theme.textTheme.bodyLarge!.copyWith(
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
                debugPrint(
                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                );
              }
            },
            textInputAction: TextInputAction.done,
            type: TextInputType.datetime,
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.uploadFile,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 135,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorsManager.secondaryColor),
            ),
            child: Column(
              children: [
                const Icon(
                  MyIcons.uploadFile,
                  size: 48,
                  color: ColorsManager.secondaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  '${LocaleKeys.uploadFile} PDF/JPG',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 98),
          PrimaryButton(onPressed: () {}, text: LocaleKeys.continueKey),
        ],
      ),
    );
  }
}
