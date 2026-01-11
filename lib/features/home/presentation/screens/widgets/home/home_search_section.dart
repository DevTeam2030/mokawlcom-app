import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_filter_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key, required this.theme});
  final ThemeData theme;
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
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) =>
            previous.getBannersState != current.getBannersState,
        builder: (context, state) {
          return Skeletonizer(
            enabled: state.getBannersState.isLoading,
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
                        hintStyle: widget.theme.textTheme.labelSmall!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: ColorsManager.secondaryColor,
                          ),
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
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
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
        },
      ),
    );
  }
}
