
import 'package:flutter/material.dart';

class AppThemeV25 {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Tajawal',
    colorSchemeSeed: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFFF8F9FC),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Tajawal',
    colorSchemeSeed: Colors.indigo,
  );
}
