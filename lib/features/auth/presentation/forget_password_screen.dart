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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 60.0),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  LocaleKeys.enterYourMail,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              Text(
                LocaleKeys.email,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.emailAddress,
                hintText: "example@gmail.com",
                autofillHints: [AutofillHints.email],
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 62),
              PrimaryButton(onPressed: () {}, text: LocaleKeys.send),
            ],
          ),
        ),
      ),
    );
  }
}
