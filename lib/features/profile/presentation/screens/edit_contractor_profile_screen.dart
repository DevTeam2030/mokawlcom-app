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
class EditContractorProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditContractorProfileScreen({super.key});

  @override
  State<EditContractorProfileScreen> createState() =>
      _EditContractorProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => getIt<ProfileCubit>(), child: this);
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
        context.read<HomeCubit>().getServices(),
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
              onPressed: () {
                Future.wait([
                  context.read<HomeCubit>().getClassifications(),
                  context.read<HomeCubit>().getServices(),
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
                          previous.classificationsModel.classifications !=
                              current.classificationsModel.classifications ||
                          previous.getClassificationsState !=
                              current.getClassificationsState,
                      builder: (context, state) {
                        if (selectedClassification.value == null) {
                          selectedClassification.value = state
                              .classificationsModel
                              .classifications
                              .firstOrNull;
                        }
                        return ValueListenableBuilder<ClassificationModel?>(
                          valueListenable: selectedClassification,
                          builder: (context, value, _) {
                            return CustomDropdownField<ClassificationModel>(
                              onTap:
                                  state
                                      .classificationsModel
                                      .classifications
                                      .isEmpty
                                  ? () {}
                                  : null,
                              value: value,
                              theme: theme,
                              hintText: LocaleKeys.chooseClassification,
                              items: state.classificationsModel.classifications
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                selectedClassification.value = newValue!;
                              },
                              onLoadMore: () {
                                context
                                    .read<HomeCubit>()
                                    .loadMoreClassifications();
                              },
                              isLoadingMore:
                                  state.getClassificationsState.isLoadingMore,
                              hasMoreData:
                                  state.classificationsPage <
                                  state.classificationsTotalPages,
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
                          previous.servicesModel.services !=
                              current.servicesModel.services ||
                          previous.getServicesState != current.getServicesState,
                      builder: (context, state) {
                        if (selectedServices.value.isEmpty) {
                          selectedServices.value =
                              state.servicesModel.services.isNotEmpty
                              ? [state.servicesModel.services.first]
                              : [];
                        }
                        return ValueListenableBuilder<List<ServiceModel>>(
                          valueListenable: selectedServices,
                          builder: (context, selectedList, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropdownField<ServiceModel>(
                                  onTap: state.servicesModel.services.isEmpty
                                      ? () {}
                                      : null,
                                  theme: theme,
                                  hintText: LocaleKeys.chooseServices,
                                  multiSelect: true,
                                  selectedValues: selectedList,
                                  items: state.servicesModel.services
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
                                    context
                                        .read<HomeCubit>()
                                        .loadMoreServices();
                                  },
                                  isLoadingMore:
                                      state.getServicesState.isLoadingMore,
                                  hasMoreData:
                                      state.servicesPage <
                                      state.servicesTotalPages,
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
                                                selectedList,
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
                    EditContractorForm(
                      classificationId: selectedClassification.value?.id ?? 0,
                      serviceIds: selectedServices.value
                          .map((s) => s.id)
                          .toList(),
                      userModel: state.userModel,
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
