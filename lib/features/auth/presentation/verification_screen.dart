import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.verificationCode,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Text(
              LocaleKeys.verificationCodeSent,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                color: ColorsManager.secondaryColor,
              ),
            ),
            const Spacer(),
            Pinput(
              length: 6,
              defaultPinTheme: PinTheme(
                width: 48,
                height: 48,
                textStyle: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsManager.secondaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsManager.secondaryColor,
                    width: 4,
                  ),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorsManager.primaryColor,
                    width: 1.5,
                  ),
                ),
                textStyle: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              onCompleted: (value) {
                // verify otp
              },
            ),
            const Spacer(),
            PrimaryButton(
              onPressed: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) => const ErrorDialog(),
                );
              },
              text: LocaleKeys.verify,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
