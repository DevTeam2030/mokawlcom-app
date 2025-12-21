import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.notifications,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: AutoTabsRouter.tabBar(
          routes: const [PublicNotificationsRoute(), PriceOffersRoute()],
          builder: (context, child, controller) {
            final tabsRouter = AutoTabsRouter.of(context);

            return Column(
              children: [
                const SizedBox(height: 24),
                TabBar(
                  controller: controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // dividerColor: ColorsManager.primaryColor.withValues(
                  //   alpha: .2,
                  // ),
                  dividerHeight: 2,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: ColorsManager.primaryColor,
                      width: 2,
                    ),
                  ),
                  onTap: tabsRouter.setActiveIndex,
                  tabs: [
                    Text(
                      LocaleKeys.publicNotifications,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      LocaleKeys.pricesOffers,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Expanded(child: child),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
