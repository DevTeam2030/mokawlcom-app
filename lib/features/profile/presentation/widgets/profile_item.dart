import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    super.key,
    required this.theme,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLanguage = false,
  });
  final ThemeData theme;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLanguage;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: ColorsManager.secondaryColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorsManager.primaryColor),
            const SizedBox(width: 12.0),
            Text(
              title,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorsManager.primaryColor,
              ),
            ),
            const Spacer(),
            if (isLanguage)
              Text(
                LocaleKeys.arabic,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
            const SizedBox(width: 10.0),
            const Icon(
              Icons.arrow_forward_ios,
              color: ColorsManager.primaryColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
