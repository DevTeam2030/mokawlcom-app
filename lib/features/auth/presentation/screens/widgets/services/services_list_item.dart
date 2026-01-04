import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/auth/data/models/contractor/settings_model.dart';

class ServicesListItem extends StatelessWidget {
  const ServicesListItem({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
    required this.service,
  });

  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;
  final SettingsModel service;
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
            CustomCachedNetworkImage(
              imageUrl: service.image,
              width: 38,
              height: 38,
            ),
            const SizedBox(width: 16),
            Text(
              service.name,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
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
