import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/price_offer_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class SubmittedPriceOffersScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const SubmittedPriceOffersScreen({super.key});

  @override
  State<SubmittedPriceOffersScreen> createState() =>
      _SubmittedPriceOffersScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserDetailsCubit>() ..getUserOffers(),
      child: this,
    );
  }
}

class _SubmittedPriceOffersScreenState
    extends State<SubmittedPriceOffersScreen> {
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
      context.read<UserDetailsCubit>().loadMoreUserOffers();
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
          LocaleKeys.submittedPriceOffers,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listenWhen: (previous, current) =>
            previous.getUserOffersState != current.getUserOffersState,
        listener: (context, state) {
          if (state.getUserOffersState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
        },
        buildWhen: (previous, current) =>
            previous.getUserOffersState != current.getUserOffersState,
        builder: (context, state) {
          final hasData = state.userOffersModel.offers.isNotEmpty;

          if (!state.isConnected && !hasData) {
            return NoInternetWidget(
              theme: theme,
              errorMessage: state.errorMessage,
              onPressed: () {
                context.read<UserDetailsCubit>().getUserOffers();
              },
            );
          }

          return UiStateBuilder(
            theme: theme,
            state: state.getUserOffersState,
            errorMessage: state.errorMessage,
            onLoading: Skeletonizer(
              enabled: state.getUserOffersState.isLoading && !hasData,
              containersColor: ColorsManager.skeletonColor,
              ignoreContainers: true,
              child: _buildList(
                theme: theme,
                status: state.getUserOffersState,
                offers: hasData
                    ? state.userOffersModel.offers
                    : List<OfferModel>.generate(
                        6,
                        (_) => const OfferModel(
                          id: 0,
                          title:
                              "lorem ipsum dolor sit amet consectetur adipiscing elit",
                          offerUserName: "lionel messi",
                          date: "22/12/2022",
                          time: "10:00",
                          price: 100,
                          isPdf: false,
                          message:
                              "lorem ipsum dolor sit amet consectetur adipiscing elit",
                          offerId: 0,
                          status: false,
                          url: "https://www.google.com",
                        ),
                      ),
              ),
            ),
            onSuccess: hasData
                ? _buildList(
                    theme: theme,
                    status: state.getUserOffersState,
                    offers: state.userOffersModel.offers,
                  )
                : NoDataWidget(
                    text: LocaleKeys.thereAreNoOffersMade,
                    theme: theme,
                  ),
            onError: hasData
                ? _buildList(
                    theme: theme,
                    status: state.getUserOffersState,
                    offers: state.userOffersModel.offers,
                  )
                : NoDataWidget(
                    text: LocaleKeys.thereAreNoOffersMade,
                    theme: theme,
                  ),
          );
        },
      ),
    );
  }

  Widget _buildList({
    required ThemeData theme,
    required RequestStatus status,
    required List offers,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: offers.length + (status.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) =>
          const CustomDivider(thickness: 0.8, height: 1),
      itemBuilder: (context, index) {
        if (index == offers.length && status.isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
          );
        }

        return PriceOfferItem(
          theme: theme,
          offerModel: offers[index],
          isUser: true,
        );
      },
    );
  }
}
