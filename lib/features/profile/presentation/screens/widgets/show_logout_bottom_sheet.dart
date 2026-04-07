import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';
import 'package:mokawlcom_app/my_app.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

Future<void> showLogoutBottomSheet({
  required BuildContext context,
  required ThemeData theme,
  required ProfileCubit profileCubit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: profileCubit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                LocaleKeys.doYouWantToLogout,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsManager.errorLight),
                ),
                child: PrimaryButton(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: LocaleKeys.cancel,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                backgroundColor: ColorsManager.errorLight,
                textColor: Colors.white,
                onPressed: () {
                  profileCubit.logout();
                  context.replaceRoute(const AuthRoute());
                },
                text: LocaleKeys.exit,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
