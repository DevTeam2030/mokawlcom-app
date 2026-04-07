import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.theme,
    required this.message,
    this.buttonText = "",
  });
  final ThemeData theme;
  final String message;
  final String buttonText;
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
            Lottie.asset(AssetsManager.wrongAnimation, width: 150, height: 150),
            const SizedBox(height: 10),
            Text(
              message,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorsManager.errorDark,
              ),
              textAlign: TextAlign.center,
            ),
            // Text(
            //   LocaleKeys.pleaseEnterTheCorrectCode,
            //   style: theme.textTheme.titleMedium!.copyWith(
            //     color: ColorsManager.errorLight,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: buttonText == "" ? LocaleKeys.tryAgain : buttonText,
            ),
          ],
        ),
      ),
    );
  }
}
