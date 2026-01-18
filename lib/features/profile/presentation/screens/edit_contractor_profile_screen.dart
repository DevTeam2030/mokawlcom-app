import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
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
class EditContractorProfileScreen extends StatefulWidget {
  const EditContractorProfileScreen({super.key});

  @override
  State<EditContractorProfileScreen> createState() =>
      _EditContractorProfileScreenState();
}

class _EditContractorProfileScreenState
    extends State<EditContractorProfileScreen> {
  late ValueNotifier<ClassificationModel> selectedClassification;

  late ValueNotifier<ServiceModel> selectedServices;
  @override
  void initState() {
    super.initState();
    selectedClassification = ValueNotifier(
      context
          .read<HomeCubit>()
          .state
          .classificationsModel
          .classifications
          .first,
    );
    selectedServices = ValueNotifier(
      context.read<HomeCubit>().state.servicesModel.services.first,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getContractorProfile();
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
                context.read<ProfileCubit>().getContractorProfile();
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

                    BlocSelector<
                      HomeCubit,
                      HomeState,
                      List<ClassificationModel>
                    >(
                      selector: (state) =>
                          state.classificationsModel.classifications,
                      builder: (context, classifications) {
                      
                        return ValueListenableBuilder<ClassificationModel?>(
                          valueListenable: selectedClassification,
                          builder: (context, value, _) {
                            return CustomDropdownField<ClassificationModel>(
                              onTap: classifications.isEmpty ? () {} : null,
                              value: value,
                              theme: theme,
                              hintText: LocaleKeys.chooseClassification,
                              items: classifications
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

                    BlocSelector<HomeCubit, HomeState, List<ServiceModel>>(
                      selector: (state) => state.servicesModel.services,
                      builder: (context, services) {
                        return ValueListenableBuilder<ServiceModel?>(
                          valueListenable: selectedServices,
                          builder: (context, value, _) {
                            return CustomDropdownField<ServiceModel>(
                              value: value,
                              onTap: services.isEmpty ? () {} : null,
                              theme: theme,
                              hintText: LocaleKeys.chooseServices,
                              items: services
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (service) {
                                selectedServices.value = service!;
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    EditContractorForm(
                      classificationId: selectedClassification.value.id,
                      serviceIds: [selectedServices.value.id],
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
