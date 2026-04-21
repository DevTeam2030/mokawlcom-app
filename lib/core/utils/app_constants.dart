import 'package:flutter/material.dart';
import 'package:mokawlcom_app/core/enums/user_type.dart';

class AppConstants {
  static const String serverClientId =
      "200274876402-5tfr9cjfuiqahjjst1ia7ra6n3ss9uii.apps.googleusercontent.com";
  static const String tokenKey = "token";
  static String token = "";
  static ValueNotifier<String> currentRoute = ValueNotifier<String>("");
  static UserType userType = UserType.visitor;
  static String language = "ar";
}
