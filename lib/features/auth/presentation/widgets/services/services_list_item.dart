import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class ServicesListItem extends StatelessWidget {
  const ServicesListItem({
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
            width: isSelected?2:1,
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
             "بناء",
              style: theme.textTheme.bodyLarge!.copyWith(
                color:  ColorsManager.primaryColor,
              ),
            ),
            const Spacer(),
            Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
              activeColor: ColorsManager.primaryColor,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

