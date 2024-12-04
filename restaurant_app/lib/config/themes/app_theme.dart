import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme(bool isDark) {
    return ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: const Color(0xffff6c44),
        primarySwatch: const MaterialColor(0xffff6c44, {
          50: Color(0xFFffb6a2),
          100: Color(0xFFffa78f),
          200: Color(0xFFff987c),
          300: Color(0xFFff8969),
          400: Color(0xFFff7b57),
          500: Color(0xffff6c44),
          600: Color(0xFFe6613d),
          700: Color(0xFFcc5636),
          800: Color(0xFFb34c30),
          900: Color(0xFF994129),
        }),
        scaffoldBackgroundColor: isDark ? const Color(0xff202020) : null,
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: Color(0xff303030),
                secondary: Color(0xff101010),
                tertiary: Color(0xfff3f3f3),
              )
            : const ColorScheme.light(
                primary: Color(0xfff3f3f3),
                secondary: Color(0xfffefefe),
                tertiary: Color(0xff303030),
              ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDark ? const Color(0xff303030) : const Color(0xfff3f3f3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Blinker',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color(0xffff6c44),
          ),
          titleSmall: TextStyle(
            fontFamily: 'Blinker',
            fontSize: 16,
            // fontWeight: FontWeight.w600,
            color: Color(0xffff6c44),
          ),
          labelMedium: TextStyle(
            fontFamily: 'Blinker',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            padding:
                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xffff6c44),
            ),
            fixedSize: MaterialStateProperty.all<Size>(
              const Size(double.infinity, 50),
            ),
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}
