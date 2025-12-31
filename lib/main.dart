import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokawlcom_app/bloc_observer.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mokawlcom_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ServiceLocator().init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
