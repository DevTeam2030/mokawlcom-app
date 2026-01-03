import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    this.value,
    required this.items,
    this.hintText,
    this.label,
    this.onChanged, required this.theme,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;
  final String? label;
  final void Function(T?)? onChanged;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () => _openBottomSheet(context, theme),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsManager.fillColor,
          labelText: label,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(20),
          hintStyle: theme.textTheme.labelLarge!.copyWith(
            color: ColorsManager.secondaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: ColorsManager.secondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorsManager.primaryColor,
              width: 2,
            ),
          ),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: ColorsManager.secondaryColor,
          ),
        ),
        child: value == null
            ? Text(
                hintText ?? '',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: ColorsManager.secondaryColor,
                ),
              )
            : items.firstWhere((e) => e.value == value).child,
      ),
    );
  }

  void _openBottomSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),

                if (label != null || hintText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      label ?? hintText!,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    indent: 24,
                    endIndent: 24,
                    color: ColorsManager.dividerGray,
                  ),
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final selected = item.value == value;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      title: DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: selected
                              ? ColorsManager.primaryColor
                              : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        child: item.child,
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color: ColorsManager.primaryColor,
                            )
                          : null,
                      onTap: () {
                        onChanged?.call(item.value);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
