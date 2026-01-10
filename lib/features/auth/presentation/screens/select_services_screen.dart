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

  @override
  void initState() {
    super.initState();
    selectedIndices = ValueNotifier<Set<int>>(<int>{0});
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthCubit>().getServices();
    });

    _scrollController.addListener(() {
      final cubit = context.read<AuthCubit>();
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll > 0 && currentScroll / maxScroll >= 0.7) {
        cubit.loadMoreServices();
      }
    });
  }

  @override
  void dispose() {
    selectedIndices.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    final current = Set<int>.from(selectedIndices.value);

    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }

    selectedIndices.value = current;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.registerNewContractor,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.getServicesState != current.getServicesState,
          listener: (context, state) {
            if (state.getServicesState.isError) {
              showToast(message: state.errorMessage, state: ToastStates.error);
            }
          },
          buildWhen: (previous, current) =>
              previous.getServicesState != current.getServicesState,
          builder: (context, state) => state.isConnected
              ? UiStateBuilder(
                  state: state.getServicesState,
                  theme: theme,
                  errorMessage: state.errorMessage,
                  onLoading: Skeletonizer(
                    child: _buildServices(
                      theme: theme,
                      services: List.generate(
                        6,
                        (index) => ServiceModel(
                          id: index,
                          name: 'name',
                          image: 'image',
                          number: index,
                        ),
                      ),
                      context: context,
                    ),
                  ),
                  onSuccess: _buildServices(
                    theme: theme,
                    services: state.servicesModel.services,
                    context: context,
                  ),
                  onError: _buildServices(
                    theme: theme,
                    services: state.servicesModel.services,
                    context: context,
                  ),
                )
              : NoInternetWidget(
                  errorMessage: state.errorMessage,
                  theme: theme,
                  onPressed: () async {
                    await context.read<AuthCubit>().getServices();
                  },
                ),
        ),
      ),
    );
  }

  Column _buildServices({
    required ThemeData theme,
    required List<ServiceModel> services,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.chooseServices,
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20.0),
        ValueListenableBuilder<Set<int>>(
          valueListenable: selectedIndices,
          builder: (context, value, _) {
            return Expanded(
              child: ListView.separated(
                key: const PageStorageKey("services"),
                controller: _scrollController,
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) => ServicesListItem(
                  theme: theme,
                  isSelected: value.contains(index),
                  serviceModel: services[index],
                  onTap: () => _toggleSelection(index),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10.0),
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
        const SizedBox(height: 40.0),
      ],
    );
  }
}
