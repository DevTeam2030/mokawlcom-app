import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/search_bloc/search_bloc.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class HomeFilterBottomSheet extends StatefulWidget {
  const HomeFilterBottomSheet({super.key, required this.query});
  final String query;
  @override
  State<HomeFilterBottomSheet> createState() => _HomeFilterBottomSheetState();
}

class _HomeFilterBottomSheetState extends State<HomeFilterBottomSheet> {
  final ValueNotifier<ClassificationModel?> selectedClassification =
      ValueNotifier(null);

  final ValueNotifier<ServiceModel?> selectedService = ValueNotifier(null);

  @override
  void dispose() {
    selectedClassification.dispose();
    selectedService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              LocaleKeys.resultsFilter,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorsManager.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            LocaleKeys.classification,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          BlocSelector<HomeCubit, HomeState, List<ClassificationModel>>(
            selector: (state) => state.classificationsModel.classifications,
            builder: (context, classifications) {
              if (selectedClassification.value == null) {
                selectedClassification.value = classifications.firstOrNull;
                if (selectedClassification.value != null) {
                  context.read<HomeCubit>().getServices(
                    classificationId: selectedClassification.value!.id,
                  );
                }
              }
              return ValueListenableBuilder<ClassificationModel?>(
                valueListenable: selectedClassification,
                builder: (context, value, _) {
                  return CustomDropdownField<ClassificationModel>(
                    value: value,
                    theme: theme,
                    hintText: LocaleKeys.chooseClassification,
                    items: classifications
                        .map(
                          (item) => DropdownMenuItem<ClassificationModel>(
                            value: item,
                            child: Text(item.name),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) {
                      selectedClassification.value = newValue;
                      context.read<HomeCubit>().getServices(
                        classificationId: newValue?.id ?? 0,
                      );
                    },
                  );
                },
              );
            },
          ),

          const SizedBox(height: 22),
          Text(
            LocaleKeys.services,
            style: theme.textTheme.labelMedium!.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) =>
                previous.getServicesState != current.getServicesState,
            builder: (context, state) {
              final services = state.servicesModel.services;
              if (services.isNotEmpty && selectedService.value == null) {
                selectedService.value = services.first;
              }
              if (state.getServicesState.isLoading) {
                return const Center(child: LinearProgressIndicator());
              }

              return ValueListenableBuilder<ServiceModel?>(
                valueListenable: selectedService,
                builder: (context, value, _) {
                  if (services.isEmpty) {
                    selectedService.value = null;
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorsManager.secondaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        LocaleKeys.noServicesAvailable,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: ColorsManager.secondaryColor,
                        ),
                      ),
                    );
                  }

                  if (selectedService.value == null) {
                    selectedService.value = services.first;
                  }
                  return CustomDropdownField<ServiceModel>(
                    value: value,
                    theme: theme,
                    hintText: LocaleKeys.chooseServices,
                    items: services
                        .map(
                          (item) => DropdownMenuItem<ServiceModel>(
                            value: item,
                            child: Text(item.name),
                          ),
                        )
                        .toList(),
                    onChanged: (newValue) {
                      selectedService.value = newValue;
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),
          PrimaryButton(
            text: LocaleKeys.applyFilter,
            onPressed: () {
              context.read<SearchBloc>().add(
                SearchContractorsEvent(
                  query: widget.query,
                  ignoreDebounce: true,
                  classificationId: selectedClassification.value?.id ?? 0,
                  serviceId: selectedService.value?.id ?? 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
