import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class ContractorProfileWidget extends StatelessWidget {
  const ContractorProfileWidget({super.key, required this.theme});
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
          onTap: () {},
          iconSize: 22.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.myServices,
          icon: MyIcons.list,
          onTap: () {},
          iconSize: 16.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.availableDeals,
          icon: MyIcons.send,
          onTap: () {},
          iconSize: 20.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.subscriptionDetails,
          icon: MyIcons.subscribtion,
          onTap: () {},
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
          onTap: () {},
          iconSize: 18.0,
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.logout,
          icon: MyIcons.exit,
          onTap: () async{
            context.replaceRoute(const AuthRoute());
            context.read<AppCubit>().changeUserType(userType: UserType.visitor);
            AppConstans.token = "";
            await getIt<CacheHelper>().deleteAll();
          },
          iconSize: 18.0,
        ),
      ],
    );
  }
}
