import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/service_details/expandable_text_widget.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class ServiceDetailsListItem extends StatelessWidget {
  const ServiceDetailsListItem({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final images = List.generate(4, (_) => AssetsManager.homeBanner);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            /// Images slider
            SizedBox(
              height: 168,
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          ImageLightBox(images: images, initialIndex: index),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      images[index],
                      height: 166,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),

            /// Details
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.serviceName,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF42498A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "متوسط السعر : 100 ريال",
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontSize: 10,
                      color: const Color(0xFF4F378B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ExpandableTextWidget(
                    text:
                        "وصف الخدمة: هذه الخدمة تشمل جميع الأعمال المتعلقة بتركيب وصيانة الأنظمة الكهربائية في المباني السكنية والتجارية. نحن نقدم حلولاً مخصصة لتلبية احتياجات عملائنا مع ضمان أعلى معايير الجودة والسلامة.",
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

class ImageLightBox extends StatelessWidget {
  const ImageLightBox({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  final List<String> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Image.asset(images[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
      ),
    );
  }
}
