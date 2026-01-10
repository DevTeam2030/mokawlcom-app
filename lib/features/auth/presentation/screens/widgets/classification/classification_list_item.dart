import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClassificationListItem extends StatelessWidget {
  const ClassificationListItem({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
    required this.classificationModel,
  });

  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;
  final ClassificationModel classificationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: onTap,
      child: Container(
        height: 48.0,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 2 : 1,
            color: isSelected
                ? ColorsManager.primaryColor
                : ColorsManager.secondaryColor,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Skeleton.replace(
              replacement: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.skeletonColor,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomCachedNetworkImage(
                  imageUrl: classificationModel.image,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),
            Text(
              classificationModel.name,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: isSelected ? ColorsManager.primaryColor : Colors.black,
              ),
            ),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? ColorsManager.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? ColorsManager.primaryColor
                      : ColorsManager.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
