import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.email,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const CustomTextFormField(
          type: TextInputType.text,
          hintText: "example@gmai.com",
          autofillHints: [AutofillHints.email],
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 8.0),
        Text(
          LocaleKeys.password,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const PasswordField(
          hintText: "********",
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 16.0),
        Align(
          alignment: AlignmentDirectional.center,
          child: Text(
            LocaleKeys.forgetPassword,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        PrimaryButton(onPressed: () {}, text: LocaleKeys.login),
      ],
    );
  }
}
