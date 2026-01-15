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
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_cubit.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_state.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/contractor_info_cubit/contractor_info_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/contractor_details_top_section.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ContractorDetailsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const ContractorDetailsScreen({
    super.key,
    this.isOfferrice = false,
    required this.contractorId,
  });

  final bool isOfferrice;
  final int contractorId;

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
        _showBottomSheet(context: context, contractorId: widget.contractorId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ContractorInfoCubit, ContractorInfoState>(
      listenWhen: (prev, curr) =>
          prev.getContractorDetailsState != curr.getContractorDetailsState,
      listener: (context, state) {
        if (state.getContractorDetailsState.isError) {
          showToast(message: state.errorMessage, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state.isConnected
              ? AppBar(
                  actions: [
                    BlocSelector<
                      ContractorInfoCubit,
                      ContractorInfoState,
                      bool
                    >(
                      selector: (state) => state.isSaved,
                      builder: (context, isSaved) {
                        return state.getContractorDetailsState.isLoading
                            ? const SizedBox.shrink()
                            : IconButton(
                          onPressed: () {
                            context.read<AppCubit>().handleProtectedNavigation(
                              context: context,
                              onAllowed: () {
                                if (isSaved) {
                                  context.read<FavoriteCubit>().removeFavorite(
                                    contractorId: widget.contractorId,
                                  );
                                } else {
                                  context.read<FavoriteCubit>().addFavorite(
                                    contractorId: widget.contractorId,
                                  );
                                }
                                context
                                    .read<ContractorInfoCubit>()
                                    .toggleFavorite();
                              },
                            );
                          },
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark_outlined
                                : Icons.bookmark_add_outlined,
                          ),
                        );
                      },
                    ),
                  ],
                )
              : null,
          body: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
              bottom: 20,
            ),
            child: _buildBody(state, theme),
          ),
        );
      },
    );
  }

  Widget _buildBody(ContractorInfoState state, ThemeData theme) {
    if (!state.isConnected) {
      return NoInternetWidget(
        errorMessage: state.errorMessage,
        theme: theme,
        onPressed: () {
          context.read<ContractorInfoCubit>().getContractorDetails(
            contractorId: widget.contractorId,
          );
        },
      );
    }

    return UiStateBuilder(
      state: state.getContractorDetailsState,
      onLoading: Skeletonizer(
        containersColor: ColorsManager.skeletonColor,
        enabled: state.getContractorDetailsState.isLoading,
        child: _buildContractorDetails(state, theme),
      ),
      onSuccess: _buildContractorDetails(state, theme),
      errorMessage: state.errorMessage,
      theme: theme,
    );
  }

  CustomScrollView _buildContractorDetails(
    ContractorInfoState state,
    ThemeData theme,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ContractorDetailsTopSection(
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
                  const SizedBox(height: 8),
                  PrimaryButton(
                    text: LocaleKeys.offerPrice,
                    onPressed: () {
                      context.read<AppCubit>().handleProtectedNavigation(
                        context: context,
                        onAllowed: () async {
                          await _showBottomSheet(
                            context: context,
                            contractorId: widget.contractorId,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showBottomSheet({
    required BuildContext context,
    required int contractorId,
  }) async {
    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: OfferPriceBottomSheet(
            address: LocaleKeys.offerPrice,
            contractorId: contractorId,
          ),
        );
      },
    );
  }
}
