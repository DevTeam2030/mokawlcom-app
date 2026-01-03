 
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/core/widgets/primary_button.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_state.dart';
import 'package:mokawlcom_app/locale_keys.dart';
import 'package:mokawlcom_app/my_icons.dart';
import 'package:mokawlcom_app/my_app.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

Future<void> showLogoutBottomSheet({ required  context, required  theme}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   width: 40,
              //   height: 4,
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade300,
              //     borderRadius: BorderRadius.circular(2),
              //   ),
              // ),
              const SizedBox(height: 40),
              Text(
                LocaleKeys.doYouWantToLogout,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorsManager.errorLight),
                ),
                child: PrimaryButton(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: LocaleKeys.cancel,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                backgroundColor: ColorsManager.errorLight,
                textColor: Colors.white,
                onPressed: () async {
                  Navigator.pop(context);
                  context.replaceRoute(const AuthRoute());
                  context.read<AppCubit>().changeUserType(
                    userType: UserType.visitor,
                  );
                  AppConstans.token = "";
                  await getIt<CacheHelper>().deleteAll();
                },
                text: LocaleKeys.exit,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }