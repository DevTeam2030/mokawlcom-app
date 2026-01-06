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
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/upload_file/upload_file_item.dart';
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
      body: BlocListener<FilesCubit, FilesState>(
        listenWhen: (previous, current) =>
            previous.uploadFileState != current.uploadFileState,
        listener: (context, state) {
          if (state.uploadFileState.isSuccess) {
            showToast(
              message: state.successMessage,
              state: ToastStates.success,
            );
          }
          if (state.uploadFileState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
        },
        child: ListView.separated(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          itemCount: files.length,
          separatorBuilder: (_, _) => const SizedBox(height: 18.0),
          itemBuilder: (context, index) => UploadFileItem(
            theme: theme,
            text: files[index],
            index: index,
            userId: widget.contractorId,
          ),
        ),
      ),
      bottomNavigationBar:
          context.select(
            (FilesCubit cubit) => cubit.state.completedFiles.length == 4,
          )
          ? Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
              child: PrimaryButton(
                onPressed: () => context.pushRoute(const SubscriptionRoute()),
                text: LocaleKeys.next,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
