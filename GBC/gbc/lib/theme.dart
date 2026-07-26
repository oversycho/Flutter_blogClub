import 'package:flutter/material.dart';

// ==== COLOR PALETTES ====

class LightThemeColors {
  static const primaryColor = Color(0xff007AFF);
  static const secondaryColor = Color(0xff262a35);
  static const primaryTextColor = Color(0xff262a35);
  static const secondaryTextColor = Color.fromARGB(255, 127, 127, 129);
  static const backgroundColor = Color(0xffF5F6FA);
  static const surfaceColor = Colors.white;
  static const errorColor = Color(0xffE53935);
}

class DarkThemeColors {
  static const primaryColor = Color(0xff0A84FF);
  static const secondaryColor = Color(0xffE5E5EA);
  static const primaryTextColor = Color(0xffF5F5F7);
  static const secondaryTextColor = Color.fromARGB(255, 158, 158, 162);
  static const backgroundColor = Color(0xff121214);
  static const surfaceColor = Color(0xff1C1C1E);
  static const errorColor = Color(0xffFF453A);
}

// ==== THEME CONFIGS ====

class AppTheme {
  static const _fontFamily = 'IranYekan';

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: LightThemeColors.backgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        color: LightThemeColors.primaryTextColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        color: LightThemeColors.primaryTextColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        color: LightThemeColors.primaryTextColor,
        fontWeight: FontWeight.w700,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: LightThemeColors.secondaryTextColor,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: LightThemeColors.primaryColor,
      secondary: LightThemeColors.secondaryColor,
      surface: LightThemeColors.surfaceColor,
      error: LightThemeColors.errorColor,
      onSecondary: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: DarkThemeColors.backgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        color: DarkThemeColors.primaryTextColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: _fontFamily,
        color: DarkThemeColors.primaryTextColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        fontFamily: _fontFamily,
        color: DarkThemeColors.primaryTextColor,
        fontWeight: FontWeight.w700,
      ),
      labelSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: DarkThemeColors.secondaryTextColor,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: DarkThemeColors.primaryColor,
      secondary: DarkThemeColors.secondaryColor,
      surface: DarkThemeColors.surfaceColor,
      error: DarkThemeColors.errorColor,
      onSecondary: Colors.black,
    ),
  );
}
