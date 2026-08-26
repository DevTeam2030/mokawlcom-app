import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class DealAttachmentsPicker extends StatelessWidget {
  const DealAttachmentsPicker({
    super.key,
    required this.files,
    required this.isLoading,
    required this.errorMessage,
    required this.enabled,
    required this.onPick,
    required this.onRemove,
  });

  final List<File> files;
  final bool isLoading;
  final String errorMessage;
  final bool enabled;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: enabled && !isLoading ? onPick : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorsManager.secondaryColor),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.primaryColor,
                    ),
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
                        LocaleKeys.allowedFileTypes,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: ColorsManager.secondaryColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (errorMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.errorLight,
            ),
          ),
        ],
        if (files.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...List.generate(files.length, (index) {
            final file = files[index];
            final fileName = file.uri.pathSegments.isEmpty
                ? file.path
                : file.uri.pathSegments.last;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: index == files.length - 1 ? 0 : 8,
              ),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsManager.dividerGray),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.file_copy_outlined,
                      color: ColorsManager.secondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: enabled ? () => onRemove(index) : null,
                      icon: const Icon(
                        Icons.close,
                        color: ColorsManager.errorLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}
