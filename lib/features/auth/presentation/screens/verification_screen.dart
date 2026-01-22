import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:pinput/pinput.dart';

@RoutePage()
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    required this.email,
    this.isUser = false,
  });
  final String email;
  final bool isUser;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String verificationCode = "";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.verificationCode,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                LocaleKeys.verificationCodeSent,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: ColorsManager.secondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: AlignmentDirectional.center,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 5,
                  onChanged: (value) => verificationCode = value,
                  defaultPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    textStyle: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorsManager.secondaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorsManager.secondaryColor,
                        width: 4,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorsManager.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    textStyle: theme.textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.activateAccountState != current.activateAccountState,
            buildWhen: (previous, current) =>
                previous.activateAccountState != current.activateAccountState,
            listener: (context, state) async {
              if (state.activateAccountState.isError) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(theme: theme, message: state.errorMessage),
                );
              }
              if (state.activateAccountState.isSuccess) {
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    theme: theme,
                    text: LocaleKeys.continueKey,
                    message: state.activateAccountResponseModel.message,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
                if (context.mounted) {
                  if (widget.isUser) {
                    context.navigateTo(const LoginRoute());
                  } else {
                    context.replaceRoute(
                      UploadFilesRoute(
                        contractorId: state.activateAccountResponseModel.id,
                      ),
                    );
                  }
                }
              }
            },
            builder: (context, state) {
              return PrimaryButton(
                isLoading: state.activateAccountState.isLoading,
                onPressed: () {
                  if (verificationCode.length == 5) {
                    context.read<AuthCubit>().activateAccount(
                      email: widget.email,
                      verificationCode: verificationCode,
                    );
                  }
                },
                text: LocaleKeys.verify,
              );
            },
          ),
        ),
      ),
    );
  }
}
