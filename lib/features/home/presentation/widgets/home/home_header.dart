import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 27,
            backgroundColor: ColorsManager.primaryColor,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: ColorsManager.secondaryColor,
              backgroundImage: AssetImage(AssetsManager.appLogo),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              Text(
                LocaleKeys.mokawlatcom,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: ColorsManager.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                LocaleKeys.fasterAcessBestResults,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: ColorsManager.secondaryColor,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {},
            child: const Icon(
              MyIcons.bookmarks,
              color: ColorsManager.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: const Icon(
              MyIcons.boldnotification,
              color: ColorsManager.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
