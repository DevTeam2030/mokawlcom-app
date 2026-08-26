import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/customer_deals/data/models/contractor_deal_model.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/contractor_deals/contractor_deals_cubit.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/cubit/contractor_deals/contractor_deals_state.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/screens/customer_deal_details_screen.dart';
import 'package:mokawlcom_app/features/customer_deals/presentation/widgets/deal_card.dart';

@RoutePage()
class AvailableCustomerDealsScreen extends StatelessWidget {
  const AvailableCustomerDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContractorDealsCubit>(
      create: (_) => getIt<ContractorDealsCubit>()..getContractorDeals(),
      child: const _AvailableCustomerDealsView(),
    );
  }
}

class _AvailableCustomerDealsView extends StatefulWidget {
  const _AvailableCustomerDealsView();

  @override
  State<_AvailableCustomerDealsView> createState() =>
      _AvailableCustomerDealsViewState();
}

class _AvailableCustomerDealsViewState
    extends State<_AvailableCustomerDealsView> {
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
      context.read<ContractorDealsCubit>().loadMoreContractorDeals();
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
          child: BlocBuilder<ContractorDealsCubit, ContractorDealsState>(
            builder: (context, state) =>
                _buildBody(context: context, theme: theme, state: state),
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required ThemeData theme,
    required ContractorDealsState state,
  }) {
    final cubit = context.read<ContractorDealsCubit>();
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
          onPressed: cubit.getContractorDeals,
        );
      }
      return _buildErrorState(
        theme: theme,
        message: state.errorMessage,
        onRetry: cubit.getContractorDeals,
      );
    }

    if (state.deals.isEmpty) {
      return RefreshIndicator(
        onRefresh: cubit.refreshContractorDeals,
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
      onRefresh: cubit.refreshContractorDeals,
      child: _buildDealsList(state),
    );
  }

  Widget _buildDealsList(ContractorDealsState state) {
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
            onPressed: context
                .read<ContractorDealsCubit>()
                .loadMoreContractorDeals,
            child: Text(LocaleKeys.oopsRetry),
          );
        }

        final deal = state.deals[index];
        void openDetails() {
          context.router.pushWidget<void>(
            CustomerDealDetailsScreen(
              dealId: deal.id,
              mode: CustomerDealDetailsMode.contractor,
              initialMyReplySent: deal.myReplySent,
              onInitialReplySuccess: () {
                context.read<ContractorDealsCubit>().refreshContractorDeals();
              },
            ),
          );
        }

        return DealCard(
          title: deal.title,
          description: deal.details,
          ownerName: deal.ownerName,
          categories: deal.categories
              .map((category) => category.name)
              .toList(growable: false),
          createdDate: _formatCreatedDate(deal),
          repliesCount: deal.repliesCount,
          file: deal.file,
          isPdf: deal.isPdf,
          showReplyAction: true,
          myReplySent: deal.myReplySent,
          onReply: deal.myReplySent ? null : openDetails,
          onAttachmentTap: deal.file.trim().isEmpty
              ? null
              : () => _openAttachment(context, deal),
          onTap: openDetails,
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

  String _formatCreatedDate(ContractorDealModel deal) {
    return [
      deal.date,
      deal.time,
    ].where((value) => value.isNotEmpty).join(' - ');
  }

  void _openAttachment(BuildContext context, ContractorDealModel deal) {
    if (deal.file.trim().isEmpty) return;
    if (deal.isPdf) {
      context.pushRoute(PdfRoute(pdfUrl: deal.file.trim()));
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomCachedNetworkImage(
                    imageUrl: deal.file.trim(),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 10,
                start: 10,
                child: InkWell(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: ColorsManager.errorLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
