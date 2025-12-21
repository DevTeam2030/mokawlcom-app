import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/notificatiions/presentation/widgets/public_notifications_item.dart';

@RoutePage()
class PublicNotificationsScreen extends StatelessWidget {
  const PublicNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const Divider(
        color: ColorsManager.secondaryColor,
        thickness: .5,
        height: 1,
      ),
      itemBuilder: (context, index) => PublicNotificationItem(theme: theme),
    );
  }
}
