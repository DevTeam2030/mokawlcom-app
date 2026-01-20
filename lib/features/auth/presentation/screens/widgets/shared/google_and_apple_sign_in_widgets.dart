import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';

class GoogleAndAppleSignInWidgets extends StatelessWidget {
  const GoogleAndAppleSignInWidgets({super.key, required this.onGoogleTap});
  final void Function() onGoogleTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.googleLoginState != current.googleLoginState,
          listener: (context, state) {
            if (state.googleLoginState.isSuccess) {
              showToast(
                message: state.userLoginResponseModel.message,
                state: ToastStates.success,
              );
              context.replaceRoute(const AuthenticatedRoute());
            }
            if (state.googleLoginState.isError) {
              showToast(message: state.errorMessage, state: ToastStates.error);
            }
          },
          buildWhen: (previous, current) =>
              previous.googleLoginState != current.googleLoginState,  
          builder: (context, state) {
            return InkWell(
              onTap: onGoogleTap,
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsManager.secondaryColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: state.googleLoginState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.primaryColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign in with Google",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          const Image(image: AssetImage(AssetsManager.googleIcon)),
                        ],
                      ),
              ),
            );
          },
        ),
        Platform.isIOS ? const SizedBox(height: 8.0) : const SizedBox.shrink(),
        Platform.isIOS
            ? Container(
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in with Apple",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    const Image(image: AssetImage(AssetsManager.appleIcon)),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
