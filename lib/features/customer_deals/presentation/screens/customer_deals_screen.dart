import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/customer_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deals/customer_deals_cubit.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/customer_deals/customer_deals_state.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/screens/add_customer_deal_screen.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/screens/customer_deal_details_screen.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_card.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';

@RoutePage()
class CustomerDealsScreen extends StatefulWidget implements AutoRouteWrapper {
  const CustomerDealsScreen({super.key});

  @override
  State<CustomerDealsScreen> createState() => _CustomerDealsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => getIt<CustomerDealsCubit>()..getMyDeals(),
    child: this,
  );
}

class _CustomerDealsScreenState extends State<CustomerDealsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerDealsCubit>().loadMoreMyDeals();
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
          LocaleKeys.customerDeals,
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
            children: [
              PrimaryButton(
                onPressed: () async {
                  final wasAdded = await context.pushRoute<bool>(
                    const AddCustomerDealRoute(),
                  );
                  if (wasAdded == true && context.mounted) {
                    await context.read<CustomerDealsCubit>().refreshMyDeals();
                  }
                },
                text: LocaleKeys.addDeal,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocConsumer<CustomerDealsCubit, CustomerDealsState>(
                  listenWhen: (previous, current) =>
                      previous.deleteStatus != current.deleteStatus,
                  listener: (context, state) async {
                    if (state.deleteStatus.isError) {
                      await showDialog<void>(
                        context: context,
                        builder: (_) => ErrorDialog(
                          theme: theme,
                          message: state.errorMessage.isNotEmpty
                              ? state.errorMessage
                              : LocaleKeys.generalError,
                        ),
                      );
                    } else if (state.deleteStatus.isSuccess) {
                      await showDialog<void>(
                        context: context,
                        builder: (_) => SuccessDialog(
                          theme: theme,
                          message: state.deleteMessage,
                          text: LocaleKeys.continueKey,
                        ),
                      );
                      if (context.mounted) {
                        await context
                            .read<CustomerDealsCubit>()
                            .refreshMyDeals();
                      }
                    }
                  },
                  builder: (context, state) =>
                      _buildBody(context: context, theme: theme, state: state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required ThemeData theme,
    required CustomerDealsState state,
  }) {
    final cubit = context.read<CustomerDealsCubit>();
    if ((state.status.isInitial || state.status.isLoading) &&
        state.deals.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: ColorsManager.primaryColor),
      );
    }

    if (state.status.isError && state.deals.isEmpty) {
      if (!state.isConnected) {
        return NoInternetWidget(
          errorMessage: state.errorMessage,
          theme: theme,
          onPressed: cubit.getMyDeals,
        );
      }
      return _buildErrorState(
        theme: theme,
        message: state.errorMessage,
        onRetry: cubit.getMyDeals,
      );
    }

    if (state.deals.isEmpty) {
      return RefreshIndicator(
        onRefresh: cubit.refreshMyDeals,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: NoDataWidget(text: LocaleKeys.noDealsYet, theme: theme),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cubit.refreshMyDeals,
      child: _buildDealsList(state),
    );
  }

  Widget _buildDealsList(CustomerDealsState state) {
    final showPaginationState =
        state.paginationStatus.isLoadingMore || state.paginationStatus.isError;
    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.deals.length + (showPaginationState ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        if (index == state.deals.length) {
          if (state.paginationStatus.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryColor,
                ),
              ),
            );
          }
          return TextButton(
            onPressed: context.read<CustomerDealsCubit>().loadMoreMyDeals,
            child: Text(LocaleKeys.oopsRetry),
          );
        }

        final deal = state.deals[index];
        return DealCard(
          title: deal.title,
          description: deal.details,
          categories: deal.categories.map((category) => category.name).toList(),
          createdDate: _formatCreatedDate(deal),
          repliesCount: deal.repliesCount,
          isDeleting:
              state.deleteStatus.isLoading && state.deletingDealId == deal.id,
          onEdit: deal.repliesCount == 0
              ? () async {
                  final wasUpdated = await context.router.pushWidget<bool>(
                    AddCustomerDealScreen(deal: deal),
                  );
                  if (wasUpdated == true && context.mounted) {
                    await context.read<CustomerDealsCubit>().refreshMyDeals();
                  }
                }
              : null,
          onDelete: deal.repliesCount == 0
              ? () => _confirmDelete(context: context, deal: deal)
              : null,
          onTap: () => context.router.pushWidget(
            CustomerDealDetailsScreen(
              dealId: deal.id,
              // The shared details entry point must receive the caller role.
              // ignore: avoid_redundant_argument_values
              mode: CustomerDealDetailsMode.customer,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState({
    required ThemeData theme,
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(onPressed: onRetry, text: LocaleKeys.oopsRetry),
        ],
      ),
    );
  }

  String _formatCreatedDate(CustomerDealModel deal) {
    return [
      deal.date,
      deal.time,
    ].where((value) => value.isNotEmpty).join(' - ');
  }

  Future<void> _confirmDelete({
    required BuildContext context,
    required CustomerDealModel deal,
  }) async {
    if (deal.repliesCount != 0) return;
    final cubit = context.read<CustomerDealsCubit>();
    if (cubit.state.deleteStatus.isLoading) return;
    final theme = Theme.of(context);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.errorLight.withValues(alpha: .1),
                ),
                child: const Icon(
                  MyIcons.trash,
                  color: ColorsManager.errorLight,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.deleteDeal,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.deleteDealMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.grayText,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: ColorsManager.primaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        LocaleKeys.cancel,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        cubit.deleteCustomerDeal(
                          dealId: deal.id,
                          repliesCount: deal.repliesCount,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.errorLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        LocaleKeys.deleteDeal,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
