import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/offer_details.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class OfferDetailsScreen extends StatefulWidget {
  const OfferDetailsScreen({super.key, required this.offerNotificationModel});
  final OfferModel offerNotificationModel;

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().getOfferDetails(
        offerId: widget.offerNotificationModel.offerId,
      );
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<NotificationsCubit>().loadMoreOfferDetails(
        offerId: widget.offerNotificationModel.offerId,
      );
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
          LocaleKeys.offerDetails,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OfferDetails(
            theme: theme,
            isOffer: true,
            offerNotificationModel: widget.offerNotificationModel,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 14),
            child: Text(
              LocaleKeys.replys,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: BlocConsumer<NotificationsCubit, NotificationsState>(
              listenWhen: (previous, current) =>
                  previous.getOfferDetailsState != current.getOfferDetailsState,
              listener: (context, state) {
                if (state.getOfferDetailsState.isError) {
                  showToast(
                    message: state.offerDetailsErrorMessage,
                    state: ToastStates.error,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.getOfferDetailsState != current.getOfferDetailsState,
              builder: (context, state) {
                final hasData = state.offerDetails.replies.isNotEmpty;

                if (!state.isConnected && !hasData) {
                  return NoInternetWidget(
                    errorMessage: state.offerDetailsErrorMessage,
                    theme: theme,
                    onPressed: () {
                      context.read<NotificationsCubit>().getOfferDetails(
                        offerId: widget.offerNotificationModel.offerId,
                      );
                    },
                  );
                }

                return UiStateBuilder(
                  theme: theme,
                  state: state.getOfferDetailsState,
                  errorMessage: state.offerDetailsErrorMessage,
                  onLoading: Skeletonizer(
                    containersColor: ColorsManager.skeletonColor,
                    enabled: state.getOfferDetailsState.isLoading && !hasData,
                    child: _buildDetailsContent(
                      theme: theme,
                      replies: List.generate(
                        3,
                        (context) => const OfferModel(
                          id: 0,
                          message:
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                          date: "22/12/2022",
                          time: "10:00",
                          offerUserName: "John Doe",
                          offerId: 0,
                          title: "Offer Reply",
                          status: false,
                          isPdf: false,
                          url: "",
                          price: 0,
                        ),
                      ),
                      status: state.getOfferDetailsState,
                    ),
                  ),
                  onSuccess: hasData
                      ? _buildDetailsContent(
                          replies: state.offerDetails.replies,
                          status: state.getOfferDetailsState,
                          theme: theme,
                        )
                      : NoDataWidget(
                          theme: theme,
                          text: LocaleKeys.noRepliesYet,
                        ),
                  onError: hasData
                      ? _buildDetailsContent(
                          replies: state.offerDetails.replies,
                          status: state.getOfferDetailsState,
                          theme: theme,
                        )
                      : NoDataWidget(
                          theme: theme,
                          text: LocaleKeys.noRepliesYet,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent({
    required List<OfferModel> replies,
    required RequestStatus status,
    required ThemeData theme,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      itemCount: replies.length + (status.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == replies.length && status.isLoadingMore) {
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

        return OfferDetails(
          theme: theme,
          offerNotificationModel: replies[index],
        );
      },
    );
  }
}
