import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSubmit,
    this.onSaved,
    this.hintText,
    this.label,
    this.textInputAction,
    this.validator,
    this.onChanged,
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onSubmit;
  final String? hintText;
  final String? label;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier(true);

  @override
  void dispose() {
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.passwordIsRequired;
    }

    final minLength = value.length >= 6;

    if (!minLength) return LocaleKeys.passwordIsTooShort;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, isObscured, _) {
        return CustomTextFormField(
          type: TextInputType.visiblePassword,
          hintText: widget.hintText ?? "Password",
          label: widget.label,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          //  prefixIcon: const Icon(Icons.lock_outline),
          autofillHints: const [AutofillHints.password],
          obscureText: isObscured,
          suffixIcon: IconButton(
            onPressed: () => _obscureTextNotifier.value = !isObscured,
            icon: isObscured
                ? const Icon(Icons.visibility, color: ColorsManager.iconGray)
                : const Icon(
                    Icons.visibility_off,
                    color: ColorsManager.iconGray,
                  ),
          ),
          onSaved: widget.onSaved,
          onSubmit: widget.onSubmit,
          onChanged: widget.onChanged,
          validator: widget.validator ?? _validatePassword,
          fieldName: LocaleKeys.password,
        );
      },
    );
  }
}
