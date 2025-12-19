import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home/home_filter_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.search,
                  color: ColorsManager.secondaryColor,
                ),
                hintText: LocaleKeys.searchForWordOrDepartment,
                hintStyle: theme.textTheme.labelSmall!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: ColorsManager.secondaryColor),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                context: context,
                builder: (context) => const HomeFilterBottomSheet(),
              );
            },
            icon: const Icon(Icons.filter_list, size: 48),
          ),
        ],
      ),
    );
  }
}
