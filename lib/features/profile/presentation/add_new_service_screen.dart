import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class AddNewServiceScreen extends StatelessWidget {
  const AddNewServiceScreen({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.addNewService,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.serviceName,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                type: TextInputType.text,
                hintText: "Enter service name",
                fieldName: LocaleKeys.serviceName,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.classification,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomDropdownField<String>(
                hintText: LocaleKeys.chooseClassification,
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
              const SizedBox(height: 16),
              Text(
                LocaleKeys.priceAverage,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                type: TextInputType.number,
                hintText: "Enter average price",
                fieldName: LocaleKeys.priceAverage,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.serviceDetails,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                type: TextInputType.multiline,
                maxLines: 5,
                hintText: "Enter service details",
                fieldName: LocaleKeys.serviceDetails,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.servicePhotos,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 135,
                width: double.infinity,
                padding: const EdgeInsetsDirectional.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsManager.secondaryColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      MyIcons.uploadfile,
                      size: 48,
                      color: ColorsManager.secondaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.uploadPhotos,
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(onPressed: () {}, text: LocaleKeys.save),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
