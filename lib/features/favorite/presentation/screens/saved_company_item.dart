import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/my_icons.dart';

class SavedCompanyItem extends StatelessWidget {
  const SavedCompanyItem({
    super.key,
    required this.theme,
    required this.favoriteModel,
  });
  final ThemeData theme;
  final FavoriteModel favoriteModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushRoute(
        ContractorDetailsRoute(contractorId: favoriteModel.contractorId),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorsManager.lightGrayBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsManager.primaryColor.withValues(alpha: .2),
                ),
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage(AssetsManager.appLogo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "شركة المقاولات العامة",
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "الرياض - حي الملز",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: ColorsManager.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(MyIcons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "4.5",
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.bookmark_remove,
            //     color: ColorsManager.primaryColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
