import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_divider.dart';
import 'package:mokawlcom_app/features/home/presentation/widgets/job_details/service_item.dart';

class JobDetailsTopSection extends StatelessWidget {
  const JobDetailsTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 44.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: ColorsManager.secondaryColor, width: .5),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorsManager.secondaryColor,
                width: .5,
              ),
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AssetsManager.logoImage),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Text(
                'شركة المقاولات العامة',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
          const CustomDivider(thickness: 0.5),
          FittedBox(
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 38,
              decoration: BoxDecoration(
                color: ColorsManager.fillColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: ColorsManager.secondaryColor,
                  width: .3,
                ),
              ),
              child: Text("مقاول", style: theme.textTheme.bodySmall),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 46,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => const ServiceItem(),
              separatorBuilder: (_, _) => const SizedBox(width: 13),
              itemCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}
