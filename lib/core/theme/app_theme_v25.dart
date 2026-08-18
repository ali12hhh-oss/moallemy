import 'package:flutter/material.dart';

class AppThemeV25 {
  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    const violet = Color(0xFF7C4DFF);
    const cyan = Color(0xFF00A6E8);
    const pink = Color(0xFFE94F9B);
    const green = Color(0xFF16B878);
    final scheme = ColorScheme.fromSeed(
      seedColor: violet,
      brightness: brightness,
      primary: violet,
      secondary: cyan,
      tertiary: pink,
      surface: dark ? const Color(0xFF24304A) : const Color(0xFFFFFBFF),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: dark
          ? const Color(0xFF202A43)
          : const Color(0xFFF8F4FF),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: dark ? const Color(0xFF273451) : const Color(0xFFF1E9FF),
        foregroundColor: dark ? Colors.white : const Color(0xFF30264A),
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : const Color(0xFF30264A),
          fontSize: 23,
          fontWeight: FontWeight.w900,
          fontFamily: 'Tajawal',
        ),
      ),
      cardColor: dark ? const Color(0xFF2C3855) : Colors.white,
      cardTheme: CardThemeData(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: dark ? 5 : 4,
        shadowColor: dark ? const Color(0xFF000000).withValues(alpha: .30) : violet.withValues(alpha: .16),
        surfaceTintColor: violet.withValues(alpha: .08),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      iconTheme: IconThemeData(color: dark ? const Color(0xFFBDA9FF) : violet),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF303D5C) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18)), borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18)), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(18)), borderSide: BorderSide(color: violet, width: 2)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 22)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          elevation: const WidgetStatePropertyAll(5),
          shadowColor: WidgetStatePropertyAll(violet.withValues(alpha: .34)),
          backgroundColor: WidgetStatePropertyAll(violet),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          side: const WidgetStatePropertyAll(BorderSide(color: violet, width: 1.7)),
          foregroundColor: WidgetStatePropertyAll(dark ? Colors.white : violet),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: dark ? const Color(0xFF33405F) : const Color(0xFFEDE4FF),
        selectedColor: violet,
        labelStyle: TextStyle(fontWeight: FontWeight.w800, color: dark ? Colors.white : const Color(0xFF30264A)),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: green,
        linearTrackColor: dark ? const Color(0xFF3A4766) : const Color(0xFFE4DCF5),
      ),
    );
  }
}
