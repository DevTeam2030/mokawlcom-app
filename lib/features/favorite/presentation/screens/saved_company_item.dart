import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/custom_cached_network_image.dart';
import 'package:mokawlcom_app/features/favorite/data/models/favorite_model.dart';
import 'package:mokawlcom_app/features/favorite/presentation/cubit/cubit/favorite_cubit.dart';
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
              ),
              child: CustomCachedNetworkImage(
                imageUrl: favoriteModel.logo,
                height: 60,
                width: 60,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favoriteModel.companyName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    favoriteModel.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
                        favoriteModel.rate.toString(),
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<FavoriteCubit>().removeFavorite(
                 contractorId: favoriteModel.contractorId,
                );
              },
              icon: const Icon(
                Icons.bookmark_remove,
                color: ColorsManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
