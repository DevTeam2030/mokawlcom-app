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
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/user_details_state.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/my_services/upload_images_section.dart';
import 'package:mokawlcom_app/features/shared/data/models/classification_model.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class AddNewServiceScreen extends StatefulWidget implements AutoRouteWrapper {
  const AddNewServiceScreen({
    super.key,
    required this.theme,
    required this.userDetailsCubit,
  });
  final ThemeData theme;
  final UserDetailsCubit userDetailsCubit;

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider.value(value: userDetailsCubit, child: this);
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;



  String serviceName = '';
  String serviceDetails = '';
  String servicePrice = '';

  @override
  void initState() {
    super.initState();
    widget.userDetailsCubit.clearImages();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;

  }

  @override
  void dispose() {
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
                BlocSelector<AppCubit, AppState, String>(
                  selector: (state) =>
                      state.classification,
                  builder: (context, classification) {
                    return CustomDropdownField<String>(
                      theme: widget.theme,
                     hintText: classification,
                      items: const [],
                      readOnly: true,
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
                  isPrice: true,
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
                      isLoading:
                          state.addNewServiceState.isLoading &&
                          state.selectedImages.isEmpty,
                      text: LocaleKeys.save,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<UserDetailsCubit>().addService(
                            name: serviceName,
                            description: serviceDetails,
                            price: servicePrice,
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
