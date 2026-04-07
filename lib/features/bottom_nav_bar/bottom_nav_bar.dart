import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/visitor_access_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

@RoutePage()
class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRoute(), NotificationsRoute(), ProfileRoute()],
      bottomNavigationBuilder: (context, tabsRouter) {
        return Container(
          height: 72,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: const BoxDecoration(
            color: ColorsManager.surfaceColor,
            border: Border(
              top: BorderSide(color: ColorsManager.navBorderColor, width: 1.5),
            ),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16),
              topEnd: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: MyIcons.home,
                label: LocaleKeys.home,
                isSelected: tabsRouter.activeIndex == 0,
                onTap: () => tabsRouter.setActiveIndex(0),
              ),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                buildWhen: (previous, current) {
                  return previous.unReadPublicNotifications !=
                          current.unReadPublicNotifications ||
                      previous.unReadOfferNotifications !=
                          current.unReadOfferNotifications;
                },
                builder: (context, state) {
                  final totalUnread =
                      state.unReadPublicNotifications.length +
                      state.unReadOfferNotifications.length;
                  return _NavItem(
                    icon: MyIcons.notification,
                    label: LocaleKeys.notifications,
                    isSelected: tabsRouter.activeIndex == 1,
                    badgeCount: totalUnread,
                    onTap: () {
                      context.read<AppCubit>().handleProtectedNavigation(
                        context: context,
                        onAllowed: () {
                          tabsRouter.setActiveIndex(1);
                        },
                      );
                    },
                  );
                },
              ),
              _NavItem(
                icon: MyIcons.user,
                label: LocaleKeys.profile,
                isSelected: tabsRouter.activeIndex == 2,
                onTap: () => tabsRouter.setActiveIndex(2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? ColorsManager.primaryColor
                      : ColorsManager.unselectedNavColor,
                  size: 24,
                ),
                if (badgeCount > 0)
                  PositionedDirectional(
                    top: -8,
                    start: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall!.copyWith(
                color: isSelected
                    ? ColorsManager.primaryColor
                    : ColorsManager.unselectedNavColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
