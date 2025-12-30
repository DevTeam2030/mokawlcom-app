import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRoute(), NotificationsRoute(), ProfileRoute()],
      transitionBuilder: (context, child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },

      bottomNavigationBuilder: (context, tabsRouter) {
        return Container(
          height: 72,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: ColorsManager.navBorderColor, width: 1.5),
            ),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16),
              topEnd: Radius.circular(16),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(16),
              topEnd: Radius.circular(16),
            ),
            child: BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) {
                tabsRouter.setActiveIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(MyIcons.home),
                  label: LocaleKeys.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(MyIcons.notification),
                  label: LocaleKeys.notifications,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(MyIcons.user),
                  label: LocaleKeys.profile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
