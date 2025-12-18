import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_banner_section.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_departments_section.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_header.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/home_search_section.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(vertical: 10),
        child: SafeArea(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(child: HomeBannerSection()),
              SliverToBoxAdapter(child: HomeSearchSection()),
              SliverToBoxAdapter(child: HomeDepartmentsSection()),
            ],
          ),
        ),
      ),
    );
  }
}
