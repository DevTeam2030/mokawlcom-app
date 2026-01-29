import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';

class AppRoutesObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint('[INFO] New route pushed: ${route.settings.name}');
    AppConstants.currentRoute.value = route.settings.name ?? "";
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('[INFO] Route Popped : ${route.settings.name}');
    AppConstants.currentRoute.value = previousRoute?.settings.name ?? "";
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint('[INFO] Route Removed : ${route.settings.name}');
    AppConstants.currentRoute.value = previousRoute?.settings.name ?? "";
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint(
      '[INFO] OldRoute : ${oldRoute!.settings.name} was replaced by ${newRoute?.settings.name}',
    );
    AppConstants.currentRoute.value = newRoute?.settings.name ?? "";
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    debugPrint('[INFO] Tab route visited: ${route.name}');
    AppConstants.currentRoute.value = route.name;
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    debugPrint('[INFO] Tab route re-visited: ${route.name}');
    AppConstants.currentRoute.value = route.name;
  }
}
