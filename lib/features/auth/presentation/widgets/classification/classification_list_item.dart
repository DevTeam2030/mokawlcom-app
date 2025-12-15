import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class ClassificationListItem extends StatelessWidget {
  const ClassificationListItem({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

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
            color: isSelected
                ? ColorsManager.primaryColor
                : ColorsManager.secondaryColor,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const Image(
              image: AssetImage(AssetsManager.mockawel),
            ),
            const SizedBox(width: 16),

            Text(
              "مقاول",
              style: theme.textTheme.bodyLarge!.copyWith(
                color: isSelected
                    ? ColorsManager.primaryColor
                    : Colors.black,
              ),
            ),

            const Spacer(),

            Container(
              width: 24,
              height: 24,
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