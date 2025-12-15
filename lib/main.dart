import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/services/service_locator.dart';
import 'package:mokawlcom_app/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  runApp(const MyApp());
}
