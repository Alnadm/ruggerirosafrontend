import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode =
      ThemeMode.system.obs; // Use Rx<ThemeMode> for reactivity

  void toggleTheme() {
    if (themeMode.value == ThemeMode.system) {
      // If the current theme is system theme, switch to the opposite theme
      if (Get.isDarkMode) {
        themeMode.value = ThemeMode.light;
      } else {
        themeMode.value = ThemeMode.dark;
      }
    } else {
      // If the current theme is manually set, switch to the system theme
      themeMode.value = ThemeMode.system;
    }
    Get.changeThemeMode(themeMode.value);
  }
}

class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    colorScheme: const ColorScheme.dark(),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    primaryColor: Colors.black,
    drawerTheme: const DrawerThemeData(
      backgroundColor: const Color(0xFF302E2E),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      button: TextStyle(color: Colors.white),
      overline: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    cardColor: Color(0xFF6B420C),
    cardTheme: CardTheme(
      color: Color(0xFF313030),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 20, 20, 20),
    ),
    dialogBackgroundColor: Colors.grey.shade900,
    dividerColor: Color.fromARGB(255, 48, 48, 48),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 246, 246, 246),
    colorScheme: const ColorScheme.light(),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    primaryColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      backgroundColor: const Color(0xFF302E2E),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: Colors.black),
      button: TextStyle(color: Colors.white),
      overline: TextStyle(color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 17, 162, 104),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    cardColor: Color(0xFF93550C),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 235, 235, 235),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xfff6f6f6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    dividerColor: Colors.grey[200],
  );
}
