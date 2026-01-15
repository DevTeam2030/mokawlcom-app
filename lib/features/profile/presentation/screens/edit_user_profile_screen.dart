import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
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
class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autoValidateModel;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _autoValidateModel = AutovalidateMode.disabled;
    super.initState();
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
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
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
                  type: TextInputType.name,
                  hintText: LocaleKeys.pleaseEnterYourName,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  fieldName: LocaleKeys.name,
                  onSaved: (value) => _name = value!,
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
                  type: TextInputType.emailAddress,
                  hintText: "example@email.com",
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  fieldName: LocaleKeys.email,
                  onSaved: (value) => _email = value!,
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
                  onChanged: (completeNumber, countryCode) {
                    _phone = completeNumber;
                  },
                  onSubmitted: (_) {
                    // Handle submit
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
                  type: TextInputType.streetAddress,
                  hintText: LocaleKeys.pleaseEnterYourAddress,
                  autofillHints: const [AutofillHints.fullStreetAddress],
                  textInputAction: TextInputAction.done,
                  fieldName: LocaleKeys.address,
                  onSaved: (value) => _address = value!,
                  onSubmit: (_) => _submit(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
                builder: (context) =>
                    ErrorDialog(message: state.errorMessage, theme: theme),
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
                  text: LocaleKeys.exit,
                ),
              );
            }
          },
          builder: (context, state) {
            return PrimaryButton(
              isLoading: state.updateUserProfileRequestStatus.isLoading,
              onPressed: () {
                _submit(context);
              },
              text: LocaleKeys.save,
            );
          },
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<ProfileCubit>().updateUserProfile(
        updateUserProfileRequestModel:
            UpdateUserProfileRequestModel(
              name: _name,
              email: _email,
              phone: _phone,
              address: _address,
            ),
      );
    } else {
      setState(() {
        _autoValidateModel = AutovalidateMode.always;
      });
    }
  }
}
