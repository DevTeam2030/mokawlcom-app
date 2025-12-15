import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_text_form_field.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/custom_auth_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/google_and_apple_sign_in_widgets.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/login_form.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: AlignmentDirectional.center,
                child: Image(image: AssetImage(AssetsManager.appLogo)),
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
              const LoginForm(),
              const SizedBox(height: 16.0),
              const CustomAuthDivider(),
              const SizedBox(height: 16.0),
              const GoogleAndAppleSignInWidgets(),
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
                      context.router.push(const SignupRoute());
                    },
                    child: Text(
                      LocaleKeys.signUp,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: ColorsManager.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    LocaleKeys.signInAsVisitor,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
