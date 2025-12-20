import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mokawlcom_app/core/utils/assets_manager.dart';
import 'package:mokawlcom_app/core/utils/colors_manager.dart';

class ThemeManager {
  static ThemeData lightTheme() {
    return ThemeData(
      fontFamily: AssetsManager.primaryFontFamily,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(seedColor: ColorsManager.primaryColor),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 10,
        iconTheme: IconThemeData(color: ColorsManager.primaryColor, size: 24.0),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(color: Colors.black26, size: 24.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFFBFCFE),
        selectedItemColor: ColorsManager.primaryColor,
        unselectedItemColor: Color(0xFF798AA3),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        dividerColor: Colors.transparent,
        indicatorColor: ColorsManager.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ColorsManager.primaryColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: ColorsManager.secondaryColor,
        ),
      ),
    );
  }

  // static ThemeData darkTheme() {
  //   return ThemeData(
  //     scaffoldBackgroundColor: const Color(0xFF1A1C1E),
  //     fontFamily: AssetsManager.primaryFontFamily,
  //     colorScheme: darkColorScheme,
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: Color(0xFF1A1C1E),
  //       scrolledUnderElevation: 0,
  //       elevation: 0,
  //       titleSpacing: 10,
  //       titleTextStyle: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.white,
  //       ),
  //     ),
  //     useMaterial3: true,
  //     textTheme: const TextTheme(
  //       displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
  //       displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
  //       displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
  //       headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
  //       headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
  //       headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
  //       titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
  //       titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //       titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  //       bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  //       bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  //       bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  //       labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  //       labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  //     ),
  //     iconTheme: const IconThemeData(color: Colors.white, size: 24.0),
  //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //       showSelectedLabels: false,
  //       showUnselectedLabels: false,
  //       selectedIconTheme: const IconThemeData(),
  //       type: BottomNavigationBarType.fixed,
  //       backgroundColor: Colors.black.withValues(alpha: 0.8),
  //       unselectedItemColor: Colors.white,
  //     ),
  //   );
  // }
}
