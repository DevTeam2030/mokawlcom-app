import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/screens/widgets/show_language_bottom_sheet.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class VisitorProfileWidget extends StatelessWidget {
  const VisitorProfileWidget({super.key, required this.theme});
  final ThemeData theme;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileItem(
          theme: theme,
          title: LocaleKeys.login,
          icon: MyIcons.lockfill,
          onTap: () {
            context.replaceRoute(const AuthRoute());
          },
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.registerAsContractor,
          icon: MyIcons.contractor,
          onTap: () {
            context.pushRoute(
              const AuthRoute(children: [ClassificationRoute()]),
            );
          },
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.language,
          isLanguage: true,
          icon: MyIcons.language,
          onTap: () async {
            await showLanguageBottomSheet(context);
          },
        ),
      ],
    );
  }
}
