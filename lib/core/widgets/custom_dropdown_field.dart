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
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (state) => InkWell(
        onTap: enabled ? () => _showPicker(context, state) : null,
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: _buildDecoration(context, state.errorText),
          child: _buildDisplayText(context, state.value),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(BuildContext context, String? errorText) {
    final theme = Theme.of(context);
    return InputDecoration(
      filled: true,
      fillColor: ColorsManager.fillColor,
      hintText: hintText,
      hintStyle: theme.textTheme.labelLarge!.copyWith(
        color: ColorsManager.secondaryColor,
        fontWeight: FontWeight.w400,
      ),
      labelText: label,
      labelStyle: theme.textTheme.bodySmall,
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _buildBorder(ColorsManager.secondaryColor),
      focusedBorder: _buildBorder(ColorsManager.primaryColor, 2),
      errorBorder: _buildBorder(theme.colorScheme.error),
      border: _buildBorder(ColorsManager.secondaryColor),
      errorText: errorText,
      suffixIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: ColorsManager.secondaryColor,
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildDisplayText(BuildContext context, T? currentValue) {
    final theme = Theme.of(context);
    final hintStyle = theme.textTheme.labelLarge!.copyWith(
      color: ColorsManager.secondaryColor,
      fontWeight: FontWeight.w400,
    );

    if (currentValue == null) {
      return Text(hintText ?? '', style: hintStyle);
    }

    final selectedItem = items.firstWhere(
      (item) => item.value == currentValue,
      orElse: () => items.first,
    );
    return selectedItem.child;
  }

  void _showPicker(BuildContext context, FormFieldState<T> state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              const SizedBox(height: 20),
              if (label != null || hintText != null) _buildTitle(context),
              const SizedBox(height: 12),
              _buildItemsList(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        label ?? hintText!,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: ColorsManager.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, FormFieldState<T> state) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 20, top: 4),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 24,
          endIndent: 24,
          color: Color(0xFFEEEEEE),
        ),
        itemBuilder: (context, index) =>
            _buildListItem(context, items[index], state),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    DropdownMenuItem<T> item,
    FormFieldState<T> state,
  ) {
    final isSelected = item.value == state.value;
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isSelected ? ColorsManager.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        child: item.child,
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: ColorsManager.primaryColor)
          : null,
      onTap: () {
        state.didChange(item.value);
        onChanged?.call(item.value);
        Navigator.pop(context);
      },
    );
  }
}
