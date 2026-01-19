import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class AvailableDealsItem extends StatelessWidget {
  const AvailableDealsItem({
    super.key,
    required this.theme,
    required this.deal,
  });
  final ThemeData theme;
  final DealModel deal;
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
              Expanded(
                child: Text(
                  deal.title,
                  style: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                MyIcons.editsolid,
                color: ColorsManager.primaryColor,
                size: 18,
              ),
            ],
          ),
          const CustomDivider(),
          const SizedBox(height: 10),
          Text(
            deal.description,
            style: theme.textTheme.bodySmall!.copyWith(
              color: ColorsManager.primaryColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
