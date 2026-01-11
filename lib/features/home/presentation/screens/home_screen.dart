import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_banner_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_departments_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_header.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_search_section.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.isConnected != current.isConnected,
            builder: (context, state) {
              return state.isConnected
                  ? CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        const SliverToBoxAdapter(child: HomeHeader()),
                        SliverToBoxAdapter(
                          child: HomeBannerSection(theme: theme),
                        ),
                        SliverToBoxAdapter(
                          child: HomeSearchSection(theme: theme),
                        ),
                        SliverToBoxAdapter(
                          child: HomeDepartmentsSection(theme: theme),
                        ),
                      ],
                    )
                  : NoInternetWidget(
                      errorMessage: state.bannersErrorMessage,
                      theme: theme,
                      onPressed: () async {
                        await Future.wait([
                          context.read<HomeCubit>().getBanners(),
                          context.read<HomeCubit>().getClassifications(),
                        ]);
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
