import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home/home_filter_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key});

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: TextField(
                focusNode: _focusNode,
                onTapOutside: (_) => _focusNode.unfocus(),
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
          ),
          IconButton(
            onPressed: () async {
              _focusNode.unfocus();
              await showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                context: context,
                builder: (context) => const HomeFilterBottomSheet(),
              );
            },
            icon: const Icon(Icons.filter_list, size: 46),
          ),
        ],
      ),
    );
  }
}
