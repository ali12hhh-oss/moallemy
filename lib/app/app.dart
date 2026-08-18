import 'package:flutter/material.dart';
import '../core/settings/app_preferences_v10.dart';
import '../core/theme/app_theme_v25.dart';
import '../features/home/home_screen.dart';
import '../widgets/app_feedback.dart';

class DaleelChildApp extends StatefulWidget {
  const DaleelChildApp({super.key});

  @override
  State<DaleelChildApp> createState() => _DaleelChildAppState();
}

class _DaleelChildAppState extends State<DaleelChildApp> {
  final prefs = AppPreferencesV10.instance;

  @override
  void initState() {
    super.initState();
    prefs.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: prefs,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'معلمي',
        themeMode: prefs.themeMode,
        theme: AppThemeV25.light(),
        darkTheme: AppThemeV25.dark(),
        locale: const Locale('ar'),
        home: const _AppRoot(),
      ),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        HomeScreen(),
        Positioned.fill(child: AppFeedbackOverlay()),
      ],
    );
  }
}
