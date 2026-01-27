import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
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
          routes: AppConstants.userType == UserType.contractor
              ? const [PublicNotificationsRoute(), PriceOffersRoute()]
              : const [PublicNotificationsRoute(), SubmittedPriceOffersRoute()],
          builder: (context, child, controller) {
            final tabsRouter = AutoTabsRouter.of(context);

            return Column(
              children: [
                const SizedBox(height: 10),
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
                  labelStyle: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: theme.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: tabsRouter.setActiveIndex,
                  tabs: AppConstants.userType == UserType.contractor
                      ? [
                          Tab(text: LocaleKeys.publicNotifications),
                          Tab(text: LocaleKeys.pricesOffers),
                        ]
                      : [
                          Tab(text: LocaleKeys.publicNotifications),
                          Tab(text: LocaleKeys.submittedPriceOffers),
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
