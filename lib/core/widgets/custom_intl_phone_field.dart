import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class CustomIntlPhoneField extends StatefulWidget {
  const CustomIntlPhoneField({
    super.key,
    this.controller,
    this.onChanged,
    this.initialCountryCode = 'EG',
    this.label,
    this.borderRadius,
    this.fillColor,
    this.prefixIcon,
    this.enabled = true,
    this.onSubmitted,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final void Function(String completeNumber, String countryCode)? onChanged;
  final String initialCountryCode;
  final String? label;
  final double? borderRadius;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool enabled;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  State<CustomIntlPhoneField> createState() => _CustomIntlPhoneFieldState();
}

class _CustomIntlPhoneFieldState extends State<CustomIntlPhoneField> {
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FormField<String>(
        validator: (value) {
          if (_phoneController.text.isEmpty) {
            return LocaleKeys.pleaseEnterYourPhone;
          }
          return null;
        },
        builder: (fieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntlPhoneField(
                controller: _phoneController,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
                dropdownTextStyle: Theme.of(context).textTheme.bodySmall!
                    .copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                      fontSize: 14,
                    ),
                onSubmitted: widget.onSubmitted,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                enabled: widget.enabled,
                initialCountryCode: widget.initialCountryCode,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  labelText: widget.label ?? "",
                  filled: true,
                  fillColor: widget.fillColor ?? Colors.transparent,
                  errorText: fieldState.errorText,
                  prefixIcon: widget.prefixIcon,
                  contentPadding: const EdgeInsets.all(20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8,
                    ),
                    borderSide: const BorderSide(
                      color: ColorsManager.secondaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8,
                    ),
                    borderSide: const BorderSide(
                      color: ColorsManager.primaryColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8,
                    ),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8,
                    ),
                    borderSide: const BorderSide(
                      color: ColorsManager.secondaryColor,
                    ),
                  ),
                ),
                validator: (phone) {
                  if (phone == null || phone.completeNumber.isEmpty) {
                    return LocaleKeys.pleaseEnterYourPhone;
                  }
                  return null;
                },
                onChanged: (phone) {
                  fieldState.didChange(phone.completeNumber);
                  if (widget.onChanged != null) {
                    widget.onChanged!(phone.completeNumber, phone.countryCode);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
