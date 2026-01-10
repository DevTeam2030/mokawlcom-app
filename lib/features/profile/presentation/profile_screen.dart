import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/contractor_profile_widget.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/profile_item.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/user_profile_widget.dart';
import 'package:mokawlcom_app/features/profile/presentation/widgets/visitor_profile_widget.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
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
      body: Padding(
        padding: const EdgeInsetsDirectional.all(16.0),
        child: BlocSelector<AppCubit, AppState, UserType>(
          selector: (state) {
            return state.userType;
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: switch (state) {
                UserType.user => UserProfileWidget(theme: theme),
                UserType.contractor => ContractorProfileWidget(theme: theme),
                UserType.visitor => VisitorProfileWidget(theme: theme),
              },
            );
          },
        ),
      ),
    );
  }
}
