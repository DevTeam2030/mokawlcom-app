import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/subscription_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/upload_file/upload_file_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key, required this.contractorId});
  final int contractorId;

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  List<String> files = [
    LocaleKeys.commercialRegister,
    LocaleKeys.commercialLicense,
    LocaleKeys.recordOfOrigin,
    LocaleKeys.authorizedSignatoryCard,
  ];
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
          for (int i = 0; i < files.length; i++)
            UploadFileItem(
              theme: theme,
              text: files[i],
              index: i,
              userId: widget.contractorId,
            ),
        ],
      ),
    );
  }
}

class UploadFileItem extends StatelessWidget {
  const UploadFileItem({
    super.key,
    required this.theme,
    required this.text,
    required this.index,
    required this.userId,
  });

  final ThemeData theme;
  final String text;
  final int index;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<FilesCubit>().clearOldFile();
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (bottomSheetContext) => UploadFileBottomSheet(
            theme: theme,
            text: text,
            index: index,
            userId: userId,
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
            const Icon(MyIcons.file, color: ColorsManager.primaryColor),
            const SizedBox(width: 14),
            Text(
              text,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            BlocSelector<FilesCubit, FilesState, bool>(
              selector: (state) {
                return state.completedFiles.contains(index);
              },
              builder: (context, state) {
                return state
                    ? const Icon(Icons.check, color: ColorsManager.primaryColor)
                    : const Icon(Icons.add, color: ColorsManager.primaryColor);
              },
            ),
          ],
        ),
      ),
    );
  }
}
