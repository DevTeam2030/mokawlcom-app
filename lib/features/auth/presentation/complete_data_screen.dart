import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/shared/widgets/profile_avatar_with_edit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class CompleteDataScreen extends StatelessWidget {
  const CompleteDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.completeData,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28.0),
              const ProfileAvatarWithEdit(),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.name,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
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
                LocaleKeys.phone,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
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
                LocaleKeys.whatsApp,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.phone,
                hintText: "WhatsApp number",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.socialMedia,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.snapchat,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.text,
                hintText: "snap_user",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.twitter,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.text,
                hintText: "@username",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.facebook,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.text,
                hintText: "Profile link",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.hintAboutCompany,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8.0),
              const CustomTextFormField(
                type: TextInputType.text,
                maxLines: 10,
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
