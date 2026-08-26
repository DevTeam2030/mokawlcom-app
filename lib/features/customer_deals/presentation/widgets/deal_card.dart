import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:vector_graphics/vector_graphics.dart';

class DealCard extends StatelessWidget {
  const DealCard({
    super.key,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.repliesCount,
    required this.onTap,
    this.category = '',
    this.categories = const [],
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
    this.ownerName = '',
    this.file = '',
    this.isPdf = false,
    this.showReplyAction = false,
    this.myReplySent = false,
    this.onReply,
    this.onAttachmentTap,
  });

  final String title;
  final String description;
  final String category;
  final List<String> categories;
  final String createdDate;
  final int? repliesCount;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;
  final String ownerName;
  final String file;
  final bool isPdf;
  final bool showReplyAction;
  final bool myReplySent;
  final VoidCallback? onReply;
  final VoidCallback? onAttachmentTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryNames = [...categories, category]
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList(growable: false);
    final showActions = repliesCount == 0 && onEdit != null && onDelete != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: ColorsManager.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorsManager.secondaryColor, width: .7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (showActions) ...[
                    const SizedBox(width: 8),
                    if (isDeleting)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorsManager.primaryColor,
                        ),
                      )
                    else
                      InkResponse(
                        onTap: onDelete,
                        radius: 20,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            MyIcons.trash,
                            color: ColorsManager.primaryColor,
                            size: 18,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    InkResponse(
                      onTap: isDeleting ? null : onEdit,
                      radius: 20,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          MyIcons.editsolid,
                          color: ColorsManager.primaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.textColor,
                  height: 1.4,
                ),
              ),
              if (ownerName.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 17,
                      color: ColorsManager.grayText,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ownerName.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: ColorsManager.grayText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (categoryNames.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: categoryNames
                      .map(
                        (categoryName) => Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.lightBlueBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorsManager.borderLightBlue,
                              width: .8,
                            ),
                          ),
                          child: Text(
                            categoryName,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: ColorsManager.accentTextColor,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: ColorsManager.grayText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    createdDate,
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: ColorsManager.grayText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 17,
                    color: ColorsManager.grayText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    repliesCount?.toString() ?? '-',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: ColorsManager.grayText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (file.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAttachmentTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ColorsManager.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorsManager.secondaryColor,
                          width: .8,
                        ),
                      ),
                      child: isPdf
                          ? const VectorGraphic(
                              loader: AssetBytesLoader(AssetsManager.pdf),
                              width: 44,
                              height: 44,
                            )
                          : CustomCachedNetworkImage(
                              imageUrl: file.trim(),
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ],
              if (showReplyAction && !myReplySent) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: myReplySent || onReply == null ? () {} : onReply,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: myReplySent || onReply == null ? .45 : 1,
                      child: PrimaryButton(
                        onPressed: () {},
                        text: myReplySent
                            ? LocaleKeys.submittedPriceOffers
                            : LocaleKeys.addReply,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
