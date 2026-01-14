import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_notification_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PriceOfferItem extends StatelessWidget {
  const PriceOfferItem({
    super.key,
    required this.theme,
    this.isUser = false,
    required this.offerNotificationModel,
  });
  final ThemeData theme;
  final bool isUser;
  final OfferNotificationModel offerNotificationModel;
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
              Skeleton.replace(
                replacement: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsManager.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                   
                  ),
                ),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsManager.primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                   
                  ),
                  child: CustomCachedNetworkImage(
                    imageUrl: offerNotificationModel.link,
                    height: 48,
                    width: 48,
                    
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
                    "${offerNotificationModel.time} - ${offerNotificationModel.date}",
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
