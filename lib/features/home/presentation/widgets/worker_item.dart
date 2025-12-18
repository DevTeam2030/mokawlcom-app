import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class WorkerItem extends StatelessWidget {
  const WorkerItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.pushRoute(const ServicesRoute());
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: ColorsManager.fillColor,
              shape: BoxShape.circle,
              border: Border.all(color: ColorsManager.secondaryColor, width: 2),
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
