import 'package:flutter/material.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

class VisitorProfileWidget extends StatelessWidget {
  const VisitorProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ProfileItem(
          theme: theme,
          title: LocaleKeys.login,
          icon: MyIcons.lockfill,
          onTap: () {},
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.registerAsContractor,
          icon: MyIcons.contractor,
          onTap: () {},
        ),
        const SizedBox(height: 16.0),
        ProfileItem(
          theme: theme,
          title: LocaleKeys.language,
          isLanguage: true,
          icon: MyIcons.language,
          onTap: () {},
        ),
      ],
    );
  }
}
