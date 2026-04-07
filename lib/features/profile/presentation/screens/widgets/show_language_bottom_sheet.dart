import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/presentation/cubit/app_state.dart';
import 'package:mokawlcom_app/core/utils/locale_keys.dart';

Future<void> showLanguageBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: BlocSelector<AppCubit, AppState, bool>(
          selector: (state) {
            return state.isArabic;
          },
          builder: (context, isArabic) {
            return Column(
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
                    if (AppConstants.language == "en") {
                      return;
                    }
                    context.read<AppCubit>().changeLanguage(isArabic: false);
                    context.router.replaceAll([const SplashTabRoute()]);
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
                    if (AppConstants.language == "ar") {
                      return;
                    }
                    context.read<AppCubit>().changeLanguage(isArabic: true);

                    context.router.replaceAll([const SplashTabRoute()]);
                  },
                ),

                const SizedBox(height: 10),
              ],
            );
          },
        ),
      );
    },
  );
}
