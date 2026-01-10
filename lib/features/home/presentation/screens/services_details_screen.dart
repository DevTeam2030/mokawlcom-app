import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/home/presentation/screens/widgets/service_details/service_details_list_item.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class ServicesDetailsScreen extends StatelessWidget {
  const ServicesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      itemBuilder: (context, index) => ServiceDetailsListItem(theme: theme),
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemCount: 3,
    );
  }
}
