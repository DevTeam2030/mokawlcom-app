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
    this.assetImage,
    this.label,
    this.showServiceCount = true,
  });
  final void Function() onTap;
  final ThemeData theme;
  final ClassificationModel classificationModel;
  final String? assetImage;
  final String? label;
  final bool showServiceCount;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: InkWell(
            onTap: onTap,
            child: assetImage == null
                ? Container(
                    width: 100,
                    height: 100,
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorsManager.lightGrayBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.borderGray,
                        width: 2,
                      ),
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
                      child: ClipOval(
                        // ignore: avoid_redundant_argument_values
                        clipBehavior: Clip.antiAlias,
                        child: CustomCachedNetworkImage(
                          imageUrl: classificationModel.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(assetImage!, fit: BoxFit.contain),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label ?? classificationModel.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorsManager.textColor,
            fontSize: 10,
          ),
        ),
        if (showServiceCount)
          Text(
            "(${classificationModel.numberOfServices})",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: theme.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorsManager.textColor,
              fontSize: 10,
            ),
          )
        else
          const SizedBox(height: 12),
      ],
    );
  }
}
