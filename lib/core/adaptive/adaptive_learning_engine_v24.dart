
import 'package:shared_preferences/shared_preferences.dart';

class AdaptiveLearningEngineV24 {
  static Future<void> record(String skill, bool correct) async {
    final p = await SharedPreferences.getInstance();
    final attempts = p.getInt('adaptive.$skill.attempts') ?? 0;
    final successes = p.getInt('adaptive.$skill.successes') ?? 0;
    await p.setInt('adaptive.$skill.attempts', attempts+1);
    if (correct) await p.setInt('adaptive.$skill.successes', successes+1);
  }

  static Future<String> recommendation(List<String> skills) async {
    final p = await SharedPreferences.getInstance();
    String? weakest;
    double best = 2;
    for (final s in skills) {
      final a = p.getInt('adaptive.$s.attempts') ?? 0;
      final c = p.getInt('adaptive.$s.successes') ?? 0;
      final rate = a == 0 ? 0.0 : c/a;
      if (a == 0 || rate < best) { best = rate; weakest = s; }
    }
    return weakest ?? skills.first;
  }
}
