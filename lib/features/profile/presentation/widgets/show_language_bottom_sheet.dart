import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';
import 'package:mokawlcom_app/locale_keys.dart';

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      final isArabic =
          context.select((AppCubit cubit) => cubit.state.isArabic);

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              LocaleKeys.language,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.english),
              trailing: !isArabic
                  ? const Icon(
                      Icons.check_circle,
                      color: ColorsManager.primaryColor,
                    )
                  : null,
              onTap: () {
                context.read<AppCubit>().changeLanguage(isArabic: false);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(LocaleKeys.arabic),
              trailing: isArabic
                  ? const Icon(
                      Icons.check_circle,
                      color: ColorsManager.primaryColor,
                    )
                  : null,
              onTap: () {
                context.read<AppCubit>().changeLanguage(isArabic: true);
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
