import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/upload_file/upload_file_bottom_sheet.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class UploadFileItem extends StatelessWidget {
  const UploadFileItem({
    super.key,
    required this.theme,
    required this.text,
    required this.index,
    required this.userId,
    required this.filesCubit,
  });

  final ThemeData theme;
  final String text;
  final int index;
  final int userId;
  final FilesCubit filesCubit;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FilesCubit, FilesState, bool>(
      selector: (state) {
        return state.completedFiles.contains(index);
      },
      builder: (context, isCompleted) {
        return InkWell(
          onTap: isCompleted
              ? null
              : () async {
                  context.read<FilesCubit>().clearOldFile();
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (bottomSheetContext) => BlocProvider.value(
                      value: filesCubit,
                      child: SafeArea(
                        child: UploadFileBottomSheet(
                          theme: theme,
                          text: text,
                          index: index,
                          userId: userId,
                        ),
                      ),
                    ),
                  );
                },
          child: Container(
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
                isCompleted
                    ? const Icon(Icons.check, color: ColorsManager.primaryColor)
                    : const Icon(Icons.add, color: ColorsManager.primaryColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
