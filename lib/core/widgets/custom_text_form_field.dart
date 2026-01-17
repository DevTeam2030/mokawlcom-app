import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.label,
    this.onSuffixPress,
    this.hintText,
    this.onSubmit,
    this.borderRadius,
    this.enableBorderColor,
    this.onSaved,
    this.autofillHints,
    this.fillColor,
    this.textInputAction,
    this.contentPadding = 20.0,
    this.validator,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1, required this.fieldName, this.onChanged,
  });

  final TextEditingController? controller;
  final TextInputType type;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? label;
  final List<String>? autofillHints;
  final Function(String submittedText)? onSubmit;
  final Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;
  final VoidCallback? onSuffixPress;
  final String? hintText;
  final double? borderRadius;
  final Color? enableBorderColor;
  final Color? fillColor;
  final double contentPadding;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool? enabled;
  final bool readOnly;
  final int maxLines;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      maxLines: maxLines,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: type,
      obscureText: obscureText,
      onSaved: onSaved,
      onChanged: onChanged,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmit,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.transparent,
        errorStyle: Theme.of(context).textTheme.bodySmall,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: ColorsManager.secondaryColor,
          fontWeight: FontWeight.w400,
        ),
        errorMaxLines: 1,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        contentPadding: EdgeInsets.all(contentPadding),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          borderSide: BorderSide(
            color: enableBorderColor ?? ColorsManager.secondaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          borderSide: const BorderSide(
            color: ColorsManager.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          borderSide: BorderSide(
            color: enableBorderColor ?? Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value!.isEmpty) {
              return '$fieldName ${LocaleKeys.required}';
            }
            return null;
          },
    );
  }
}
