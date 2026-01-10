import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/profile_avatar_with_edit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class EditContractorProfileScreen extends StatelessWidget {
  const EditContractorProfileScreen({super.key});

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
              const ProfileAvatarWithEdit(),
              const SizedBox(height: 60.0),
              Text(
                LocaleKeys.mainClassification,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomDropdownField<String>(
                hintText: LocaleKeys.chooseClassification,
                theme: theme,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'classification1',
                    child: Text('Classification 1'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'classification2',
                    child: Text('Classification 2'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'classification3',
                    child: Text('Classification 3'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.subcategory,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomDropdownField<String>(
                hintText: LocaleKeys.chooseServices,
                theme: theme,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'service1',
                    child: Text('Service 1'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'service2',
                    child: Text('Service 2'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'service3',
                    child: Text('Service 3'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.name,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.name,
                hintText: LocaleKeys.pleaseEnterYourName,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.name,
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
              CustomTextFormField(
                type: TextInputType.phone,
                hintText: LocaleKeys.pleaseEnterYourPhone,
                autofillHints: const [AutofillHints.telephoneNumber],
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.phone,
              ),

              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.whatsApp,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.phone,
                hintText: "+966 123432123",
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.whatsApp,
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
              CustomTextFormField(
                type: TextInputType.streetAddress,
                hintText: "الخليج الغربي - الدوحة",
                autofillHints: const [AutofillHints.addressCityAndState],
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.address,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.socialMedia,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.snapchat,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.text,
                hintText: "@snap_user",
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.snapchat,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.twitter,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.text,
                hintText: "@username",
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.twitter,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.facebook,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.text,
                hintText: "https://www.facebook.com/username",
                textInputAction: TextInputAction.next,
                fieldName: LocaleKeys.facebook,
              ),
              const SizedBox(height: 8.0),
              Text(
                LocaleKeys.hintAboutCompany,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                type: TextInputType.multiline,
                maxLines: 10,
                textInputAction: TextInputAction.done,
                fieldName: LocaleKeys.hintAboutCompany,
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
