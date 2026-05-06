import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localingo/localingo.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_banner_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_departments_section.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_header.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/home/home_search_section.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/shared/data/models/app_version_model.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

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
      if (mounted) {
        final versionData = await context.read<AppCubit>().checkAppVersion();
        if (mounted && versionData != null) {
          await _showUpdateDialog(versionData);
        }
      }
    });
  }

  Future<void> _showUpdateDialog(PlatformVersionModel versionData) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await showCupertinoDialog<void>(
        context: context,
        barrierDismissible: !versionData.forceUpdate,
        builder: (dialogContext) {
          return PopScope(
            canPop: !versionData.forceUpdate,
            child: CupertinoAlertDialog(
              title: Text(
                versionData.forceUpdate
                    ? LocaleKeys.updateRequired
                    : LocaleKeys.updateAvailable,
                style: Theme.of(dialogContext).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ColorsManager.primaryColor,
                ),
              ),
              content: Text(versionData.message),
              actions: [
                if (!versionData.forceUpdate)
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      LocaleKeys.later,
                      style: Theme.of(dialogContext).textTheme.bodyMedium!
                          .copyWith(
                            color: ColorsManager.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    await _openUpdateUrl(
                      dialogContext: dialogContext,
                      updateUrl: versionData.updateUrl,
                    );
                  },
                  child: Text(
                    LocaleKeys.updateNow,
                    style: Theme.of(dialogContext).textTheme.bodyMedium!
                        .copyWith(
                          color: ColorsManager.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: !versionData.forceUpdate,
      builder: (dialogContext) {
        return PopScope(
          canPop: !versionData.forceUpdate,
          child: Dialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      color: ColorsManager.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    versionData.forceUpdate
                        ? LocaleKeys.updateRequired
                        : LocaleKeys.updateAvailable,
                    style: Theme.of(dialogContext).textTheme.titleMedium!
                        .copyWith(
                          fontWeight: FontWeight.w800,
                          color: ColorsManager.primaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    versionData.message,
                    style: Theme.of(dialogContext).textTheme.bodyMedium!
                        .copyWith(
                          color: ColorsManager.textColor.withValues(
                            alpha: 0.82,
                          ),
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    onPressed: () async {
                      await _openUpdateUrl(
                        dialogContext: dialogContext,
                        updateUrl: versionData.updateUrl,
                      );
                    },
                    text: LocaleKeys.updateNow,
                  ),
                  if (!versionData.forceUpdate) ...[
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.later,
                        style: Theme.of(dialogContext).textTheme.bodyMedium!
                            .copyWith(
                              color: ColorsManager.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openUpdateUrl({
    required BuildContext dialogContext,
    required String updateUrl,
  }) async {
    await LaunchUtils.open(
      url: updateUrl,
      onError: (msg) {
        if (!dialogContext.mounted) return;
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(
            content: Text(
              msg.tr(dialogContext),
              style: Theme.of(
                dialogContext,
              ).textTheme.bodyMedium!.copyWith(color: ColorsManager.textColor),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadData() async {
    if (mounted && AppConstants.userType == UserType.contractor) {
      await Future.wait([
        context.read<HomeCubit>().getBanners(),
        context.read<HomeCubit>().getClassifications(),
        context.read<NotificationsCubit>().getPublicNotifications(),
        context.read<NotificationsCubit>().getOfferNotifications(),
      ]);
    } else if (mounted && AppConstants.userType == UserType.user) {
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
      body: SafeArea(
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
