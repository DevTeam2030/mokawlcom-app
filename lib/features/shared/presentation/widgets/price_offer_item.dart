import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/notifications_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PriceOfferItem extends StatelessWidget {
  const PriceOfferItem({
    super.key,
    required this.theme,
    this.isUser = false,
    required this.offerModel,
  });
  final ThemeData theme;
  final bool isUser;
  final OfferModel offerModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushRoute(
          OfferDetailsRoute(offerNotificationModel: offerModel),
        );
        context.read<NotificationsCubit>().markOfferNotificationAsRead(
          offerId: offerModel.offerId,
        );
    },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BlocSelector<NotificationsCubit, NotificationsState, bool>(
          selector: (state) {
            return state.unReadOfferNotifications.contains(offerModel.offerId);
          },
          builder: (context, unRead) {
            return ColoredBox(
              color: unRead
                  ? ColorsManager.lightBlueBg
                  : ColorsManager.surfaceColor,
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
                          image: const DecorationImage(
                            image: ResizeImage(
                              AssetImage(AssetsManager.appLogo),
                              width: 100,
                              height: 100,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offerModel.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            textDirection: TextDirection.ltr,
                            "${offerModel.date} - ${offerModel.time}",
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isUser
                                ? "${LocaleKeys.submittedTo} : ${offerModel.offerUserName}"
                                : "${LocaleKeys.offeredBy} :  ${offerModel.offerUserName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsManager.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
