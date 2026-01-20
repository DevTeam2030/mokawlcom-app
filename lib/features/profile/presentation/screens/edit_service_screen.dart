import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/my_services/upload_images_section.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class EditServiceScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditServiceScreen({
    super.key,
    required this.theme,
    required this.userDetailsCubit,
    required this.service,
    required this.serviceIndex,
  });
  
  final ThemeData theme;
  final UserDetailsCubit userDetailsCubit;
  final ContractorServiceModel service;
  final int serviceIndex;

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider.value(value: userDetailsCubit, child: this);
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;

  late final TextEditingController _serviceNameController;
  late final TextEditingController _servicePriceController;
  late final TextEditingController _serviceDetailsController;

  late final ValueNotifier<ClassificationModel?> _selectedClassification;

  @override
  void initState() {
    super.initState();
    widget.userDetailsCubit.clearImages();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _selectedClassification = ValueNotifier<ClassificationModel?>(null);
    _serviceNameController = TextEditingController(text: widget.service.title);
    _servicePriceController = TextEditingController(text: widget.service.price);
    _serviceDetailsController = TextEditingController(text: widget.service.description);
  }

  @override
  void dispose() {
    _selectedClassification.dispose();
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _serviceDetailsController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.editService,
          style: widget.theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 32,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.serviceName,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _serviceNameController,
                  textInputAction: TextInputAction.next,
                  type: TextInputType.text,
                  fieldName: LocaleKeys.serviceName,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.classification,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),

                BlocSelector<HomeCubit, HomeState, List<ClassificationModel>>(
                  selector: (state) =>
                      state.classificationsModel.classifications,
                  builder: (context, classifications) {
                    if (classifications.isEmpty) {
                      return const SizedBox();
                    }
                    if (_selectedClassification.value == null) {
                      _selectedClassification.value = classifications.first;
                    }
                    return ValueListenableBuilder<ClassificationModel?>(
                      valueListenable: _selectedClassification,
                      builder: (context, selectedValue, _) {
                        return CustomDropdownField<ClassificationModel>(
                          theme: widget.theme,
                          hintText: LocaleKeys.chooseClassification,
                          value: selectedValue,
                          items: classifications.map((item) {
                            return DropdownMenuItem<ClassificationModel>(
                              value: item,
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _selectedClassification.value = value;
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.priceAverage,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _servicePriceController,
                  textInputAction: TextInputAction.next,
                  type: TextInputType.number,
                  fieldName: LocaleKeys.priceAverage,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.serviceDetails,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _serviceDetailsController,
                  textInputAction: TextInputAction.next,
                  type: TextInputType.multiline,
                  maxLines: 5,
                  fieldName: LocaleKeys.serviceDetails,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.servicePhotos,
                  style: widget.theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                
                if (widget.service.images.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.service.images.map((imageUrl) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomCachedNetworkImage(
                              imageUrl: imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.servicePhotos, // New photos to add
                    style: widget.theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                UploadImagesSection(theme: widget.theme),
                const SizedBox(height: 24),
                BlocConsumer<UserDetailsCubit, UserDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.editServiceState != current.editServiceState,
                  buildWhen: (previous, current) =>
                      previous.editServiceState != current.editServiceState,
                  listener: (context, state) async {
                    if (state.editServiceState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          message: state.errorMessage,
                          theme: widget.theme,
                        ),
                      );
                    }
                    if (state.editServiceState.isSuccess) {
                      await showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          text: LocaleKeys.back,
                          message: state.successMessage,
                          onPressed: () {
                            context.pop();
                          },
                          theme: widget.theme,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      isLoading: state.editServiceState.isLoading && state.selectedImages.isEmpty,
                      text: LocaleKeys.editService,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<UserDetailsCubit>().editService(
                            serviceId: widget.service.id,
                            index: widget.serviceIndex,
                            name: _serviceNameController.text,
                            description: _serviceDetailsController.text,
                            price: _servicePriceController.text,
                            classificationId: _selectedClassification.value!.id
                                .toString(),
                          );
                        } else {
                          setState(() {
                            _autovalidateMode = AutovalidateMode.always;
                          });
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
