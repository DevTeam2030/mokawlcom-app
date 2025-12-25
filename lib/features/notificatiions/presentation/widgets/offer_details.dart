import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/shared/widgets/offer_price_bottom_sheet.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:vector_graphics/vector_graphics.dart';

class OfferDetails extends StatelessWidget {
  const OfferDetails({super.key, required this.theme, this.isOffer = false});
  final ThemeData theme;
  final bool isOffer;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isOffer ? const Color(0xFFFBFCFE) : Colors.transparent,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        child: Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOffer
                          ? LocaleKeys.offerPrice
                          : LocaleKeys.messageAddress,
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
                        color: ColorsManager.textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${LocaleKeys.offeredBy} :  محمد احمد",
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: ColorsManager.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان",
              style: theme.textTheme.labelSmall!.copyWith(
                height: 1.5,
                color: ColorsManager.textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (isOffer)
              Row(
                children: [
                  const VectorGraphic(
                    loader: AssetBytesLoader(AssetsManager.pdf),
                  ),
                  const SizedBox(width: 10),
                  // 
                  const Icon(
                    Icons.image_outlined,
                    size: 45,
                    color: ColorsManager.primaryColor,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => OfferPriceBottomSheet(
                          address: LocaleKeys.replyToThePriceOffer,
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
            if (isOffer) const CustomDivider(thickness: 0.5, height: 1),
          ],
        ),
      ),
    );
  }
}
