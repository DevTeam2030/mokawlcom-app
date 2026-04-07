import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/services/google_sign_in_service.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/shared/custom_auth_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/shared/google_and_apple_sign_in_widgets.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/login/login_form.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    await context.read<AppCubit>().checkNotificationPermission();
  }

  @override
  void dispose() {
    GoogleSignInService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: AlignmentDirectional.center,
                  child: Image(
                    image: AssetImage(AssetsManager.appLogo),
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    LocaleKeys.welcomeAgain,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                LoginForm(theme: theme),
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
                      LocaleKeys.doNotHaveAnAccount,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.pushRoute(const UserSignupRoute());
                      },
                      child: Text(
                        LocaleKeys.signUp,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: TextButton(
                    onPressed: () {
                      context.read<AppCubit>().changeUserType(
                        userType: UserType.visitor,
                      );
                      context.navigateTo(const AuthenticatedRoute());
                    },
                    child: Text(
                      LocaleKeys.signInAsVisitor,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
