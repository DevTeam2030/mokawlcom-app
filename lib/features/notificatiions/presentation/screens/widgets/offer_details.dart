import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/reply_on_offer_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:vector_graphics/vector_graphics.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({
    super.key,
    required this.theme,
    this.isOffer = false,
    required this.offerNotificationModel,
  });
  final ThemeData theme;
  final bool isOffer;
  final OfferModel offerNotificationModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      child: Column(
        children: [
          ColoredBox(
            color: isOffer ? ColorsManager.surfaceColor : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offerNotificationModel.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            textDirection: TextDirection.rtl,
                            "${offerNotificationModel.time} - ${offerNotificationModel.date}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: ColorsManager.labelColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${LocaleKeys.offeredBy} : ${offerNotificationModel.offerUserName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: ColorsManager.labelColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${offerNotificationModel.price}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                LocaleKeys.sar,
                                style: theme.textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  offerNotificationModel.message,
                  style: theme.textTheme.labelSmall!.copyWith(
                    height: 1.5,
                    color: ColorsManager.accentTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    offerNotificationModel.isPdf
                        ? InkWell(
                            onTap: () {
                              LaunchUtils.open(
                                url: offerNotificationModel.url,
                                onError: (msg) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ErrorDialog(
                                      theme: theme,
                                      message: msg,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const VectorGraphic(
                              loader: AssetBytesLoader(AssetsManager.pdf),
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(width: 10),
                    !offerNotificationModel.isPdf &&
                            offerNotificationModel.url.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              LaunchUtils.open(
                                url: offerNotificationModel.url,
                                onError: (msg) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ErrorDialog(
                                      theme: theme,
                                      message: msg,
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: ColorsManager.primaryColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const Spacer(),
                    if (isOffer)
                      TextButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            useSafeArea: true,
                            context: context,
                            builder: (context) => FractionallySizedBox(
                              heightFactor: 1,
                              child: ReplyOnOfferBottomSheet(
                                address: LocaleKeys.replyToThePriceOffer,
                                offerId: offerNotificationModel.offerId
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          LocaleKeys.addReply,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isOffer) const CustomDivider(thickness: 0.5, height: 3),
        ],
      ),
    );
  }
}
