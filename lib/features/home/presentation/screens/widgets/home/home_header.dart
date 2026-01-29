import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_logout_bottom_sheet.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/visitor_access_dialog.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: ColorsManager.primaryColor,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: ColorsManager.secondaryColor,
              backgroundImage: AssetImage(AssetsManager.appLogo),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              Text(
                LocaleKeys.mokawlatcom,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                LocaleKeys.fasterAcessBestResults,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: ColorsManager.secondaryColor,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              context.read<AppCubit>().handleProtectedNavigation(
                context: context,
                onAllowed: () {
                  context.pushRoute(const SavedCompaniesRoute());
                },
              );
            },
            child: const Icon(
              MyIcons.bookmarks,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              context.read<AppCubit>().handleProtectedNavigation(
                context: context,
                onAllowed: () {
                  final tabsRouter = AutoTabsRouter.of(context);
                  tabsRouter.setActiveIndex(1);
                },
              );
            },
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              buildWhen: (prev, current) =>
                  prev.unReadPublicNotifications !=
                      current.unReadPublicNotifications ||
                  prev.unReadOfferNotifications !=
                      current.unReadOfferNotifications,
              builder: (context, state) {
                return Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: ColorsManager.primaryColor,
                      size: 28,
                    ),
                    if (state.unReadPublicNotifications.isNotEmpty ||
                        state.unReadOfferNotifications.isNotEmpty)
                      const PositionedDirectional(
                        top: 1,
                        start: 2,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
