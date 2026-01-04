import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class UiStateBuilder extends StatelessWidget {
  final RequestStatus state;
  final Widget onInitial;
  final Widget onLoading;
  final Widget onSuccess;
  final Widget? onError;
  final bool isConnected;
  final String errorMessage;
  final ThemeData theme;
  final void Function() onPressed;

  const UiStateBuilder({
    super.key,
    required this.state,
    this.onInitial = const SizedBox.shrink(),
    required this.onLoading,
    required this.onSuccess,
    this.onError,
    required this.isConnected,
    required this.errorMessage,
    required this.theme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RequestStatus.initial:
        return onInitial;

      case RequestStatus.loading:
        return onLoading;

      case RequestStatus.success:
        return onSuccess;

      case RequestStatus.error:
        if (onError != null) {
          return onError!;
        }

        return isConnected
            ? Center(
                child: Text(
                  errorMessage,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                  ),
                ),
              )
            : Center(
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
                      PrimaryButton(
                        onPressed: onPressed,
                        text: LocaleKeys.tryAgain,
                      ),
                    ],
                  ),
                ),
              );
    }
  }
}
