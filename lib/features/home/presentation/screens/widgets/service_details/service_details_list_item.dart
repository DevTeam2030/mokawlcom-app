import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/home/data/models/contractor_service_model.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_details/expandable_text_widget.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class ServiceDetailsListItem extends StatelessWidget {
  const ServiceDetailsListItem({
    super.key,
    required this.theme,
    required this.contractorServiceModel,
  });

  final ThemeData theme;
  final ContractorServiceModel contractorServiceModel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            if(contractorServiceModel.images.isNotEmpty)
            SizedBox(
              height: 168,
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                itemCount: contractorServiceModel.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ImageLightBox(
                        images: contractorServiceModel.images,
                        initialIndex: index,
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomCachedNetworkImage(
                      imageUrl: contractorServiceModel.images[index],
                      height: 166,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
             if(contractorServiceModel.images.isNotEmpty)
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
                      color: ColorsManager.accentTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${LocaleKeys.priceAverage} : ${contractorServiceModel.price}",
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontSize: 10,
                      color: ColorsManager.purpleAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ExpandableTextWidget(
                    text: contractorServiceModel.description,
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
                child: CustomCachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
