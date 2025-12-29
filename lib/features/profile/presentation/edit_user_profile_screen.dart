import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/shared/widgets/profile_avatar_with_edit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class EditUserProfileScreen extends StatelessWidget {
  const EditUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.editMyProfile,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28.0),
              const ProfileAvatarWithEdit(isUserProfile: true),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.name,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.name,
                hintText: "Abdullah Ahmed",
                autofillHints: [AutofillHints.name],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.email,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.emailAddress,
                hintText: "example@email.com",
                autofillHints: [AutofillHints.email],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.phone,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.phone,
                hintText: "Enter your phone number",
                autofillHints: [AutofillHints.telephoneNumber],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.address,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.streetAddress,
                hintText: "Enter your address",
                autofillHints: [AutofillHints.fullStreetAddress],
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 40.0),
              PrimaryButton(onPressed: () {}, text: LocaleKeys.save),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
