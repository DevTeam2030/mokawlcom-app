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
  final String errorMessage;
  final ThemeData theme;

  const UiStateBuilder({
    super.key,
    required this.state,
    this.onInitial = const SizedBox.shrink(),
    required this.onLoading,
    required this.onSuccess,
    this.onError,
    required this.errorMessage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case RequestStatus.initial:
        return onInitial;

      case RequestStatus.loading:
        return onLoading;

      case RequestStatus.loadingMore:
        return onSuccess;

      case RequestStatus.success:
        return onSuccess;

      case RequestStatus.error:
        if (onError != null) {
          return onError!;
        }

        return Center(
          child: Text(
            errorMessage,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
        );
    }
  }
}
