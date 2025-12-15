import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/features/auth/presentation/login_screen.dart';
import 'package:mokawlcom_app/features/auth/presentation/signup_screen.dart';
import 'package:mokawlcom_app/features/splash/on_boarding_screen.dart';
import 'package:mokawlcom_app/features/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  AppRouter() : super(navigatorKey: rootNavigatorKey);

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: SplashTabRoute.page,
      children: [
        AutoRoute(initial: true, page: SplashRoute.page),
        _buildCustomRoute(page: OnBoardingRoute.page),
      ],
    ),
    _buildCustomRoute(
      page: AuthRoute.page,
      children: [
        _buildCustomRoute(initial: true, page: LoginRoute.page),
        _buildCustomRoute(page: SignupRoute.page),
      ],
    ),
  ];

  CustomRoute _buildCustomRoute({
    bool initial = false,
    required PageInfo page,
    List<AutoRoute>? children,
  }) {
    return CustomRoute(
      initial: initial,
      page: page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      duration: const Duration(milliseconds: 300),
      children: children,
    );
  }
}

@RoutePage(name: 'SplashTabRoute')
class Splash extends AutoRouter {
  const Splash({super.key});
}

@RoutePage(name: 'AuthRoute')
class Auth extends AutoRouter {
  const Auth({super.key});
}
