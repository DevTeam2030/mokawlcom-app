import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/visitor_widget.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.profile,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsManager.primaryColor,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsetsDirectional.all(16.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: VisitorWidget(),
        ),
      ),
    );
  }
}
