import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_grid_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/classification_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.classificationModel});
  final ClassificationModel classificationModel;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getServices(
        classificationId: widget.classificationModel.id,
      );
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      _isLoadingMore = true;
      context.read<HomeCubit>().loadMoreServices(
        classificationId: widget.classificationModel.id,
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
          LocaleKeys.services,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                widget.classificationModel.name,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.grayText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocConsumer<HomeCubit, HomeState>(
            listenWhen: (p, c) => p.getServicesState != c.getServicesState,
            buildWhen: (p, c) => p.getServicesState != c.getServicesState,
            listener: (context, state) {
              if (state.getServicesState.isError) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: theme,
                    message: state.servicesErrorMessage,
                  ),
                );
              }
            },
            builder: (context, state) {
              final hasData = state.servicesModel.services.isNotEmpty;

              if (!state.isConnected && !hasData) {
                return NoInternetWidget(
                  errorMessage: state.servicesErrorMessage,
                  theme: theme,
                  onPressed: () {
                    context.read<HomeCubit>().getServices(
                      classificationId: widget.classificationModel.id,
                    );
                  },
                );
              }

              return Expanded(
                child: UiStateBuilder(
                  theme: theme,
                  state: state.getServicesState,
                  errorMessage: state.servicesErrorMessage,
                  onLoading: Skeletonizer(
                    containersColor: ColorsManager.skeletonColor,
                    enabled: state.getServicesState.isLoading,
                    child: _buildServices(
                      theme: theme,
                      services: hasData
                          ? state.servicesModel.services
                          : List.generate(
                              6,
                              (i) => ServiceModel(
                                id: i,
                                name: '******',
                                image: '',
                                number: i,
                              ),
                            ),
                      status: state.getServicesState,
                    ),
                  ),
                  onSuccess: hasData
                      ? _buildServices(
                          theme: theme,
                          services: state.servicesModel.services,
                          status: state.getServicesState,
                        )
                      : NoDataWidget(
                          text: LocaleKeys.noServicesYet,
                          theme: theme,
                        ),
                  onError: hasData
                      ? _buildServices(
                          theme: theme,
                          services: state.servicesModel.services,
                          status: state.getServicesState,
                        )
                      : NoDataWidget(
                          text: LocaleKeys.noServicesYet,
                          theme: theme,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServices({
    required ThemeData theme,
    required List<ServiceModel> services,
    required RequestStatus status,
  }) {
    _resetLoading(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        key: const PageStorageKey("Services"),
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 20,
          childAspectRatio: 0.78,
        ),
        itemCount: services.length + (status.isLoadingMore ? 3 : 0),
        itemBuilder: (context, index) {
          if (index >= services.length && status.isLoadingMore) {
            return Container(
              decoration: BoxDecoration(
                color: ColorsManager.skeletonColor,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }

          return ServiceGridItem(
            theme: theme,
            serviceModel: services[index],
            onTap: () {
              context.pushRoute(
                ContractorsRoute(
                  classificationModel: widget.classificationModel,
                  serviceModel: services[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
