import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class PriceOfferItem extends StatelessWidget {
  const PriceOfferItem({super.key, required this.theme, this.isUser = false});
  final ThemeData theme;
  final bool isUser;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(const OfferDetailsRoute()),
      child: ColoredBox(
        color: ColorsManager.surfaceColor,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 14,
            vertical: 20,
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorsManager.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage(AssetsManager.appLogo),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.offerAddress,
                    style: theme.textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    "2-12-2025 16:00",
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: ColorsManager.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isUser
                        ? "${LocaleKeys.submittedTo} :  محمد احمد"
                        : "${LocaleKeys.offeredBy} :  محمد احمد",
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: ColorsManager.secondaryColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ColorsManager.primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
