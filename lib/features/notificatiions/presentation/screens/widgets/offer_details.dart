import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/utils/lanuch_utils.dart';
import 'package:mokawlcom_app/core/utils/show_toast.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/auth/presentation/screens/widgets/verification/error_dialog.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/contractor_details/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/offer_model.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/cubit/offer_details_cubit.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/screens/widgets/reply_on_offer_bottom_sheet.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';
import 'package:vector_graphics/vector_graphics.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({
    super.key,
    required this.theme,
    this.isOffer = false,
    required this.offerNotificationModel,
    required this.offerDetailsCubit,
  });
  final ThemeData theme;
  final bool isOffer;
  final OfferModel offerNotificationModel;
  final OfferDetailsCubit offerDetailsCubit;
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
                          image: ResizeImage(
                            AssetImage(AssetsManager.appLogo),
                            width: 48,
                            height: 48,
                          ),
                          fit: BoxFit.cover,
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
                          FittedBox(
                            child: Text(
                              "${offerNotificationModel.price}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                          ),
                          Text(
                            LocaleKeys.sar,
                            style: theme.textTheme.labelSmall!.copyWith(
                              color: ColorsManager.primaryColor,
                            ),
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
                              context.pushRoute(
                                PdfRoute(pdfUrl: offerNotificationModel.url),
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
                              showDialog(
                                context: context,
                                builder: (dialogContext) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: AspectRatio(
                                    aspectRatio: 3 / 4,
                                    child: Stack(
                                      children: [
                                        InteractiveViewer(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: CustomCachedNetworkImage(
                                              height: 350,
                                              width: double.infinity,
                                              imageUrl:
                                                  offerNotificationModel.url,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        PositionedDirectional(
                                          top: 10,
                                          start: 10,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: .2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomCachedNetworkImage(
                                width: 300,
                                height: 300,
                                imageUrl: offerNotificationModel.url,
                                fit: BoxFit.cover,
                              ),
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
                              child: BlocProvider.value(
                                value: offerDetailsCubit,
                                child: ReplyOnOfferBottomSheet(
                                  address: LocaleKeys.replyToThePriceOffer,
                                  offerId: offerNotificationModel.offerId
                                      .toString(),
                                ),
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
