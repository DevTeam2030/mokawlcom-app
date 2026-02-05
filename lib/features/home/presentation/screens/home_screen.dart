import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_banner_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_departments_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_header.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_search_section.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:upgrader/upgrader.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    if (mounted) await context.read<AppCubit>().checkNotificationPermission();
  }

  Future<void> _loadData() async {
    if (mounted && AppConstants.userType == .contractor) {
      await Future.wait([
        context.read<HomeCubit>().getBanners(),
        context.read<HomeCubit>().getClassifications(),
        context.read<NotificationsCubit>().getPublicNotifications(),
        context.read<NotificationsCubit>().getOfferNotifications(),
      ]);
    } else if (mounted && AppConstants.userType == .user) {
      await Future.wait([
        context.read<HomeCubit>().getBanners(),
        context.read<HomeCubit>().getClassifications(),
        context.read<NotificationsCubit>().getPublicNotifications(),
        context.read<NotificationsCubit>().getUserOffers(),
      ]);
    } else {
      await Future.wait([
        context.read<HomeCubit>().getBanners(),
        context.read<HomeCubit>().getClassifications(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: UpgradeAlert(
        navigatorKey: getIt<AppRouter>().navigatorKey,
        dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
        showReleaseNotes: false,
        showIgnore: false,
        showLater: false,
        upgrader: Upgrader(
          languageCode: AppConstants.language,
          countryCode: "QA",
          // minAppVersion: "1.0.0",
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
          child: SafeArea(
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  previous.isConnected != current.isConnected,
              builder: (context, state) {
                if (!state.isConnected &&
                    state.classificationsModel.classifications.isEmpty) {
                  return NoInternetWidget(
                    errorMessage: state.bannersErrorMessage,
                    theme: theme,
                    onPressed: () async {
                      await _loadData();
                    },
                  );
                }
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: HomeHeader()),
                    SliverToBoxAdapter(child: HomeBannerSection(theme: theme)),
                    SliverToBoxAdapter(child: HomeSearchSection(theme: theme)),
                    SliverToBoxAdapter(
                      child: HomeDepartmentsSection(theme: theme),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
