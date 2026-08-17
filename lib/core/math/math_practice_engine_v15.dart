
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/progress_v8.dart';

class MathQuestionV15 {
  final String skillId;
  final String prompt;
  final int answer;
  final List<int> options;
  final String explanation;

  const MathQuestionV15({
    required this.skillId,
    required this.prompt,
    required this.answer,
    required this.options,
    required this.explanation,
  });
}

class MathPracticeEngineV15 {
  static const _progressKey = 'math_skill_progress_v15';
  static const _starsKey = 'child_stars_v15';
  static const _xpKey = 'child_xp_v15';
  static final Random _random = Random();

  static String ar(int n) => n.toString().split('').map(
    (d) => '٠١٢٣٤٥٦٧٨٩'[int.parse(d)],
  ).join();

  static List<int> _options(int answer, {int spread = 4}) {
    final values = <int>{answer};
    while (values.length < 4) {
      final delta = _random.nextInt(spread * 2 + 1) - spread;
      values.add(max(0, answer + delta));
    }
    final result = values.toList()..shuffle(_random);
    return result;
  }

  static MathQuestionV15 addition({
    required String skillId,
    required int max,
  }) {
    var a = _random.nextInt(max + 1);
    var b = _random.nextInt(max + 1);
    while (a + b > max) {
      a = _random.nextInt(max + 1);
      b = _random.nextInt(max + 1);
    }
    final answer = a + b;
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(a)} + ${ar(b)} = ؟',
      answer: answer,
      options: _options(answer),
      explanation: '${ar(a)} + ${ar(b)} = ${ar(answer)}',
    );
  }

  static MathQuestionV15 subtraction({
    required String skillId,
    required int max,
  }) {
    final a = _random.nextInt(max + 1);
    final b = _random.nextInt(a + 1);
    final answer = a - b;
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(a)} − ${ar(b)} = ؟',
      answer: answer,
      options: _options(answer),
      explanation: '${ar(a)} − ${ar(b)} = ${ar(answer)}',
    );
  }

  static MathQuestionV15 comparison({
    required String skillId,
    required int max,
  }) {
    final a = _random.nextInt(max + 1);
    final b = _random.nextInt(max + 1);
    final answer = a > b ? 1 : (a < b ? -1 : 0);
    const options = [1, 0, -1];
    final labels = {
      1: 'أكبر',
      0: 'يساوي',
      -1: 'أصغر',
    };
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(a)}  ؟  ${ar(b)}',
      answer: answer,
      options: options,
      explanation: '${ar(a)} ${answer == 1 ? 'أكبر من' : answer == -1 ? 'أصغر من' : 'يساوي'} ${ar(b)}',
    );
  }

  static MathQuestionV15 missingNumber({
    required String skillId,
    required int max,
  }) {
    final a = _random.nextInt(max + 1);
    final b = _random.nextInt(min(20, max) + 1);
    final answer = a + b;
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(a)} + ؟ = ${ar(answer)}',
      answer: b,
      options: _options(b, spread: 3),
      explanation: '${ar(a)} + ${ar(b)} = ${ar(answer)}',
    );
  }

  static MathQuestionV15 placeValue({
    required String skillId,
    required int max,
  }) {
    final value = max >= 1000
        ? (_random.nextInt(900) + 100)
        : (_random.nextInt(max - 10) + 10);
    final digits = value.toString().split('');
    final placeIndex = _random.nextInt(digits.length);
    final digit = int.parse(digits[placeIndex]);
    final place = digits.length - placeIndex - 1;
    final answer = digit * pow(10, place).toInt();
    final placeName = switch (place) {
      0 => 'الآحاد',
      1 => 'العشرات',
      2 => 'المئات',
      3 => 'الآلاف',
      _ => 'القيمة المكانية',
    };
    return MathQuestionV15(
      skillId: skillId,
      prompt: 'ما قيمة الرقم ${ar(digit)} في العدد ${ar(value)}؟',
      answer: answer,
      options: _options(answer, spread: max(10, answer ~/ 2 + 1)),
      explanation: 'الرقم ${ar(digit)} في منزلة $placeName، وقيمته ${ar(answer)}',
    );
  }

  static MathQuestionV15 pattern({
    required String skillId,
    required int max,
  }) {
    final step = _random.nextInt(9) + 1;
    final start = _random.nextInt(max ~/ 2 + 1);
    final answer = start + step * 3;
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(start)} ، ${ar(start + step)} ، ${ar(start + step * 2)} ، ؟',
      answer: answer,
      options: _options(answer, spread: step + 2),
      explanation: 'النمط يزيد بمقدار ${ar(step)} كل مرة.',
    );
  }

  static MathQuestionV15 multiplication({
    required String skillId,
    required int table,
  }) {
    final b = _random.nextInt(10) + 1;
    final answer = table * b;
    return MathQuestionV15(
      skillId: skillId,
      prompt: '${ar(table)} × ${ar(b)} = ؟',
      answer: answer,
      options: _options(answer, spread: 4),
      explanation: '${ar(table)} × ${ar(b)} = ${ar(answer)}',
    );
  }

  static Future<void> recordAnswer({
    required String skillId,
    required bool correct,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('$_progressKey.$skillId') ?? 0;
    final next = (current + (correct ? 10 : -5)).clamp(0, 100);
    await prefs.setInt('$_progressKey.$skillId', next);
    if (correct) {
      await addRewards(stars: 1, xp: 5);
    }
  }

  static Future<int> mastery(String skillId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_progressKey.$skillId') ?? 0;
  }

  static Future<void> addRewards({required int stars, required int xp}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_starsKey, (prefs.getInt(_starsKey) ?? 0) + stars);
    await prefs.setInt(_xpKey, (prefs.getInt(_xpKey) ?? 0) + xp);
    // Also feed the shared reward pool so stars/XP earned here show up in
    // the shop and the parent dashboard, not just in this engine's own count.
    await ProgressV8.addRewards(stars: stars, xp: xp);
  }

  static Future<int> stars() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_starsKey) ?? 0;
  }

  static Future<int> xp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }
}
