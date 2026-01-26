import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/no_internet_widget.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/complete_contractor_data/auth_user_image.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/edt_contractor/edit_contractor_form.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/profile_image.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/data/models/service_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class EditContractorProfileScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const EditContractorProfileScreen({super.key});

  @override
  State<EditContractorProfileScreen> createState() =>
      _EditContractorProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: this,
    );
  }
}

class _EditContractorProfileScreenState
    extends State<EditContractorProfileScreen> {
  ValueNotifier<ClassificationModel?> selectedClassification = ValueNotifier(
    null,
  );

  ValueNotifier<List<ServiceModel>> selectedServices = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        context.read<HomeCubit>().getClassifications(),
        context.read<ProfileCubit>().getContractorProfile(),
      ]);
    });
  }

  @override
  void dispose() {
    selectedClassification.dispose();
    selectedServices.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.editMyProfile,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (previous, current) =>
            previous.getUserProfileRequestState !=
            current.getUserProfileRequestState,
        builder: (context, state) {
          if (!state.isConnected) {
            return NoInternetWidget(
              errorMessage: state.errorMessage,
              theme: theme,
              onPressed: () async {
                await Future.wait([
                  context.read<HomeCubit>().getClassifications(),
                  context.read<ProfileCubit>().getContractorProfile(),
                ]);
              },
            );
          }
          return UiStateBuilder(
            state: state.getUserProfileRequestState,
            onLoading: const Center(child: CircularProgressIndicator()),
            onSuccess: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const ProfileImage(),
                    const SizedBox(height: 60),
                    Text(
                      LocaleKeys.mainClassification,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                          previous.classificationsModel !=
                              current.classificationsModel ||
                          previous.getClassificationsState !=
                              current.getClassificationsState,
                      builder: (context, homeState) {
                        if (selectedClassification.value == null) {
                          final userClassificationId =
                              state.userModel.classificationId;
                          selectedClassification.value = homeState
                              .classificationsModel
                              .classifications
                              .firstWhere(
                                (classification) =>
                                    classification.id == userClassificationId,
                                orElse: () =>
                                    homeState
                                        .classificationsModel
                                        .classifications
                                        .firstOrNull ??
                                    const ClassificationModel(
                                      id: 0,
                                      name: '',
                                      numberOfServices: 0,
                                      image: '',
                                    ),
                              );
                          selectedServices.value = state.userModel.userServices;
                        }
                        return ValueListenableBuilder<ClassificationModel?>(
                          valueListenable: selectedClassification,
                          builder: (context, value, _) {
                            return CustomDropdownField<ClassificationModel>(
                              value: value,
                              theme: theme,
                              hintText: LocaleKeys.chooseClassification,
                              items: homeState
                                  .classificationsModel
                                  .classifications
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                selectedClassification.value = newValue!;
                                selectedServices.value = [];
                                context.read<HomeCubit>().getServices(
                                  classificationId:
                                      selectedClassification.value!.id,
                                );
                              },
                              onLoadMore: () {
                                context
                                    .read<HomeCubit>()
                                    .loadMoreClassifications();
                              },
                              isLoadingMore: homeState
                                  .getClassificationsState
                                  .isLoadingMore,
                              hasMoreData:
                                  homeState.classificationsPage <
                                  homeState.classificationsTotalPages,
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.subcategory,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                          previous.servicesModel != current.servicesModel ||
                          previous.getServicesState != current.getServicesState,
                      builder: (context, homeState) {
                        final services = homeState.servicesModel.services;

                        if (homeState.getServicesState.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (homeState.getServicesState.isError) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              homeState.servicesErrorMessage,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        if (services.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorsManager.secondaryColor,
                              ),
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

                        return ValueListenableBuilder<List<ServiceModel>>(
                          valueListenable: selectedServices,
                          builder: (context, selectedList, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropdownField<ServiceModel>(
                                  theme: theme,
                                  hintText: LocaleKeys.chooseServices,
                                  multiSelect: true,
                                  selectedValues: selectedList,
                                  items: services
                                      .map(
                                        (item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(item.name),
                                        ),
                                      )
                                      .toList(),
                                  onMultiChanged: (newList) {
                                    selectedServices.value = newList;
                                  },
                                  onLoadMore: () {
                                    context.read<HomeCubit>().loadMoreServices(
                                      classificationId:
                                          selectedClassification.value!.id,
                                    );
                                  },
                                  isLoadingMore:
                                      homeState.getServicesState.isLoadingMore,
                                  hasMoreData:
                                      homeState.servicesPage <
                                      homeState.servicesTotalPages,
                                ),
                                if (selectedList.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: selectedList.map((service) {
                                      return Chip(
                                        label: Text(
                                          service.name,
                                          style: theme.textTheme.bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            ColorsManager.primaryColor,
                                        deleteIconColor: Colors.white,
                                        onDeleted: () {
                                          final newList =
                                              List<ServiceModel>.from(
                                                selectedServices.value,
                                              );
                                          newList.removeWhere(
                                            (s) => s.id == service.id,
                                          );
                                          selectedServices.value = newList;
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<List<ServiceModel>>(
                      valueListenable: selectedServices,
                      builder: (context, services, _) {
                        return EditContractorForm(
                          classificationId:
                              selectedClassification.value?.id ?? 0,
                          serviceIds: services.map((s) => s.id).toList(),
                          userModel: state.userModel,
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            onError: Center(
              child: Text(state.errorMessage, style: theme.textTheme.bodyLarge),
            ),
            theme: theme,
            errorMessage: state.errorMessage,
          );
        },
      ),
    );
  }
}
