import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class SendOfferToContractorsScreen extends StatelessWidget {
  const SendOfferToContractorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.sendOfferToContractors,
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
                LocaleKeys.shareYourDealNow,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.offerAddress,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                textInputAction: TextInputAction.next,
                type: TextInputType.text,
                hintText: "",
                fieldName: LocaleKeys.offerAddress,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.offerDetails,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                textInputAction: TextInputAction.done,
                type: TextInputType.multiline,
                maxLines: 20,
                hintText: "",
                fieldName: LocaleKeys.offerDetails,
              ),
              const SizedBox(height: 72),
              PrimaryButton(onPressed: () {}, text: LocaleKeys.save),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
