import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/services/google_sign_in_service.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/error/server_exception.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/shared/custom_auth_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/shared/google_and_apple_sign_in_widgets.dart';
import 'package:mokawlcom_app/features/auth/presentation/widgets/signup/signup_form.dart';
import 'package:mokawlcom_app/locale_keys.dart';

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
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SignupForm(),
              const SizedBox(height: 16.0),
              const CustomAuthDivider(),
              const SizedBox(height: 16.0),
              GoogleAndAppleSignInWidgets(
                onGoogleTap: () async {
                  try {
                    await GoogleSignInService.instance.signIn();
                  } on ServerException catch (e) {
                    debugPrint(e.errorMessage);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
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
    );
  }
}
