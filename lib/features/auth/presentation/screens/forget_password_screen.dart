import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          LocaleKeys.resetPassword,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: ColorsManager.primaryColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              LocaleKeys.enterYourMail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.secondaryColor,
              ),
            ),

            const SizedBox(height: 40),

            Text(
              LocaleKeys.email,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              type: TextInputType.emailAddress,
              hintText: "user@example.com",
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.done,
              fieldName: LocaleKeys.email,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: PrimaryButton(onPressed: () {}, text: LocaleKeys.send),
        ),
      ),
    );
  }
}
