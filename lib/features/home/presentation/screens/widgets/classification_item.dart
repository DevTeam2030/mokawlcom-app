import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClassificationItem extends StatelessWidget {
  const ClassificationItem({
    super.key,
    required this.onTap,
    required this.theme,
    required this.classificationModel,
  });
  final void Function() onTap;
  final ThemeData theme;
  final ClassificationModel classificationModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: ColorsManager.lightGrayBg,
                shape: BoxShape.circle,
                border: Border.all(color: ColorsManager.borderGray, width: 2),
              ),
              child: Skeleton.replace(
                replacement: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsManager.skeletonColor,
                  ),
                ),
                child: CustomCachedNetworkImage(imageUrl: classificationModel.image),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          classificationModel.name,
          style: theme.textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorsManager.textColor,
            fontSize: 10,
          ),
        ),
        Text(
          "(${classificationModel.number})",
          style: theme.textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorsManager.textColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
