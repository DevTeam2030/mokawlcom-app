import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/deal/deal_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/available_deals/available_deals_item.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class AvailableDealsScreen extends StatefulWidget implements AutoRouteWrapper {
  const AvailableDealsScreen({super.key});

  @override
  State<AvailableDealsScreen> createState() => _AvailableDealsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (context) => getIt<UserDetailsCubit>()..getDeals(),
    child: this,
  );
}

class _AvailableDealsScreenState extends State<AvailableDealsScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<UserDetailsCubit>().loadMoreDeals();
    }
  }

  void _resetLoading(RequestStatus status) {
    if (_isLoadingMore &&
        (status == RequestStatus.success || status == RequestStatus.error)) {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.availableDeals,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  context.router.push(
                    SendOfferToContractorsRoute(
                      userDetailsCubit: context.read<UserDetailsCubit>(),
                    ),
                  );
                },
                child: Text(
                  LocaleKeys.addNewOffer,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.getDealsState != current.getDealsState ||
                      previous.deleteDealState != current.deleteDealState,
                  listener: (context, state) {
                    if (state.getDealsState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          theme: theme,
                          message: state.errorMessage,
                        ),
                      );
                    }
                    if (state.deleteDealState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          theme: theme,
                          message: state.errorMessage,
                        ),
                      );
                    }
                    if (state.deleteDealState.isSuccess) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          theme: theme,
                          message: state.successMessage,
                          text: LocaleKeys.continueKey,
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.getDealsState != current.getDealsState ||
                      previous.dealsModel != current.dealsModel,
                  builder: (context, state) {
                    final hasData = state.dealsModel.deals.isNotEmpty;

                    if (!state.isConnected && !hasData) {
                      return NoInternetWidget(
                        errorMessage: state.errorMessage,
                        theme: theme,
                        onPressed: () {
                          context.read<UserDetailsCubit>().getDeals();
                        },
                      );
                    }

                    return UiStateBuilder(
                      theme: theme,
                      state: state.getDealsState,
                      errorMessage: state.errorMessage,
                      onLoading: Skeletonizer(
                        containersColor: ColorsManager.skeletonColor,
                        enabled: state.getDealsState.isLoading && !hasData,
                        child: _buildDealsList(
                          theme: theme,
                          deals: List.generate(
                            5,
                            (index) => const DealModel(
                              id: 0,
                              title: 'Loading...',
                              description: 'Loading description...',
                            ),
                          ),
                          status: state.getDealsState,
                        ),
                      ),
                      onSuccess: hasData
                          ? _buildDealsList(
                              deals: state.dealsModel.deals,
                              status: state.getDealsState,
                              theme: theme,
                            )
                          : NoDataWidget(
                              theme: theme,
                              text: LocaleKeys.noDealsYet,
                            ),
                      onError: hasData
                          ? _buildDealsList(
                              deals: state.dealsModel.deals,
                              status: state.getDealsState,
                              theme: theme,
                            )
                          : NoDataWidget(
                              theme: theme,
                              text: LocaleKeys.noDealsYet,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealsList({
    required List<DealModel> deals,
    required RequestStatus status,
    required ThemeData theme,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      cacheExtent: 200,
      itemCount: deals.length + (status.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        if (index == deals.length && status.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
          );
        }

        return AvailableDealsItem(
          theme: theme,
          deal: deals[index],
          index: index,
        );
      },
    );
  }
}
