import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_banner_section.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_header.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
        child: SafeArea(
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 16),
              const HomeBannerSection(),
              const SizedBox(height: 16),
              Padding(
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
                            borderSide: BorderSide(
                              color: ColorsManager.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 48),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                LocaleKeys.departments,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF494949),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
