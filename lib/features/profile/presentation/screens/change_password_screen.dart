import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/data/models/change_password_request_model.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget implements AutoRouteWrapper {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (context) => getIt<ProfileCubit>(), child: this);
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final GlobalKey<FormState> formKey;
  late AutovalidateMode _autovalidateMode;
  String _oldPassword = "";
  String _newPassword = "";
  String _confirmPassword = "";
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    _autovalidateMode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.changePassword,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  LocaleKeys.oldPassword,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                PasswordField(
                  hintText: "********",
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _oldPassword = value!,
                ),
                const SizedBox(height: 16.0),
                Text(
                  LocaleKeys.newPassword,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                PasswordField(
                  hintText: "********",
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _newPassword = value!,
                ),
                const SizedBox(height: 16.0),
                Text(
                  LocaleKeys.confirmPassword,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: ColorsManager.primaryColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                PasswordField(
                  hintText: "********",
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => _confirmPassword = value!,
                  onSubmit: (_) => _onSubmit(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.passwordIsRequired;
                    }
                    if (value != _newPassword) {
                      return LocaleKeys.passwordsDoNotMatch;
                    }
                    return null;
                  },
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
              previous.changePasswordRequestState !=
              current.changePasswordRequestState,
          listener: (context, state) {
            if (state.changePasswordRequestState.isError) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(theme: theme, message: state.errorMessage),
              );
            }
            if (state.changePasswordRequestState.isSuccess) {
              showDialog(
                context: context,
                builder: (context) => SuccessDialog(
                  theme: theme,
                  message: state.successMessage,
                  onPressed: () => context.pop(),
                  text: LocaleKeys.back,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.changePasswordRequestState !=
              current.changePasswordRequestState,
          builder: (context, state) {
            return PrimaryButton(
              isLoading: state.changePasswordRequestState.isLoading,
              onPressed: _onSubmit,
              text: LocaleKeys.update,
            );
          },
        ),
      ),
    );
  }

  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      context.read<ProfileCubit>().changePassword(
        changePasswordRequestModel: ChangePasswordRequestModel(
          currentPassword: _oldPassword.replaceAll(" ", ""),
          newPassword: _newPassword.replaceAll(" ", ""),
          confirmPassword: _confirmPassword.replaceAll(" ", ""),
        ),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
