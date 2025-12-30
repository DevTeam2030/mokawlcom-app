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
    final theme = Theme.of(context);

    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (state) {
        return InkWell(
          onTap: enabled ? () => _openBottomSheet(context, state) : null,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: _decoration(theme, state.errorText),
            child: _selectedValue(theme, state.value),
          ),
        );
      },
    );
  }

  // ---------- UI Helpers ----------

  InputDecoration _decoration(ThemeData theme, String? errorText) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      filled: true,
      fillColor: ColorsManager.fillColor,
      hintText: hintText,
      labelText: label,
      errorText: errorText,
      contentPadding: const EdgeInsets.all(20),
      hintStyle: theme.textTheme.labelLarge!.copyWith(
        color: ColorsManager.secondaryColor,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: theme.textTheme.bodySmall,
      enabledBorder: border(ColorsManager.secondaryColor),
      focusedBorder: border(ColorsManager.primaryColor, 2),
      errorBorder: border(theme.colorScheme.error),
      border: border(ColorsManager.secondaryColor),
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: ColorsManager.secondaryColor,
      ),
    );
  }

  Widget _selectedValue(ThemeData theme, T? currentValue) {
    if (currentValue == null) {
      return Text(
        hintText ?? '',
        style: theme.textTheme.labelLarge!.copyWith(
          color: ColorsManager.secondaryColor,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return items.firstWhere((e) => e.value == currentValue).child;
  }

  // ---------- Bottom Sheet ----------

  void _openBottomSheet(BuildContext context, FormFieldState<T> state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            _sheetHandle(),
            const SizedBox(height: 20),
            if (label != null || hintText != null)
              Text(
                label ?? hintText!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            const SizedBox(height: 12),
            _itemsList(context, state),
          ],
        ),
      ),
    );
  }

  Widget _sheetHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _itemsList(BuildContext context, FormFieldState<T> state) {
    return Flexible(
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 24,
          endIndent: 24,
          color: Color(0xFFEEEEEE),
        ),
        itemBuilder: (_, index) {
          final item = items[index];
          final selected = item.value == state.value;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            title: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: selected
                        ? ColorsManager.primaryColor
                        : Colors.black87,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                  ),
              child: item.child,
            ),
            trailing: selected
                ? const Icon(Icons.check_circle,
                    color: ColorsManager.primaryColor)
                : null,
            onTap: () {
              state.didChange(item.value);
              onChanged?.call(item.value);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
