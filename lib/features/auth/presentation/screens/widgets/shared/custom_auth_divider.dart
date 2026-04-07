import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class CustomAuthDivider extends StatelessWidget {
  const CustomAuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1.0)),
        const SizedBox(width: 16.0),
        Text(
          LocaleKeys.or,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16.0),
        const Expanded(child: Divider(thickness: 1.0)),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
