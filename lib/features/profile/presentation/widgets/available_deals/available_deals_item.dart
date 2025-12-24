import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class AvailableDealsItem extends StatelessWidget {
  const AvailableDealsItem({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.secondaryColor, width: .7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(MyIcons.file, color: ColorsManager.primaryColor),
              const SizedBox(width: 10),
              Text(
                LocaleKeys.offerAddress,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                MyIcons.trash,
                color: ColorsManager.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 16),
              const Icon(
                MyIcons.editSolid,
                color: ColorsManager.primaryColor,
                size: 18,
              ),
            ],
          ),
          const CustomDivider(),
          Text(
            "${LocaleKeys.priceAverage} : 100 ريال",
            style: theme.textTheme.labelSmall!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها  عرضها في هذا المكان حجم و لون الخط حيث يتم التحكم في الموقع .ذا النص وامكانية تغييرة في اي وقت عن طريق ادارة",
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.primaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
