import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    this.hintText,
    this.label,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;
  final String? label;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsManager.fillColor,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: ColorsManager.secondaryColor,
          fontWeight: FontWeight.w400,
        ),
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        contentPadding: const EdgeInsets.all(20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: ColorsManager.secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: ColorsManager.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: ColorsManager.secondaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: ColorsManager.secondaryColor),
        ),
      ),
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: ColorsManager.secondaryColor,
      ),
      isExpanded: true,
    );
  }
}
