import 'package:flutter/material.dart';
import '../core/settings/app_preferences_v10.dart';
import '../features/home/home_screen.dart';

class DaleelChildApp extends StatefulWidget {
  const DaleelChildApp({super.key});
  @override State<DaleelChildApp> createState() => _DaleelChildAppState();
}

class _DaleelChildAppState extends State<DaleelChildApp> {
  final prefs = AppPreferencesV10.instance;
  @override void initState() { super.initState(); prefs.load(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
    animation: prefs,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner:false, title:'معلمي', themeMode:prefs.themeMode,
      theme:_theme(Brightness.light), darkTheme:_theme(Brightness.dark),
      locale:const Locale('ar'), home:const HomeScreen(),
    ),
  );
  ThemeData _theme(Brightness brightness) {
    final dark=brightness==Brightness.dark;
    final scheme=ColorScheme.fromSeed(seedColor:const Color(0xFF6750A4),brightness:brightness);
    return ThemeData(
      useMaterial3:true, brightness:brightness, colorScheme:scheme,
      scaffoldBackgroundColor:dark?const Color(0xFF111118):const Color(0xFFF8F7FF),
      appBarTheme:AppBarTheme(centerTitle:true,elevation:0,scrolledUnderElevation:0,backgroundColor:Colors.transparent,foregroundColor:scheme.onSurface),
      cardTheme:CardThemeData(margin:const EdgeInsets.only(bottom:12),elevation:dark?1:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22))),
      inputDecorationTheme:InputDecorationTheme(border:OutlineInputBorder(borderRadius:BorderRadius.circular(18))),
    );
  }
}
