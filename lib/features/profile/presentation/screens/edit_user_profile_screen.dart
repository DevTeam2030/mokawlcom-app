import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/ui_state_builder.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/update_user_profile_request_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/complete_contractor_data/auth_user_image.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/profile_image.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class EditUserProfileScreen extends StatefulWidget implements AutoRouteWrapper{
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => getIt<ProfileCubit>(), child: this);
  }
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidateModel;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _completePhone = '';
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _autoValidateModel = AutovalidateMode.disabled;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getUserProfile();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) =>
          previous.getUserProfileRequestState !=
          current.getUserProfileRequestState,
      builder: (context, state) {
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
          body: UiStateBuilder(
            state: state.getUserProfileRequestState,
            onLoading: const Center(child: CircularProgressIndicator()),
            onSuccess: Builder(
              builder: (context) {
                PhoneNumber? phone;

                if (state.userModel.phone.isNotEmpty &&
                    state.userModel.phone.startsWith('+')) {
                  phone = PhoneNumber.fromCompleteNumber(
                    completeNumber: state.userModel.phone,
                  );
                }

                _nameController.text = state.userModel.name;
                _emailController.text = state.userModel.email;
                _phoneController.text = phone?.number ?? '';
                _addressController.text = state.userModel.address;
                _completePhone = phone?.completeNumber ?? '';
                return Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20.0,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateModel,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28.0),
                          const ProfileImage(),
                          const SizedBox(height: 8.0),
                          Text(
                            LocaleKeys.name,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextFormField(
                            controller: _nameController,
                            type: TextInputType.name,
                            hintText: LocaleKeys.pleaseEnterYourName,
                            autofillHints: const [AutofillHints.name],
                            textInputAction: TextInputAction.next,
                            fieldName: LocaleKeys.name,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            LocaleKeys.email,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextFormField(
                            controller: _emailController,
                            readOnly: true,
                            type: TextInputType.emailAddress,
                            hintText: "example@email.com",
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            fieldName: LocaleKeys.email,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            LocaleKeys.phone,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomIntlPhoneField(
                            initialCountryCode: phone?.countryISOCode ??"EG",
                            controller: _phoneController,
                            onChanged: (completeNumber, countryCode) {
                              _completePhone = completeNumber;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            LocaleKeys.address,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextFormField(
                            controller: _addressController,
                            type: TextInputType.streetAddress,
                            hintText: LocaleKeys.pleaseEnterYourAddress,
                            autofillHints: const [
                              AutofillHints.fullStreetAddress,
                            ],
                            textInputAction: TextInputAction.done,
                            fieldName: LocaleKeys.address,

                            onSubmit: (_) => _submit(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            errorMessage: state.errorMessage,
            theme: theme,
          ),
          bottomNavigationBar: state.getUserProfileRequestState.isSuccess
              ? Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                  child: BlocConsumer<ProfileCubit, ProfileState>(
                    listenWhen: (previous, current) =>
                        previous.updateUserProfileRequestStatus !=
                        current.updateUserProfileRequestStatus,
                    buildWhen: (previous, current) =>
                        previous.updateUserProfileRequestStatus !=
                        current.updateUserProfileRequestStatus,
                    listener: (context, state) {
                      if (state.updateUserProfileRequestStatus.isError) {
                        showDialog(
                          context: context,
                          builder: (context) => ErrorDialog(
                            message: state.errorMessage,
                            theme: theme,
                          ),
                        );
                      }
                      if (state.updateUserProfileRequestStatus.isSuccess) {
                        showDialog(
                          context: context,
                          builder: (context) => SuccessDialog(
                            theme: theme,
                            message: state.successMessage,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: LocaleKeys.back,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        isLoading:
                            state.updateUserProfileRequestStatus.isLoading,
                        onPressed: () {
                          _submit(context);
                        },
                        text: LocaleKeys.save,
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<ProfileCubit>().updateUserProfile(
        updateUserProfileRequestModel: UpdateUserProfileRequestModel(
          name: _nameController.text,
          email: _emailController.text,
          phone: _completePhone,
          address: _addressController.text,
        ),
      );
    } else {
      setState(() {
        _autoValidateModel = AutovalidateMode.always;
      });
    }
  }
}
