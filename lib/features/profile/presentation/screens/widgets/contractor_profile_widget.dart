import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_delete_account_bottom_sheet.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_language_bottom_sheet.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_logout_bottom_sheet.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';
import 'package:mokawlcom_app/core/utils/my_icons.dart';

class ContractorProfileWidget extends StatelessWidget {
  const ContractorProfileWidget({
    super.key,
    required this.theme,
    required this.profileCubit,
  });
  final ProfileCubit profileCubit;
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
            context.pushRoute(const EditContractorProfileRoute());
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
          title: LocaleKeys.myServices,
          icon: MyIcons.list,
          onTap: () {
            context.pushRoute(const MyServicesRoute());
          },
          iconSize: 16.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.availableDeals,
          icon: MyIcons.send,
          onTap: () {
            context.pushRoute(const AvailableDealsRoute());
          },
          iconSize: 20.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.subscriptionDetails,
          icon: MyIcons.subscribtion,
          onTap: () {
            context.pushRoute( MyCurrentPackageRoute(profileCubit: profileCubit));
          },
          iconSize: 20.0,
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
    );
  }
}
