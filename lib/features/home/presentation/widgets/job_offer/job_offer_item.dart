import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class JobOfferItem extends StatelessWidget {
  const JobOfferItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFD3DFE7), width: .8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16.0,
              end: 8.0,
              top: 8.0,
              bottom: 5.0,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.pushRoute(JobDetailsRoute());
                  },
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundColor: ColorsManager.secondaryColor,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(AssetsManager.logoImage),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context.pushRoute(JobDetailsRoute());
                      },
                      child: Text(
                        'شركة المقاولات العامة',
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.green,
                        ),
                        Text(
                          'الخليج الغربي - الدوحة',
                          style: theme.textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: ColorsManager.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RatingBar.builder(
                      initialRating: 4,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemSize: 18,
                      itemBuilder: (context, index) {
                        return const Icon(MyIcons.star, color: Colors.amber);
                      },
                      unratedColor: ColorsManager.secondaryColor,
                      onRatingUpdate: (_) {},
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20,
                  ),
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F0F4),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: const Color(0xFFD3DFE7),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    "مقاول",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF858BBD),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 17.0),
            child: InkWell(
              onTap: () {
                context.pushRoute(JobDetailsRoute());
              },
              child: Text(
                LocaleKeys.hintAboutCompany,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 17.0, end: 25.0),
            child: Text(
              "شركة المقاولات العامة هي شركة رائدة في مجال البناء والتشييد، تقدم خدمات عالية الجودة وتلتزم بالمواعيد المحددة. نحن نسعى لتلبية احتياجات عملائنا من خلال تقديم حلول مبتكرة ومستدامة.",
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsetsDirectional.only(
              start: 32.0,
              top: 19,
              bottom: 15,
              end: 18.0,
            ),
            decoration: const BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(8.0),
                bottomStart: Radius.circular(8.0),
              ),
            ),
            child: Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsetsDirectional.all(10),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    context.pushRoute(JobDetailsRoute(isOfferrice: true));
                  },
                  child: Text(
                    LocaleKeys.showPrice,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsetsDirectional.all(10),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {},
                  child: const Icon(
                    MyIcons.whats,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 3),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsetsDirectional.all(10),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {},
                  child: const Icon(
                    MyIcons.call,
                    color: ColorsManager.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
