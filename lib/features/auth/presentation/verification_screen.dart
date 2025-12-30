import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.verificationCode,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                LocaleKeys.verificationCodeSent,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.secondaryColor,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Align(
              alignment: AlignmentDirectional.center,
              child: Pinput(
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
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: PrimaryButton(
            onPressed: () {
              context.pushRoute(const UploadFilesRoute());
            },
            text: LocaleKeys.verify,
          ),
        ),
      ),
    );
  }
}
