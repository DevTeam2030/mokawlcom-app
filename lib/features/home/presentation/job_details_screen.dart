import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/job_details/job_details_top_section.dart';
import 'package:mokawlcom_app/features/shared/widgets/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/job_details/service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key, this.isOfferrice = false});
  final bool isOfferrice;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isOfferrice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomSheet(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 16.0,
          end: 16.0,
          bottom: 20.0,
        ),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: JobDetailsTopSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),

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
                        labelStyle: theme.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: theme.textTheme.labelMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        onTap: tabsRouter.setActiveIndex,
                        tabs: [
                          Tab(text: LocaleKeys.companyDetails,),
                          Tab(text: LocaleKeys.services),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: child),
                      const SizedBox(height: 10),
                      PrimaryButton(
                        onPressed: () async {
                          await _showBottomSheet(context);
                        },
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

  Future<void> _showBottomSheet(BuildContext context) async {
    if (!mounted) return;
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) =>
          OfferPriceBottomSheet(address: LocaleKeys.offerPrice),
    );
  }
}
