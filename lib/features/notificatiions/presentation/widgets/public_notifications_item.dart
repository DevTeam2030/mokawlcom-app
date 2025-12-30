import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

class PublicNotificationItem extends StatelessWidget {
  const PublicNotificationItem({super.key, required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierLabel: "Notification",
          barrierDismissible: true,
          barrierColor: Colors.black12,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) {
            return Center(
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
                            "أهلا بكم في تطبيق مقاولاتكم",
                            style: theme.textTheme.labelMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "02 Jan 2023 09:43 AM",
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: ColorsManager.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان. يمكن أن يكون النص طويلاً جدًا لذا استخدم Scroll عند الحاجة.",
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
                "أهلا بكم في تطبيق مقاولاتكم",
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                "02 Jan 2023 09:43 AM",
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: ColorsManager.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "هذا نص تجريبي لاختبار شكل و حجم النصوص و طريقة عرضها في هذا المكان",
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
