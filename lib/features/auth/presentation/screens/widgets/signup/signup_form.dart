import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_intl_phone_field.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/data/models/user/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late final ValueNotifier<AutovalidateMode> _confirmPasswordAutovalidateMode;
  late String _name;
  late String _email;
  late String _password;
  late String _confirmPassword;
  String _phone = "";
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
            LocaleKeys.name,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.name,
            hintText: LocaleKeys.pleaseEnterYourName,
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            onSaved: (name) => _name = name!,
            fieldName: LocaleKeys.name,
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
            onSaved: (email) => _email = email!,
            fieldName: LocaleKeys.email,
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
            validator: (_) => null,
          ),

          const SizedBox(height: 16.0),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (prev, curr) =>
                prev.userSignupState != curr.userSignupState,
            buildWhen: (prev, curr) =>
                prev.userSignupState != curr.userSignupState,
            listener: (context, state) async {
              if (state.userSignupState.isError) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: widget.theme,
                    message: state.errorMessage,
                  ),
                );
              }
              if (state.userSignupState.isSuccess) {
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    theme: widget.theme,
                    message: state.successMessage,
                    text: LocaleKeys.continueKey,
                  ),
                );
                if (context.mounted) {
                  context.pushRoute(
                    VerificationRoute(email: _email, isUser: true),
                  );
                }
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.userSignupState.isLoading,
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
      await context.read<AuthCubit>().userSignup(
        name: _name.trim(),
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
