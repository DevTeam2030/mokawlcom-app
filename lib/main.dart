import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/app_init.dart';
import 'package:mokawlcom_app/bloc_observer.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/core/widgets/app_error_screen.dart';
import 'package:mokawlcom_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokawlcom_app/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint("FLUTTER ERROR: ${details.exception}");
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("PLATFORM ERROR: $error");
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) =>
      AppErrorScreen(details: details);

  try {
    await AppInitializer.init();
    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint("INIT ERROR: $e");
    debugPrintStack(stackTrace: stack);

    runApp(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization failed'))),
      ),
    );
  }
}
