import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final ValueNotifier<String?> selectedClassification = ValueNotifier<String?>(
    null,
  );

  final ValueNotifier<String?> selectedService = ValueNotifier<String?>(null);
  final List<String> classifications = [
    'Classification 1',
    'Classification 2',
    'Classification 3',
  ];
  final List<String> services = ['Service 1', 'Service 2', 'Service 3'];

  @override
  void dispose() {
    selectedClassification.dispose();
    selectedService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20.0,
        vertical: 40.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              LocaleKeys.resultsFilter,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorsManager.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.classification,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<String?>(
            valueListenable: selectedClassification,
            builder: (context, value, _) {
              return CustomDropdownField<String>(
                value: value,
                hintText: LocaleKeys.chooseClassification,
                items: classifications
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  selectedClassification.value = newValue;
                },
              );
            },
          ),

          const SizedBox(height: 22),

          Text(
            LocaleKeys.services,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<String?>(
            valueListenable: selectedService,
            builder: (context, value, _) {
              return CustomDropdownField<String>(
                value: value,
                hintText: LocaleKeys.chooseServices,
                items: services
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  selectedService.value = newValue;
                },
              );
            },
          ),

          const SizedBox(height: 30),

          PrimaryButton(onPressed: () {}, text: LocaleKeys.applyFilter),
        ],
      ),
    );
  }
}
