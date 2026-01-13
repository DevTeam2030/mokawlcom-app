import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/files_state.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class PriceOfferUploadFileSection extends StatelessWidget {
  const PriceOfferUploadFileSection({super.key, required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await context.read<HomeCubit>().pickFile();
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.isFileLoading != current.isFileLoading ||
                previous.file != current.file,
            builder: (context, state) {
              return Container(
                height: 135,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsManager.secondaryColor),
                ),
                child: state.isFileLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.file != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_copy_outlined,
                            size: 48,
                            color: ColorsManager.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.file!.path.split('/').last,
                            style: theme.textTheme.bodyLarge!.copyWith(
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
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: ColorsManager.secondaryColor,
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
        const SizedBox(height: 80),
        BlocSelector<HomeCubit, HomeState, double>(
          selector: (state) => state.progress,
          builder: (context, progress) {
            if (progress > 0 && progress < 1) {
              return Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)} %",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ],
              );
            } else if (progress == 1) {
              return Row(
                mainAxisAlignment: .center,
                children: [
                  const CircularProgressIndicator(strokeWidth: 2),
                  const SizedBox(width: 8),
                  Text(LocaleKeys.processingFile),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
