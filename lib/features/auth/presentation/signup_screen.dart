import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/custom_auth_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/google_and_apple_sign_in_widgets.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/signup_form.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              const SizedBox(height: 50.0,),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  LocaleKeys.registerNewUser,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const SignupForm(),
              const SizedBox(height: 16.0),
              const CustomAuthDivider(),
              const SizedBox(height: 16.0),
              const GoogleAndAppleSignInWidgets(),
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

