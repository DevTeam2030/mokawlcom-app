import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    this.onPressed,
    required this.theme,
    required this.text,
    required this.message,
  });
  final void Function()? onPressed;
  final ThemeData theme;
  final String text;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(AssetsManager.successCheck, width: 150, height: 150),
            const SizedBox(height: 10),
            Text(
              message,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorsManager.successDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed:
                  onPressed ??
                  () {
                    context.pop();
                  },
              text: text,
            ),
          ],
        ),
      ),
    );
  }
}
