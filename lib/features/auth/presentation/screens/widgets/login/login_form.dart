import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.theme});
  final ThemeData theme;
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late String _email;
  late String _password;
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
            LocaleKeys.email,
            style: widget.theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextFormField(
            type: TextInputType.text,
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
            textInputAction: TextInputAction.done,
            onSaved: (password) => _password = password!,
            onSubmit: (_) async => await _submit(context),
          ),
          const SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              context.pushRoute(const ForgetPasswordRoute());
            },
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                LocaleKeys.forgetPassword,
                style: widget.theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.userLoginState != current.userLoginState,
            buildWhen: (previous, current) =>
                previous.userLoginState != current.userLoginState,

            listener: (context, state) async {
              if (state.userLoginState.isError) {
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    theme: widget.theme,
                    message: state.errorMessage,
                  ),
                );
              }
              if (state.userLoginState.isSuccess) {
                context.read<AppCubit>().changeClassification(
                  classification: state.userLoginResponseModel.classification,
                );
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    theme: widget.theme,
                    message: state.userLoginResponseModel.message,
                    text: LocaleKeys.continueKey,
                  ),
                );
                if (!state.userLoginResponseModel.filesUploaded &&
                    context.mounted) {
                  context.pushRoute(
                    UploadFilesRoute(
                      contractorId: state.userLoginResponseModel.userId,
                      userLoginResponseModel: state.userLoginResponseModel,
                    ),
                  );
                  return;
                } else if (!state.userLoginResponseModel.planCompleted &&
                    context.mounted) {
                  context.pushRoute(const SubscriptionRoute());
                  return;
                } else if (!state.userLoginResponseModel.completeData &&
                    context.mounted) {
                  context.pushRoute(const CompleteDataRoute());
                  return;
                } else if (state.userLoginResponseModel.userApproved == 1 &&
                    context.mounted) {
                  context.replaceRoute(const AuthenticatedRoute());
                }
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.userLoginState.isLoading,
                onPressed: () async {
                  await _submit(context);
                },
                text: LocaleKeys.login,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().userLogin(
        email: _email.replaceAll(" ", ""),
        password: _password.replaceAll(" ", ""),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
