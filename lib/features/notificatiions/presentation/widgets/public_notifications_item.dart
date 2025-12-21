import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class PublicNotificationItem extends StatelessWidget {
  const PublicNotificationItem({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFBFCFE),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أهلا بكم في تطبيق مقاولاتكم",
              style: theme.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              "02 Jan 2023 09:43 AM",
              style: theme.textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: ColorsManager.secondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان",
              style: theme.textTheme.labelSmall!.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
