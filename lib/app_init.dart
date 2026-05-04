import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/bloc_observer.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constants.dart';
import 'package:mokawlcom_app/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

class AppInitializer {
  static Future<void> init() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Bloc.observer = MyBlocObserver();
    final sharedPrefHelper = await SharedPrefHelper.init();
    final cacheHelper = CacheHelper(sharedPrefHelper);

    ServiceLocator().init(
      sharedPrefHelper: sharedPrefHelper,
      cacheHelper: cacheHelper,
    );

    AppConstants.token =
        await cacheHelper.readData(key: AppConstants.tokenKey) ?? "";
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path,
      ),
    );
    await _initFirebase();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _initNotifications();
  }

  static Future<void> _initNotifications() async {
    try {
      final fcm = FcmInitHelper();

      await fcm.initAwesomeNotification();
      await fcm.setAwesomeNotificationListeners();
      await fcm.initFirebaseMessagingListeners();
      
      // Delay navigation logic to avoid crashing the unmounted AppRouter
      Future.delayed(const Duration(milliseconds: 1000), () {
        fcm.handleInitialMessage();
      });
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  }
}
