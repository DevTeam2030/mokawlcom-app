import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/worker_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class HomeDepartmentsSection extends StatelessWidget {
  const HomeDepartmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              LocaleKeys.departments,
              style: theme.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.grayText,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 30,
          runSpacing: 24,
          children: List.generate(
            9,
            (index) => WorkerItem(
              onTap: () {
                context.pushRoute(const ServicesRoute());
              },
            ),
          ),
        ),
      ],
    );
  }
}
