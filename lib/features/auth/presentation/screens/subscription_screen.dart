import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/success_dialog.dart';
import 'package:mokawlcom_app/locale_keys.dart';

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
            PrimaryButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(
                    onPressed: () {
                      context.pushRoute(const CompleteDataRoute());
                      Navigator.of(context).pop();
                    },
                    theme: theme,
                    text: LocaleKeys.completeData,
                    message: LocaleKeys.youHaveSuccessfullySubscribed,
                  ),
                );
              },
              text: LocaleKeys.tryNow,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
