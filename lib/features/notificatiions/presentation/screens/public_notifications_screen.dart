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
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/public_notifications_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class PublicNotificationsScreen extends StatefulWidget {
  const PublicNotificationsScreen({super.key});

  @override
  State<PublicNotificationsScreen> createState() =>
      _PublicNotificationsScreenState();
}

class _PublicNotificationsScreenState extends State<PublicNotificationsScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().getPublicNotifications();
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<NotificationsCubit>().loadMorePublicNotifications();
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
          previous.getPublicNotificationsState !=
          current.getPublicNotificationsState,
      listener: (context, state) {
        if (state.getPublicNotificationsState.isError) {
          showToast(
            message: state.publicNotificationsErrorMessage,
            state: ToastStates.error,
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.getPublicNotificationsState !=
          current.getPublicNotificationsState,
      builder: (context, state) {
        final hasData = state.publicNotifications.notifications.isNotEmpty;

        if (!state.isConnected && !hasData) {
          return NoInternetWidget(
            errorMessage: state.publicNotificationsErrorMessage,
            theme: theme,
            onPressed: () {
              context.read<NotificationsCubit>().getPublicNotifications();
            },
          );
        }

        return UiStateBuilder(
          theme: theme,
          state: state.getPublicNotificationsState,
          errorMessage: state.publicNotificationsErrorMessage,
          onLoading: Skeletonizer(
            containersColor: ColorsManager.skeletonColor,
            enabled: state.getPublicNotificationsState.isLoading && !hasData,
            ignoreContainers: true,
            child: _buildNotificationsList(
              notifications: List.generate(
                6,
                (context) => const PublicNotificationModel(
                  body:
                      "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore",
                  date: "00/00/0000",
                  id: 0,
                  title: "Notification Title Placeholder",
                  time: "00:00",
                  status: false,
                ),
              ),
              status: state.getPublicNotificationsState,
            ),
          ),
          onSuccess: hasData
              ? _buildNotificationsList(
                  notifications: state.publicNotifications.notifications,
                  status: state.getPublicNotificationsState,
                )
              : NoDataWidget(
                  theme: theme,
                  text: LocaleKeys.noNotificationsExist,
                ),
          onError: hasData
              ? _buildNotificationsList(
                  notifications: state.publicNotifications.notifications,
                  status: state.getPublicNotificationsState,
                )
              : NoDataWidget(
                  theme: theme,
                  text: LocaleKeys.noNotificationsExist,
                ),
        );
      },
    );
  }

  Widget _buildNotificationsList({
    required List notifications,
    required RequestStatus status,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: notifications.length + (status.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) =>
          const CustomDivider(thickness: 0.5, height: 1),
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

        final notification = notifications[index];

        return PublicNotificationItem(
          theme: Theme.of(context),
          notification: notification,
        );
      },
    );
  }
}
