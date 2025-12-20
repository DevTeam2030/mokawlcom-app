import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class OfferPriceBottomSheet extends StatelessWidget {
  const OfferPriceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              LocaleKeys.offerPrice,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.price,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const CustomTextFormField(
            textInputAction: TextInputAction.next,
            type: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.message,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const CustomTextFormField(
            textInputAction: TextInputAction.next,
            type: TextInputType.text,
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.attachAFile,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
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
              children: [
                const Icon(
                  MyIcons.uploadFile,
                  size: 48,
                  color: ColorsManager.secondaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  '${LocaleKeys.uploadFile} PDF/JPG',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: ColorsManager.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: LocaleKeys.send,
          ),
        ],
      ),
    );
  }
}
