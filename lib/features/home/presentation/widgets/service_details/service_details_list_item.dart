import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class ServiceDetailsListItem extends StatelessWidget {
  const ServiceDetailsListItem({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            SizedBox(
              height: 168,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10.0,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: Image(
                    height: 166,
                    width: 250,
                    fit: BoxFit.cover,
                    image: AssetImage(AssetsManager.homeBanner),
                  ),
                ),
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemCount: 4,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 14.0,
                end: 14.0,
                bottom: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.serviceName,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "متوسط السعر : 100 ريال",
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  Text(
                    "وصف الخدمة: هذه الخدمة تشمل جميع الأعمال المتعلقة بتركيب وصيانة الأنظمة الكهربائية في المباني السكنية والتجارية. نحن نقدم حلولاً مخصصة لتلبية احتياجات عملائنا مع ضمان أعلى معايير الجودة والسلامة.",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: ColorsManager.primaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
