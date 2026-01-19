import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_dropdown_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:mokawlcom_app/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/my_services/upload_images_section.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class AddNewServiceScreen extends StatefulWidget implements AutoRouteWrapper {
  const AddNewServiceScreen({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => getIt<UserDetailsCubit>(), child: this);
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;

  late final ValueNotifier<ClassificationModel?> _selectedClassification;

  String serviceName = '';
  String serviceDetails = '';
  String servicePrice = '';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _selectedClassification = ValueNotifier<ClassificationModel?>(null);
  }

  @override
  void dispose() {
    _selectedClassification.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.addNewService,
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
                  textInputAction: TextInputAction.next,
                  type: TextInputType.text,
                  fieldName: LocaleKeys.serviceName,
                  onSaved: (value) => serviceName = value!,
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
                    _selectedClassification.value = classifications.first;
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
                  textInputAction: TextInputAction.next,
                  type: TextInputType.number,
                  fieldName: LocaleKeys.priceAverage,
                  onSaved: (value) => servicePrice = value!,
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
                  textInputAction: TextInputAction.next,
                  type: TextInputType.multiline,
                  maxLines: 5,
                  fieldName: LocaleKeys.serviceDetails,
                  onSaved: (value) => serviceDetails = value!,
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
                UploadImagesSection(theme: widget.theme),
                const SizedBox(height: 24),
                BlocConsumer<UserDetailsCubit, UserDetailsState>(
                  listenWhen: (previous, current) =>
                      previous.addNewServiceState != current.addNewServiceState,
                  buildWhen: (previous, current) =>
                      previous.addNewServiceState != current.addNewServiceState,
                  listener: (context, state) async {
                    if (state.addNewServiceState.isError) {
                      showDialog(
                        context: context,
                        builder: (context) => ErrorDialog(
                          message: state.errorMessage,

                          theme: widget.theme,
                        ),
                      );
                    }
                    if (state.addNewServiceState.isSuccess) {
                      await showDialog(
                        context: context,
                        builder: (context) => SuccessDialog(
                          text: LocaleKeys.back,
                          message: state.successMessage,
                          onPressed: () => context.pop(),
                          theme: widget.theme,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      isLoading: state.addNewServiceState.isLoading,
                      text: LocaleKeys.save,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<UserDetailsCubit>().addService(
                            name: serviceName,
                            description: serviceDetails,
                            price: servicePrice,
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
