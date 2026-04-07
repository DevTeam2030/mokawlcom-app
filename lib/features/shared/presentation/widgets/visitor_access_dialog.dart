import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class VisitorAccessDialog extends StatelessWidget {
  const VisitorAccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              MyIcons.lockfill,
              size: 60,
              color: ColorsManager.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.loginRequired,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.loginRequiredMessage,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                context.router.pop();
                context.router.push(const AuthRoute());
              },
              text: LocaleKeys.login,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: Text(
                LocaleKeys.continueAsVisitor,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
