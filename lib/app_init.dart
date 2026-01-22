import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/bloc_observer.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

class AppInitializer {
  static Future<void> init() async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();

 
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );

    final sharedPrefHelper = await SharedPrefHelper.init();
    final cacheHelper = CacheHelper(sharedPrefHelper);

    ServiceLocator().init(
      sharedPrefHelper: sharedPrefHelper,
      cacheHelper: cacheHelper,
    );

    AppConstants.token =
        await cacheHelper.readData(key: AppConstants.tokenKey) ?? "";

    final fcm = getIt<FcmInitHelper>();
    await fcm.initAwesomeNotification();
    await fcm.setAwesomeNotificationListeners();
    fcm.initFirebaseMessagingListeners();
    await fcm.handleInitialMessage();
     SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  }
}
