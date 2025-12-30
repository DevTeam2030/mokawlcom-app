import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FittedBox(
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsetsDirectional.all(12.0),
        height: 46,
        decoration: BoxDecoration(
          color: ColorsManager.fillColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(),
        ),
        child: Text(
          "تشطيبات",
          style: theme.textTheme.bodySmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
