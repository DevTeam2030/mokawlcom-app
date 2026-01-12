import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/job_details/job_details_top_section.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/job_details/service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ContractorDetailsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const ContractorDetailsScreen({
    super.key,
    this.isOfferrice = false,
    required this.contractorId, required this.serviceId,
  });
  final bool isOfferrice;
  final int contractorId;
  final int serviceId;
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (context) =>
        getIt<ContractorInfoCubit>()
          ..getContractorDetails(contractorId: contractorId),
    child: this,
  );
  @override
  State<ContractorDetailsScreen> createState() =>
      _ContractorDetailsScreenState();
}

class _ContractorDetailsScreenState extends State<ContractorDetailsScreen> {
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
            onPressed: () {
              context.read<AppCubit>().handleProtectedNavigation(
                context: context,
                onAllowed: () {},
              );
            },
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
        child: BlocConsumer<ContractorInfoCubit, ContractorInfoState>(
          listenWhen: (previous, current) =>
              previous.getContractorDetailsState !=
              current.getContractorDetailsState,
          buildWhen: (previous, current) =>
              previous.getContractorDetailsState !=
              current.getContractorDetailsState,
          listener: (context, state) {
            if (state.getContractorDetailsState.isError) {
              showToast(message: state.errorMessage, state: ToastStates.error);
            }
          },
          builder: (context, state) => UiStateBuilder(
            state: state.getContractorDetailsState,
            onLoading: Skeletonizer(
              child: _buildContractorDetails(state, theme),
            ),
            onSuccess: _buildContractorDetails(state, theme),
            errorMessage: state.errorMessage,
            theme: theme,
          ),
        ),
      ),
    );
  }

  CustomScrollView _buildContractorDetails(
    ContractorInfoState state,
    ThemeData theme,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: JobDetailsTopSection(
            contractorDetailsModel: state.contractorDetails,
            theme: theme,
          ),
        ),
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
                    unselectedLabelStyle: theme.textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    onTap: tabsRouter.setActiveIndex,
                    tabs: [
                      Tab(text: LocaleKeys.companyDetails),
                      Tab(text: LocaleKeys.services),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: child),
                  const SizedBox(height: 1),
                  PrimaryButton(
                    onPressed: () {
                      // context.read<AppCubit>().handleProtectedNavigation(
                      //   context: context,
                      //   onAllowed: () async{
                      //     await _showBottomSheet(context);
                      //   },
                      // );
                      _showBottomSheet(context);
                    },
                    text: LocaleKeys.offerPrice,
                  ),
                ],
              );
            },
          ),
        ),
      ],
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
