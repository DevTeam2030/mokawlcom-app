import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localingo/localingo.dart';
import 'package:mokawlcom_app/app_routes_observer.dart';
import 'package:mokawlcom_app/config/router/app_router.dart';
import 'package:mokawlcom_app/config/themes/theme_manager.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_cubit.dart';
import 'package:mokawlcom_app/features/shared/cubit/app_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    Localingo.setNavigatorKey(appRouter.navigatorKey);

    return BlocProvider(
      create: (context) => getIt<AppCubit>(),
      child: BlocSelector<AppCubit, AppState, bool>(
        selector: (state) {
          return state.isArabic;
        },
        builder: (context, isArabic) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.config(
              navigatorObservers: () => [
                AppRoutesObserver(),
                AutoRouteObserver(),
              ],
            ),
            locale: isArabic ? const Locale('ar') : const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            theme: ThemeManager.lightTheme(),
          );
        },
      ),
    );
  }
}
