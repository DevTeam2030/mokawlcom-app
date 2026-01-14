import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, required this.text, required this.theme});
  final String text;
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(image: AssetImage(AssetsManager.noDataImage)),
        Text(
          text,
          style: theme.textTheme.bodyLarge!.copyWith(color: ColorsManager.primaryColor),
        ),
      ],
    );
  }
}
