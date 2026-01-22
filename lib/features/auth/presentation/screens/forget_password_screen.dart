import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late String _email;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          LocaleKeys.resetPassword,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.enterYourMail,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.unselectedNavColor,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  LocaleKeys.email,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  type: TextInputType.emailAddress,
                  hintText: "user@example.com",
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.done,
                  fieldName: LocaleKeys.email,
                  onSaved: (email) => _email = email!,
                  onSubmit: (_) async => await _submit(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.forgetPasswordState != current.forgetPasswordState,
            buildWhen: (previous, current) =>
                previous.forgetPasswordState != current.forgetPasswordState,
            listener: (context, state) {
              if (state.forgetPasswordState.isSuccess) {
                showToast(
                  message: state.successMessage,
                  state: ToastStates.success,
                );
              }
              if (state.forgetPasswordState.isError) {
                showToast(
                  message: state.errorMessage,
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.forgetPasswordState.isLoading,
                onPressed: () async {
                  await _submit(context);
                },
                text: LocaleKeys.send,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthCubit>().forgetPassword(
        email: _email.replaceAll(" ", ""),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
