import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class MyCurrentPackageScreen extends StatelessWidget {
  const MyCurrentPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.myCurrentPackage,
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ColorsManager.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 50,
        ),
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsManager.secondaryColor, width: .7),
          borderRadius: BorderRadius.circular(8),
          color: ColorsManager.fillColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: AssetImage(AssetsManager.subscriptionPackageImageWithoutBackground),
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 13),
            Text(
              LocaleKeys.youAreNowSubscribedToTheFreePackage,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: ColorsManager.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${LocaleKeys.subscriptionDate} : 12/12/2022",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.secondaryColor,
              ),
            ),
            const CustomDivider(),
            Text(
              "الباقة صالحة لمدة شهر",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: ColorsManager.secondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.expireAt,
              style: theme.textTheme.bodySmall!.copyWith(
                color: ColorsManager.primaryColor,
              ),
            ),
            const SizedBox(height: 5),

            Text(
              "20/12/2022",
              style: theme.textTheme.bodySmall!.copyWith(
                color: ColorsManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
