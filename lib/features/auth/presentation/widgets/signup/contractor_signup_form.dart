import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class ContractorSignupForm extends StatelessWidget {
  const ContractorSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.companyName,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const CustomTextFormField(
          type: TextInputType.name,
          hintText: "Enter company name",
          autofillHints: [AutofillHints.organizationName],
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 8.0),
        Text(
          LocaleKeys.email,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const CustomTextFormField(
          type: TextInputType.emailAddress,
          hintText: "user@example.com",
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
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 8.0),
        Text(
          LocaleKeys.confirmPassword,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const PasswordField(
          hintText: "********",
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 8.0),
        Text(
          LocaleKeys.phone,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: ColorsManager.primaryColor,
          ),
        ),
        const SizedBox(height: 8.0),
        const CustomTextFormField(
          type: TextInputType.phone,
          hintText: "Enter your phone number",
          autofillHints: [AutofillHints.telephoneNumber],
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 90.0),
        PrimaryButton(
          onPressed: () {
            context.pushRoute(const VerificationRoute());
          },
          text: LocaleKeys.createAccount,
        ),
      ],
    );
  }
}
