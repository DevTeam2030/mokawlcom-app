import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mokawlcom_app/app_init.dart';
import 'package:mokawlcom_app/bloc_observer.dart';
import 'package:mokawlcom_app/core/local/cache_helper.dart';
import 'package:mokawlcom_app/core/local/shared_pref_helper.dart';
import 'package:mokawlcom_app/core/services/notifications/fcm_init_helper.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/core/utils/app_constans.dart';
import 'package:mokawlcom_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokawlcom_app/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

late SharedPrefHelper sharedPrefHelper;
late CacheHelper cacheHelper;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
   await AppInitializer.init();

  runApp(const MyApp());
}

