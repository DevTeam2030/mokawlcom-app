import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/request_status.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mokawlcom_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

@RoutePage()
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.subscriptionPackages,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              LocaleKeys.startYourJourney,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 27),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                LocaleKeys.readyToGrowUp,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 27),
            const Image(
              width: 300,
              height: 300,
              fit: BoxFit.cover,
              image: AssetImage(AssetsManager.subscriptionPackageImage),
            ),
            const SizedBox(height: 10),
            Text(
              LocaleKeys.yourContractingPackageIsFreeForALimitedTime,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsManager.primaryColor,
              ),
            ),
            const Spacer(),
            BlocConsumer<AuthCubit, AuthState>(
              listenWhen: (prev, curr) =>
                  prev.subscibePlanState != curr.subscibePlanState,
              buildWhen: (prev, curr) =>
                  prev.subscibePlanState != curr.subscibePlanState,
              listener: (context, state) async {
                if (state.subscibePlanState.isError) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ErrorDialog(theme: theme, message: state.errorMessage),
                  );
                }
                if (state.subscibePlanState.isSuccess) {
                  await showDialog(
                    context: context,
                    builder: (context) => SuccessDialog(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      theme: theme,
                      text: LocaleKeys.completeData,
                      message: state.successMessage,
                    ),
                  );
                  if (context.mounted) {
                    context.replaceRoute(const CompleteDataRoute());
                  }
                }
              },
              builder: (context, state) {
                return PrimaryButton(
                  isLoading: state.subscibePlanState.isLoading,
                  onPressed: () async {
                    await context.read<AuthCubit>().subscibePlan();
                  },
                  text: LocaleKeys.tryNow,
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
