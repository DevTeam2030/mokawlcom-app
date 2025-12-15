import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';
import 'package:mokawlcom_app/locale_keys.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.replaceRoute(const AuthRoute());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox.expand(
            child: Image(
              image: AssetImage(AssetsManager.onBoarding),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const[0.65, 0.8, .97],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
                // tileMode: TileMode.decal,
                colors: [
                  ColorsManager.primaryColor.withValues(alpha: 0.8),
                  ColorsManager.primaryColor,
                  const Color(0xFF080C2D),
                ],
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 40,
            start: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  LocaleKeys.welcome,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(color: Colors.white),
                ),
                Text(
                  LocaleKeys.mokawlcomApp,
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall!.copyWith(color: Colors.white),
                ),
                Text(
                  LocaleKeys.welcome2,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
