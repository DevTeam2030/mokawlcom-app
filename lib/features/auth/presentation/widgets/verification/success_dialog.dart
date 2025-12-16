import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AssetsManager.successCheck,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            Text(
              LocaleKeys.registerSuccess,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: const Color(0xFF235C04),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              LocaleKeys.yourAccountCreatedSuccessfully,
              style: theme.textTheme.titleMedium!.copyWith(
                color: const Color(0xFF449C0A),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {},
              text: LocaleKeys.continueKey,
            ),
          ],
        ),
      ),
    );
  }
}
