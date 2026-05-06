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
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/services/services_list_item.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
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
    selectedIndices = ValueNotifier({});
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getServices(
        classificationId: widget.classificationId,
      );
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;
      context.read<AuthCubit>().loadMoreServices(
        classificationId: widget.classificationId,
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
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.getServicesState != c.getServicesState,
          listener: (context, state) {
            if (state.getServicesState.isError) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(theme: theme, message: state.errorMessage),
              );
            }
          },
          builder: (context, state) {
            final hasData = state.servicesModel.services.isNotEmpty;
        
            if (!state.isConnected) {
              return NoInternetWidget(
                errorMessage: state.errorMessage,
                theme: theme,
                onPressed: () => context.read<AuthCubit>().getServices(
                  classificationId: widget.classificationId,
                ),
              );
            }
        
            return UiStateBuilder(
              state: state.getServicesState,
              theme: theme,
              errorMessage: state.errorMessage,
              onLoading: Skeletonizer(
                containersColor: ColorsManager.skeletonColor,
                enabled: state.getServicesState.isLoading,
                child: _buildServices(
                  theme,
                  List.generate(
                    6,
                    (i) => const ServiceModel(
                      id: 0,
                      name: 'Loading',
                      image: '',
                      numberOfContractors: 0,
                    ),
                  ),
                  state.getServicesState,
                ),
              ),
              onSuccess: hasData
                  ? _buildServices(
                      theme,
                      state.servicesModel.services,
                      state.getServicesState,
                    )
                  : NoDataWidget(
                      text: LocaleKeys.noServicesAvailable,
                      theme: theme,
                    ),
              onError: hasData
                  ? _buildServices(
                      theme,
                      state.servicesModel.services,
                      state.getServicesState,
                    )
                  : NoDataWidget(
                      text: LocaleKeys.noServicesAvailable,
                      theme: theme,
                    ),
            );
          },
        ),
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
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: theme,
                    message: LocaleKeys.pleaseSelectAtLeastOneService,
                  ),
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
