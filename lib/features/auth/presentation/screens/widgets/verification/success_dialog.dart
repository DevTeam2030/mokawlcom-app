import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    required this.onPressed,
    required this.theme,
    required this.text,
  });
  final void Function() onPressed;
  final ThemeData theme;
  final String text;
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
              LocaleKeys.registerSuccess,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorsManager.successDark,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.yourAccountCreatedSuccessfully,
              style: theme.textTheme.titleMedium!.copyWith(
                color: ColorsManager.successLight,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(onPressed: onPressed, text: text),
          ],
        ),
      ),
    );
  }
}
