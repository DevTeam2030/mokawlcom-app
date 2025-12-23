import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.color = ColorsManager.secondaryColor,
    this.thickness = 0.55,
    this.height = 20,
  });

  final Color color;
  final double thickness;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(color: color, thickness: thickness, height: height);
  }
}
