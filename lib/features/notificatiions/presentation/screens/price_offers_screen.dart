import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notification_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/shared/presentation/widgets/price_offer_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class PriceOffersScreen extends StatefulWidget {
  const PriceOffersScreen({super.key});

  @override
  State<PriceOffersScreen> createState() => _PriceOffersScreenState();
}

class _PriceOffersScreenState extends State<PriceOffersScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().getOfferNotifications();
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<NotificationsCubit>().loadMoreOfferNotifications();
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

    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listenWhen: (previous, current) =>
          previous.getOfferNotificationsState !=
          current.getOfferNotificationsState,
      listener: (context, state) {
        if (state.getOfferNotificationsState.isError) {
          showToast(
            message: state.offerNotificationsErrorMessage,
            state: ToastStates.error,
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.getOfferNotificationsState !=
          current.getOfferNotificationsState,
      builder: (context, state) {
        final hasData = state.offerNotifications.notifications.isNotEmpty;

        if (!state.isConnected && !hasData) {
          return NoInternetWidget(
            errorMessage: state.offerNotificationsErrorMessage,
            theme: theme,
            onPressed: () {
              context.read<NotificationsCubit>().getOfferNotifications();
            },
          );
        }

        return UiStateBuilder(
          theme: theme,
          state: state.getOfferNotificationsState,
          errorMessage: state.offerNotificationsErrorMessage,
          onLoading: Skeletonizer(
            enabled: state.getOfferNotificationsState.isLoading && !hasData,
            child: _buildOffersList(
              theme: theme,
              notifications: List.generate(
                6,
                (context) => const OfferNotificationModel(
                  body: "*****************",
                  date: "*******",
                  status: false,
                  offerUserName: "********",
                  id: 0,
                  offerId: 0,
                  title: "********",
                  time: "****",
                ),
              ),
              status: state.getOfferNotificationsState,
            ),
          ),
          onSuccess: hasData
              ? _buildOffersList(
                  notifications: state.offerNotifications.notifications,
                  status: state.getOfferNotificationsState,
                  theme: theme,
                )
              : NoDataWidget(
                  theme: theme,
                  text: LocaleKeys.noNotificationsExist,
                ),
          onError: hasData
              ? _buildOffersList(
                  notifications: state.offerNotifications.notifications,
                  status: state.getOfferNotificationsState,
                  theme: theme,
                )
              : NoDataWidget(
                  theme: theme,
                  text: LocaleKeys.noNotificationsExist,
                ),
        );
      },
    );
  }

  Widget _buildOffersList({
    required List<OfferNotificationModel> notifications,
    required RequestStatus status,
    required ThemeData theme,
  }) {
    _resetLoading(status);

    return Expanded(
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: notifications.length + (status.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) =>
            const CustomDivider(thickness: 0.8, height: 1),
        itemBuilder: (context, index) {
          if (index == notifications.length && status.isLoadingMore) {
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
    
          return PriceOfferItem(
            theme: theme,
            offerNotificationModel: notifications[index],
          );
        },
      ),
    );
  }
}
