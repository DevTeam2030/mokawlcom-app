import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/job_details/job_details_top_section.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/job_details/service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F6),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: JobDetailsTopSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 34)),

            SliverFillRemaining(
              child: AutoTabsRouter.tabBar(
                routes: const [CompanyDetailsRoute(), ServicesDetailsRoute()],
                builder: (context, child, controller) {
                  final tabsRouter = AutoTabsRouter.of(context);

                  return Column(
                    children: [
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
                            LocaleKeys.companyDetails,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            LocaleKeys.services,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Expanded(child: child),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        onPressed: () {},
                        text: LocaleKeys.offerPrice,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
