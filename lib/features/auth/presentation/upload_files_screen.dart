import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/upload_file/upload_file_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class UploadFilesScreen extends StatelessWidget {
  const UploadFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.uploadFiles,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 3),
          UploadFileItem(theme: theme, text: LocaleKeys.commercialRegister),
          UploadFileItem(theme: theme, text: LocaleKeys.commercialLicense),
          UploadFileItem(theme: theme, text: LocaleKeys.recordOfOrigin),
          UploadFileItem(
            theme: theme,
            text: LocaleKeys.authorizedSignatoryCard,
          ),
        ],
      ),
    );
  }
}

class UploadFileItem extends StatelessWidget {
  const UploadFileItem({super.key, required this.theme, required this.text});

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => UploadFileBottomSheet(
            theme: theme,
            text: text,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 9,
        ),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorsManager.secondaryColor),
        ),
        child: Row(
          children: [
            const Icon(MyIcons.file, color: ColorsManager.secondaryColor),
            const SizedBox(width: 14),
            Text(
              text,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(Icons.add, color: ColorsManager.primaryColor),
          ],
        ),
      ),
    );
  }
}
