import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class WorkerItem extends StatelessWidget {
  const WorkerItem({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ColorsManager.lightGrayBg,
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.borderGray, width: 2),
              image: const DecorationImage(
                image: AssetImage(AssetsManager.contractor),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "استشاري",
          style: theme.textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorsManager.textColor,
            fontSize: 10,
          ),
        ),
        Text(
          "(20)",
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
