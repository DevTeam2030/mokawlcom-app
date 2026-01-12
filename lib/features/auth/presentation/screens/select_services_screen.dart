import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/services/services_list_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({super.key, required this.classificationId});
  final int classificationId;

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  late final ValueNotifier<Set<int>> selectedIndices;
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    selectedIndices = ValueNotifier({0});
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getServices();
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<AuthCubit>().loadMoreServices();
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
    selectedIndices.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.registerNewContractor,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: .bold,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (p, c) => p.getServicesState != c.getServicesState,
        listener: (context, state) {
          if (state.getServicesState.isError) {
            showToast(message: state.errorMessage, state: ToastStates.error);
          }
        },
        builder: (context, state) {
          final hasData = state.servicesModel.services.isNotEmpty;

          if (!state.isConnected && !hasData) {
            return NoInternetWidget(
              errorMessage: state.errorMessage,
              theme: theme,
              onPressed: () => context.read<AuthCubit>().getServices(),
            );
          }

          return UiStateBuilder(
            state: state.getServicesState,
            theme: theme,
            errorMessage: state.errorMessage,
            onLoading: Skeletonizer(
              enabled: state.getServicesState.isLoading && !hasData,
              child: _buildServices(
                theme,
                hasData
                    ? state.servicesModel.services
                    : List.generate(
                        6,
                        (i) => ServiceModel(
                          id: i,
                          name: 'Loading',
                          image: '',
                          number: i,
                        ),
                      ),
                state.getServicesState,
              ),
            ),
            onSuccess: _buildServices(
              theme,
              state.servicesModel.services,
              state.getServicesState,
            ),
            onError: _buildServices(
              theme,
              state.servicesModel.services,
              state.getServicesState,
            ),
          );
        },
      ),
    );
  }

  Widget _buildServices(
    ThemeData theme,
    List<ServiceModel> services,
    RequestStatus status,
  ) {
    _resetLoading(status);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Set<int>>(
              valueListenable: selectedIndices,
              builder: (_, value, __) {
                return ListView.separated(
                  controller: _scrollController,
                  itemCount: services.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == services.length) {
                      if (status == RequestStatus.loadingMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }

                    return ServicesListItem(
                      theme: theme,
                      serviceModel: services[index],
                      isSelected: value.contains(index),
                      onTap: () {
                        final set = {...value};
                        set.contains(index)
                            ? set.remove(index)
                            : set.add(index);
                        selectedIndices.value = set;
                      },
                    );
                  },
                );
              },
            ),
          ),
          PrimaryButton(
            onPressed: () {
              if (selectedIndices.value.isEmpty) {
                showToast(
                  message: LocaleKeys.pleaseSelectAtLeastOneService,
                  state: ToastStates.error,
                );
                return;
              }
              context.read<AuthCubit>().saveSettings(
                classificiationId: widget.classificationId,
                servicesIds: selectedIndices.value
                    .map((e) => services[e].id)
                    .toList(),
              );
              context.pushRoute(const ContractorSignupRoute());
            },
            text: LocaleKeys.next,
          ),
        ],
      ),
    );
  }
}
