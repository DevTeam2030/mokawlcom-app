import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/data/user/models/user_signup_request_model.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/user_auth_cubit.dart/user_auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/user_auth_cubit.dart/user_auth_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late String _name;
  late String _email;
  late String _password;
  late String _confirmPassword;
  late String _phone;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
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
            onChanged: (password) => _password = password!,
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
          PasswordField(
            hintText: "********",
            textInputAction: TextInputAction.next,
            onChanged: (confirmPassword) => _confirmPassword = confirmPassword!,
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
          CustomTextFormField(
            type: TextInputType.phone,
            hintText: LocaleKeys.pleaseEnterYourPhone,
            autofillHints: const [AutofillHints.telephoneNumber],
            textInputAction: TextInputAction.done,
            onSaved: (phone) => _phone = phone!,
            fieldName: LocaleKeys.phone,
            onSubmit: (_) => _onSubmit(context),
          ),
          const SizedBox(height: 16.0),
          BlocConsumer<UserAuthCubit, UserAuthState>(
            listenWhen: (prev, curr) =>
                prev.userSignupState != curr.userSignupState,
            buildWhen: (prev, curr) =>
                prev.userSignupState != curr.userSignupState,
            listener: (context, state) {
              if (state.userSignupState.isError) {
                showToast(
                  message: state.errorMessage,
                  state: ToastStates.error,
                );
              }
              if (state.userSignupState.isSuccess) {
                showToast(
                  message: state.message,
                  state: ToastStates.success,
                );
                 context.pushRoute(VerificationRoute(email: _email));
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
      await context.read<UserAuthCubit>().userSignup(
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
