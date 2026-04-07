import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    super.key,
    required this.errorMessage,
    required this.theme,
    required this.onPressed,
  });

  final String errorMessage;
  final ThemeData theme;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 200,
                color: ColorsManager.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(onPressed: onPressed, text: LocaleKeys.tryAgain),
            ],
          ),
        ),
      ),
    );
  }
}
