import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_delete_account_bottom_sheet.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_language_bottom_sheet.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_logout_bottom_sheet.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    super.key,
    required this.theme,
    required this.profileCubit,
  });
  final ThemeData theme;
  final ProfileCubit profileCubit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            onTap: () {
              context.navigateTo(
                const NotificationsRoute(
                  children: [SubmittedPriceOffersRoute()],
                ),
              );
            },
            iconSize: 16.0,
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            theme: theme,
            title: LocaleKeys.changePassword,
            icon: MyIcons.eyesolid,
            onTap: () {
              context.pushRoute(const ChangePasswordRoute());
            },
            iconSize: 16.0,
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            theme: theme,
            title: LocaleKeys.language,
            icon: MyIcons.language,
            isLanguage: true,
            onTap: () {
              showLanguageBottomSheet(context);
            },
            iconSize: 18.0,
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            theme: theme,
            title: LocaleKeys.deleteAccount,
            icon: MyIcons.trash,
            onTap: () {
              showDeleteAccountBottomSheet(
                context: context,
                theme: theme,
                profileCubit: profileCubit,
              );
            },
            iconSize: 20.0,
          ),
          const SizedBox(height: 16.0),
          ProfileItem(
            theme: theme,
            title: LocaleKeys.logout,
            icon: MyIcons.exit,
            onTap: () async {
              await showLogoutBottomSheet(
                context: context,
                theme: theme,
                profileCubit: profileCubit,
              );
            },
            iconSize: 18.0,
          ),
        ],
      ),
    );
  }
}
