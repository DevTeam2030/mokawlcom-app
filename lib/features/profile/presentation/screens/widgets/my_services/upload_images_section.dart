import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class UploadImagesSection extends StatelessWidget {
  const UploadImagesSection({super.key, required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      buildWhen: (previous, current) =>
          previous.hasReachedMaxImages != current.hasReachedMaxImages ||
          previous.hasImages != current.hasImages ||
          previous.imageUploadProgress != current.imageUploadProgress ||
          previous.imageErrorMessage != current.imageErrorMessage ||
          previous.isImageLoading != current.isImageLoading ||
          previous.selectedImages != current.selectedImages,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!state.hasReachedMaxImages)
              InkWell(
                onTap: state.isImageLoading
                    ? null
                    : () async {
                        await context.read<UserDetailsCubit>().pickImages();
                      },
                child: Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsManager.secondaryColor),
                  ),
                  child: state.isImageLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              MyIcons.uploadfile,
                              size: 48,
                              color: ColorsManager.secondaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.uploadPhotos,
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

            if (state.imageErrorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.imageErrorMessage,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (state.hasImages) ...[
              const SizedBox(height: 16),
              Text(
                '${LocaleKeys.servicePhotos} (${state.selectedImages.length}/${state.maxImages})',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.selectedImages.length,
                itemBuilder: (context, index) {
                  return _ImageCard(
                    image: state.selectedImages[index],
                    index: index,
                    theme: theme,
                  );
                },
              ),
            ],
            if (state.imageUploadProgress > 0 &&
                state.imageUploadProgress < 1) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: state.imageUploadProgress,
                      color: ColorsManager.primaryColor,
                      backgroundColor: ColorsManager.secondaryColor.withValues(
                        alpha: .2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${(state.imageUploadProgress * 100).toStringAsFixed(0)}%",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ] else if (state.imageUploadProgress == 1 &&
                state.selectedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(strokeWidth: 2),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.processingFile,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.image,
    required this.index,
    required this.theme,
  });

  final File image;
  final int index;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorsManager.secondaryColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              image,
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
        ),
        PositionedDirectional(
          top: 4,
          start: 4,
          child: InkWell(
            onTap: () {
              context.read<UserDetailsCubit>().removeImage(index);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
