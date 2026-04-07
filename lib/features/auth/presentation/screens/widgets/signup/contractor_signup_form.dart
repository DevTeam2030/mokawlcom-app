import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class ContractorSignupForm extends StatefulWidget {
  const ContractorSignupForm({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<ContractorSignupForm> createState() => _ContractorSignupFormState();
}

class _ContractorSignupFormState extends State<ContractorSignupForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late final ValueNotifier<AutovalidateMode> _confirmPasswordAutovalidateMode;
  late String _companyName;
  late String _email;
  late String _password;
  late String _confirmPassword;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
    _confirmPasswordAutovalidateMode = ValueNotifier(AutovalidateMode.disabled);
    _password = '';
    _confirmPassword = '';
  }

  @override
  void dispose() {
    _confirmPasswordAutovalidateMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.companyName,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.name,
            hintText: LocaleKeys.pleaseEnterCompanyName,
            autofillHints: const [AutofillHints.organizationName],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.companyName,
            onSaved: (name) => _companyName = name!,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.email,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.emailAddress,
            hintText: "user@example.com",
            autofillHints: const [AutofillHints.email],
            textInputAction: TextInputAction.next,
            fieldName: LocaleKeys.email,
            onSaved: (email) => _email = email!,
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.password,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          PasswordField(
            hintText: "********",
            textInputAction: TextInputAction.next,
            onChanged: (password) {
              _password = password!;
              // Enable autovalidation for confirm password once user starts typing
              if (_confirmPassword.isNotEmpty) {
                _confirmPasswordAutovalidateMode.value =
                    AutovalidateMode.always;
              }
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.confirmPassword,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          ValueListenableBuilder<AutovalidateMode>(
            valueListenable: _confirmPasswordAutovalidateMode,
            builder: (context, autovalidateMode, _) {
              return PasswordField(
                autovalidateMode: autovalidateMode,
                hintText: "********",
                textInputAction: TextInputAction.next,
                onChanged: (confirmPassword) {
                  _confirmPassword = confirmPassword!;
                  // Enable autovalidation once user starts typing
                  _confirmPasswordAutovalidateMode.value =
                      AutovalidateMode.always;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.passwordIsRequired;
                  }

                  final minLength = value.length >= 6;

                  if (!minLength) return LocaleKeys.passwordIsTooShort;
                  if (value != _password) {
                    return LocaleKeys.passwordsDoNotMatch;
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            LocaleKeys.phone,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomIntlPhoneField(
            onChanged: (completeNumber, countryCode) {
              _phone = completeNumber;
            },
            onSubmitted: (_) => _onSubmit(context),
          ),
          const SizedBox(height: 90.0),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (prev, curr) =>
                prev.contractorSignUpState != curr.contractorSignUpState,
            buildWhen: (prev, curr) =>
                prev.contractorSignUpState != curr.contractorSignUpState,
            listener: (context, state) async {
              if (state.contractorSignUpState.isError) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: widget.theme,
                    message: state.errorMessage,
                  ),
                );
              }
              if (state.contractorSignUpState.isSuccess) {
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    theme: widget.theme,
                    message: state.successMessage,
                    text: LocaleKeys.continueKey,
                  ),
                );
                if (context.mounted) {
                  context.pushRoute(VerificationRoute(email: _email));
                }
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.contractorSignUpState.isLoading,
                onPressed: () async {
                  await _onSubmit(context);
                },
                text: LocaleKeys.createAccount,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().contractorSignUp(
        name: _companyName.trim(),
        email: _email.replaceAll(" ", ""),
        password: _password.replaceAll(" ", ""),
        confirmPassword: _confirmPassword.replaceAll(" ", ""),
        phone: _phone.replaceAll(" ", ""),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
