import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/arabic_countries.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class CustomIntlPhoneField extends StatelessWidget {
  const CustomIntlPhoneField({
    super.key,
    this.onChanged,
    this.initialCountryCode = 'QA',
    this.label,
    this.borderRadius,
    this.fillColor,
    this.prefixIcon,
    this.enabled = true,
    this.onSubmitted,
    this.textInputAction,
    this.validator,
    this.controller,
  });

  final void Function(String completeNumber, String countryCode)? onChanged;
  final String initialCountryCode;
  final String? label;
  final double? borderRadius;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool enabled;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final locale = Localizations.localeOf(context);
    // final languageCode = locale.languageCode;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        pickerDialogStyle: PickerDialogStyle(
          searchFieldInputDecoration: InputDecoration(
            labelText: LocaleKeys.searchCountry,
            hintText: LocaleKeys.searchCountry,
          ),
        ),
        languageCode: AppConstants.language,
        countries: getLocalizedCountries(context),
        controller: controller,
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),

        dropdownTextStyle: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorsManager.primaryColor,
          fontSize: 14,
        ),
        enabled: enabled,
        initialCountryCode: initialCountryCode,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction ?? TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        validator:
            validator ??
            (phone) {
              if (phone == null ||
                  phone.number.isEmpty ||
                  phone.completeNumber.isEmpty) {
                return LocaleKeys.pleaseEnterYourPhone;
              }
              return null;
            },

        decoration: InputDecoration(
          labelText: label ?? "",
          filled: true,
          fillColor: fillColor ?? Colors.transparent,
          prefixIcon: prefixIcon,
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: const BorderSide(color: ColorsManager.secondaryColor),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: const BorderSide(
              color: ColorsManager.primaryColor,
              width: 2,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
          ),
        ),

        onChanged: (phone) {
          if (onChanged != null) {
            onChanged!(phone.completeNumber, phone.countryCode);
          }
        },
      ),
    );
  }
}
