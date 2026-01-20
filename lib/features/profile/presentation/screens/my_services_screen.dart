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
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/my_services/my_service_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class MyServicesScreen extends StatefulWidget implements AutoRouteWrapper {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (context) => getIt<UserDetailsCubit>()..getContractorServices(),
    child: this,
  );
}

class _MyServicesScreenState extends State<MyServicesScreen> {
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
      context.read<UserDetailsCubit>().loadMoreContractorServices();
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
          LocaleKeys.myServices,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => context.pushRoute(
                AddNewServiceRoute(
                  theme: theme,
                  userDetailsCubit: context.read<UserDetailsCubit>(),
                  
                ),
              ),
              child: Text(
                LocaleKeys.addNewService,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
                listenWhen: (previous, current) =>
                    previous.getContractorServicesState !=
                    current.getContractorServicesState,
                listener: (context, state) {
                  if (state.getContractorServicesState.isError) {
                    showToast(
                      message: state.errorMessage,
                      state: ToastStates.error,
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous.getContractorServicesState !=
                        current.getContractorServicesState ||
                    previous.contractorServicesModel !=
                        current.contractorServicesModel,
                builder: (context, state) {
                  final hasData =
                      state.contractorServicesModel.services.isNotEmpty;

                  if (!state.isConnected && !hasData) {
                    return NoInternetWidget(
                      errorMessage: state.errorMessage,
                      theme: theme,
                      onPressed: () {
                        context
                            .read<UserDetailsCubit>()
                            .getContractorServices();
                      },
                    );
                  }

                  return UiStateBuilder(
                    theme: theme,
                    state: state.getContractorServicesState,
                    errorMessage: state.errorMessage,
                    onLoading: Skeletonizer(
                      containersColor: ColorsManager.skeletonColor,
                      enabled:
                          state.getContractorServicesState.isLoading &&
                          !hasData,
                      child: _buildServicesList(
                        theme: theme,
                        services: List.generate(
                          5,
                          (index) => const ContractorServiceModel(
                            id: 0,
                            title: 'Loading...',
                            description: 'Loading description...',
                            price: '0',
                            images: [],
                          ),
                        ),
                        status: state.getContractorServicesState,
                      ),
                    ),
                    onSuccess: hasData
                        ? _buildServicesList(
                            services: state.contractorServicesModel.services,
                            status: state.getContractorServicesState,
                            theme: theme,
                          )
                        : NoDataWidget(
                            theme: theme,
                            text: LocaleKeys.noServicesYet,
                          ),
                    onError: hasData
                        ? _buildServicesList(
                            services: state.contractorServicesModel.services,
                            status: state.getContractorServicesState,
                            theme: theme,
                          )
                        : NoDataWidget(
                            theme: theme,
                            text: LocaleKeys.noServicesYet,
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList({
    required List<ContractorServiceModel> services,
    required RequestStatus status,
    required ThemeData theme,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      itemCount: services.length + (status.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        if (index == services.length && status.isLoadingMore) {
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

        return MyServiceItem(theme: theme, service: services[index], index: index,);
      },
    );
  }
}
