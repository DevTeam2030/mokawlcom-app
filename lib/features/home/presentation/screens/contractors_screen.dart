import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/no_data_widget.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_model.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_cubit/search_state.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor/contractor_item.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

@RoutePage()
class ContractorsScreen extends StatefulWidget implements AutoRouteWrapper {
  const ContractorsScreen({
    super.key,
    this.classificationModel,
    this.serviceModel,
    this.fromSearch = false,
    this.query,
  });

  final ClassificationModel? classificationModel;
  final ServiceModel? serviceModel;
  final bool fromSearch;
  final String? query;

  @override
  State<ContractorsScreen> createState() => _ContractorsScreenState();
  
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (context) => getIt<SearchCubit>(),
    child: this,
  );
}

class _ContractorsScreenState extends State<ContractorsScreen> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromSearch) {
        context.read<SearchCubit>().searchContractors(
          query: widget.query ?? "",
          classificationId: widget.classificationModel?.id,
          serviceId: widget.serviceModel?.id,
        );
      } else {
        context.read<SearchCubit>().getContractors(
          classificationId: widget.classificationModel?.id,
          serviceId: widget.serviceModel?.id,
        );
      }
    });
  }

  void _onScroll() {
    if (_isLoadingMore || !_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _isLoadingMore = true;

      context.read<SearchCubit>().loadMoreContractors(
        classificationId: widget.classificationModel?.id,
        serviceId: widget.serviceModel?.id,
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
          widget.classificationModel != null && widget.serviceModel != null
              ? widget.serviceModel!.name
              : LocaleKeys.searchResults,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        child: BlocConsumer<SearchCubit, SearchState>(
          listenWhen: (previous, current) =>
              previous.getContractorsState != current.getContractorsState,
          buildWhen: (previous, current) =>
              previous.getContractorsState != current.getContractorsState,
          listener: (context, state) {
            if (state.getContractorsState.isError) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(theme: theme, message: state.errorMessage),
              );
            }
          },
          builder: (context, state) {
            final bool hasData = state.contractorsModel.contractors.isNotEmpty;
            if (!state.isConnected && !hasData) {
              return NoInternetWidget(
                errorMessage: state.errorMessage,
                theme: theme,
                onPressed: () {
                  context.read<SearchCubit>().getContractors(
                    classificationId: widget.classificationModel?.id,
                    serviceId: widget.serviceModel?.id,
                  );
                },
              );
            }

            return UiStateBuilder(
              state: state.getContractorsState,
              theme: theme,
              errorMessage: state.errorMessage,
              onLoading: Skeletonizer(
                containersColor: ColorsManager.skeletonColor,
                ignoreContainers: true,
                child: _buildContractorsList(
                  contractors: List.generate(
                          4,
                          (_) => const ContractorModel(
                            id: 0,
                            name: 'Contractor',
                            image: '',
                            address: 'Address',
                            rating: 5,
                            description: 'Description',
                            phone: '',
                            whatsApp: '',
                            category: '---',
                          ),
                        ),
                  theme: theme,
                  status: state.getContractorsState,
                ),
              ),
              onSuccess: hasData
                  ? _buildContractorsList(
                      contractors: state.contractorsModel.contractors,
                      theme: theme,
                      status: state.getContractorsState,
                    )
                  : NoDataWidget(text: LocaleKeys.noResultsFound, theme: theme),
              onError: hasData
                  ? _buildContractorsList(
                      contractors: state.contractorsModel.contractors,
                      theme: theme,
                      status: state.getContractorsState,
                    )
                  : NoDataWidget(text: LocaleKeys.noResultsFound, theme: theme),
            );
          },
        ),
      ),
    );
  }

  ListView _buildContractorsList({
    required List<ContractorModel> contractors,
    required ThemeData theme,
    required RequestStatus status,
  }) {
    _resetLoading(status);

    return ListView.separated(
      controller: _scrollController,
      key: const PageStorageKey("ContractorsList"),
      cacheExtent: 200,
      itemBuilder: (context, index) {
        if (index == contractors.length) {
          if (status == RequestStatus.loadingMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        return ContractorItem(
          contractorModel: contractors[index],
          serviceId: 0,

          theme: theme,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 13),
      itemCount: contractors.length + 1,
    );
  }
}
