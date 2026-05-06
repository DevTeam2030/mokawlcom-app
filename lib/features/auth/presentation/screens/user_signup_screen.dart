import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/services/google_sign_in_service.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/shared/custom_auth_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/shared/google_and_apple_sign_in_widgets.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/signup/signup_form.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

@RoutePage()
class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  @override
  void dispose() {
    GoogleSignInService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.registerNewUser,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.googleLoginState != current.googleLoginState,
          listener: (context, state) async {
            if (state.googleLoginState.isError) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(theme: theme, message: state.errorMessage),
              );
            }
            if (state.googleLoginState.isSuccess) {
              await showDialog(
                context: context,
                builder: (context) => SuccessDialog(
                  theme: theme,
                  message: state.successMessage,
                  text: LocaleKeys.continueKey,
                ),
              );
              if (context.mounted) {
                context.replaceRoute(const AuthenticatedRoute());
              }
            }
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignupForm(theme: theme),
                  const SizedBox(height: 16.0),
                  const CustomAuthDivider(),
                  const SizedBox(height: 16.0),
                  GoogleAndAppleSignInWidgets(
                    onGoogleTap: () async {
                      await context.read<AuthCubit>().googleLogin();
                    },
                    onAppleTap: () async {
                      await context.read<AuthCubit>().appleLogin();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.alreadyHaveAnAccount,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: ColorsManager.primaryColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          LocaleKeys.login,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: ColorsManager.primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
