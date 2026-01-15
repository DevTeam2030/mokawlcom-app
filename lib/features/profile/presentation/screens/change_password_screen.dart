import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/password_field.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

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
              const PasswordField(
                hintText: "********",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              Text(
                LocaleKeys.newPassword,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              const PasswordField(
                hintText: "********",
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              Text(
                LocaleKeys.confirmPassword,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              const PasswordField(
                hintText: "********",
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
        child: PrimaryButton(onPressed: () {}, text: LocaleKeys.update),
      ),
    );
  }
}
