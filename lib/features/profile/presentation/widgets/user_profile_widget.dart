import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileItem(
          theme: theme,
          title: LocaleKeys.editMyProfile,
          icon: Icons.edit_outlined,
          onTap: () {
            context.pushRoute(const EditUserProfileRoute());
          },
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.notifications,
          icon: MyIcons.solidnotifications,
          onTap: () {
            final tabsRouter = AutoTabsRouter.of(context);
              tabsRouter.setActiveIndex(1);
          },
          iconSize: 22.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.presentedOffers,
          icon: MyIcons.list,
          onTap: () {},
          iconSize: 16.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.changePassword,
          icon: MyIcons.eyesolid,
          onTap: () {},
          iconSize: 16.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.language,
          icon: MyIcons.language,
          isLanguage: true,
          onTap: () {},
          iconSize: 18.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.logout,
          icon: MyIcons.exit,
          onTap: () {},
          iconSize: 18.0,
        ),
      ],
    );
  }
}
