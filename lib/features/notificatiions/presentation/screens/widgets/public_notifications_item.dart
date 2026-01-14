import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/notificatiions/data/models/public_notificarion_model.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class PublicNotificationItem extends StatelessWidget {
  const PublicNotificationItem({
    super.key,
    required this.theme,
    required this.notification,
  });
  final ThemeData theme;
  final PublicNotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierLabel: notification.title,
          barrierDismissible: true,
          barrierColor: Colors.black12,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) {
            return FractionallySizedBox(
              heightFactor: .5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                             "${notification.date} - ${notification.time}",
                              style: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: ColorsManager.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              notification.body,
                              style: theme.textTheme.labelSmall!.copyWith(
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: TextButton(
                                onPressed: () => Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(),
                                child: Text(
                                  LocaleKeys.close,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          transitionBuilder: (_, anim, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            );
          },
        );
      },
      child: ColoredBox(
        color: ColorsManager.surfaceColor,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                "${notification.date} - ${notification.time}",
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: ColorsManager.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall!.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
