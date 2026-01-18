import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
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
  final ValueNotifier<ClassificationModel?> selectedClassification =
      ValueNotifier(null);

  final ValueNotifier<ServiceModel?> selectedServices = ValueNotifier(null);

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
      body: Padding(
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

              BlocSelector<HomeCubit, HomeState, List<ClassificationModel>>(
                selector: (state) => state.classificationsModel.classifications,
                builder: (context, classifications) {
                  if (classifications.isNotEmpty &&
                      selectedClassification.value == null) {
                    selectedClassification.value = classifications.first;
                  }

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
                          selectedClassification.value = newValue;
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
                  if (services.isNotEmpty &&
                      selectedServices.value == null) {
                    selectedServices.value = services.first;
                  }
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
                         selectedServices.value = service;
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              EditContractorForm(
                classificationId: selectedClassification.value?.id ?? 0,
                serviceIds:[selectedServices.value?.id ?? 0],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
