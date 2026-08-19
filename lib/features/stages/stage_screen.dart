import 'package:flutter/material.dart';
import '../../widgets/app_feedback.dart';
import '../arabic/arabic_curriculum_screen_v16.dart';
import '../arabic/arabic_grammar_screen_v12.dart';
import '../english/english_home_screen.dart';
import '../math/math_curriculum_screen_v15.dart';
import '../math/multiplication_screen_v13.dart';
import '../writing/writing_screen.dart';
import '../children/kindergarten_stage_screen_v4.dart';
import '../games/games_screen_v11.dart';

class StageScreen extends StatelessWidget {
  final String stageId;
  const StageScreen({super.key, required this.stageId});

  @override
  Widget build(BuildContext context) {
    if (stageId == 'kg1' || stageId == 'kg2') {
      return KindergartenStageScreenV4(stageId: stageId);
    }
    if (stageId == 'prep') {
      return const KindergartenTestsScreen();
    }

    final grade = stageId == 'g2' ? 2 : stageId == 'g3' ? 3 : 1;
    final title = stageId == 'g2' ? 'الصف الثاني' : stageId == 'g3' ? 'الصف الثالث' : 'الصف الأول';
    final cards = <Widget>[
      _StageButton(
        title: 'العربية',
        subtitle: 'منهج العربية المناسب للمرحلة',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF7652FF),
        page: ArabicCurriculumScreenV16(grade: grade),
        message: '📚 خطوة جديدة في القراءة!',
      ),
      if (grade >= 2)
        const _StageButton(
          title: 'قواعد اللغة العربية',
          subtitle: 'القواعد والتراكيب',
          icon: Icons.spellcheck_rounded,
          color: Color(0xFFE94F9B),
          page: ArabicGrammarScreenV12(),
          message: '📝 هيا نكتشف قواعد العربية!',
        ),
      _StageButton(
        title: 'الرياضيات',
        subtitle: 'جمع وطرح وقيمة مكانية ومهارات أخرى',
        icon: Icons.calculate_rounded,
        color: const Color(0xFF18A7E8),
        page: MathCurriculumScreenV15(grade: grade),
        message: '🧮 عقل رياضي رائع!',
      ),
      const _StageButton(
        title: 'جدول الضرب',
        subtitle: 'حسب المرحلة',
        icon: Icons.close_rounded,
        color: Color(0xFF16B878),
        page: MultiplicationScreenV13(),
        message: '✖️ لنصبح أبطال جدول الضرب!',
      ),
      _StageButton(
        title: 'الإنجليزية',
        subtitle: 'قراءة وكتابة وتعلم تدريجي',
        icon: Icons.language_rounded,
        color: const Color(0xFFFF8A3D),
        page: EnglishHomeScreen(stageId: stageId),
        message: '🇬🇧 Great!',
      ),
      _StageButton(
        title: 'الكتابة',
        subtitle: 'كلمات وجمل وتدريب كتابي',
        icon: Icons.edit_note_rounded,
        color: const Color(0xFF8E5CF6),
        page: WritingScreen(stageId: stageId),
        message: '✍️ اكتب بنفسك!',
      ),
      const _StageButton(
        title: 'الألعاب والقصص',
        subtitle: 'نشاطات وتحديات مرتبطة بالتعلم',
        icon: Icons.sports_esports_rounded,
        color: Color(0xFFFFB300),
        page: GamesScreenV11(),
        message: '🏆 تحدٍ جديد!',
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            App3DCard(
              onTap: () => AppFeedback.show('🌟 $title — أنت تستطيع!'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.tertiaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 18),
            ...cards,
          ],
        ),
      ),
    );
  }
}

class _StageButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;
  final String message;

  const _StageButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: App3DCard(
        onTap: () {
          AppFeedback.show(message);
          Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
        },
        encouragement: message,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.68)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class KindergartenTestsScreen extends StatelessWidget {
  const KindergartenTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('اختبارات الروضة')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            App3DCard(
              onTap: () => AppFeedback.show('🏆 هيا نراجع ما تعلمناه!'),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8), Color(0xFFE94F9B)]),
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: const Text(
                  '🏆 اختبارات الروضة\nمراجعة ممتعة للروضة الأولى والثانية',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _TestButton('اختبار الحروف ودمج حرفين', 'الحروف العربية + دمج حرفين', Icons.abc_rounded, [Color(0xFF8E5CF6), Color(0xFFE94F9B)], _PrepLetterTest()),
            const _TestButton('اختبار الأرقام', '١ إلى ٥٠ + الآحاد والعشرات', Icons.pin_rounded, [Color(0xFF18A7E8), Color(0xFF16B878)], _PrepNumberTest()),
            const _TestButton('اختبار الأشكال', 'تمييز الأشكال', Icons.category_rounded, [Color(0xFFFF8A3D), Color(0xFFE94F9B)], _PrepShapeTest()),
            const _TestButton('اختبار الألوان', 'التعرف على اللون واسمه', Icons.palette_rounded, [Color(0xFFFFC107), Color(0xFFFF8A3D)], _PrepColorTest()),
          ],
        ),
      ),
    );
  }
}

class _TestButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Widget page;

  const _TestButton(this.title, this.subtitle, this.icon, this.colors, this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: App3DCard(
        onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page)),
        encouragement: '✨ هيا نبدأ!',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text('$title\n$subtitle', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ]),
        ),
      ),
    );
  }
}

class _PrepLetterTest extends StatefulWidget {
  const _PrepLetterTest();
  @override State<_PrepLetterTest> createState() => _PrepLetterTestState();
}

class _PrepLetterTestState extends State<_PrepLetterTest> {
  int i = 0;
  final qs = const [
    ('اختر الحرف: ب', ['أ', 'ب', 'ت'], 'ب'),
    ('اختر الحرف: م', ['ن', 'م', 'ل'], 'م'),
    ('ما نتيجة د + و؟', ['دو', 'دا', 'دي'], 'دو'),
    ('ما نتيجة ن + ا؟', ['نا', 'نو', 'ني'], 'نا'),
    ('ما نتيجة ب + ا؟', ['با', 'بو', 'بي'], 'با'),
  ];

  @override
  Widget build(BuildContext context) {
    final q = qs[i % qs.length];
    return _QuestionPage('اختبار الحروف', q.$1, q.$2, q.$3, () => setState(() => i++));
  }
}

class _PrepNumberTest extends StatefulWidget {
  const _PrepNumberTest();
  @override State<_PrepNumberTest> createState() => _PrepNumberTestState();
}

class _PrepNumberTestState extends State<_PrepNumberTest> {
  int i = 1;

  @override
  Widget build(BuildContext context) {
    final tens = i ~/ 10;
    final ones = i % 10;
    final choices = i < 10 ? ['$i', '${i == 9 ? 1 : i + 1}', '${i == 1 ? 3 : i - 1}'] : ['الآحاد: $ones', 'العشرات: $tens', 'العدد كاملًا'];
    final correct = i < 10 ? '$i' : (ones > 0 ? 'الآحاد: $ones' : 'العشرات: $tens');
    return _QuestionPage('اختبار الأرقام', i < 10 ? 'اختر الرقم $i' : 'في العدد $i اختر قيمة الآحاد أو العشرات', choices, correct, () => setState(() => i = i == 50 ? 1 : i + 1));
  }
}

class _PrepShapeTest extends StatefulWidget {
  const _PrepShapeTest();
  @override State<_PrepShapeTest> createState() => _PrepShapeTestState();
}

class _PrepShapeTestState extends State<_PrepShapeTest> {
  int i = 0;
  final qs = const [
    ('أين المربع؟', ['مربع', 'دائرة', 'مثلث'], 'مربع'),
    ('أين المثلث؟', ['مستطيل', 'مثلث', 'دائرة'], 'مثلث'),
    ('أين الدائرة؟', ['دائرة', 'مربع', 'منحرف'], 'دائرة'),
    ('أين المستطيل؟', ['مثلث', 'مستطيل', 'مربع'], 'مستطيل'),
    ('أين المنحرف؟', ['شبه منحرف', 'منحرف', 'دائرة'], 'منحرف'),
    ('أين شبه المنحرف؟', ['مثلث', 'مربع', 'شبه منحرف'], 'شبه منحرف'),
    ('أين الخماسي؟', ['سداسي', 'خماسي', 'دائرة'], 'خماسي'),
    ('أين السداسي؟', ['سداسي', 'مثلث', 'مستطيل'], 'سداسي'),
  ];

  @override
  Widget build(BuildContext context) {
    final q = qs[i % qs.length];
    return _QuestionPage('اختبار الأشكال', q.$1, q.$2, q.$3, () => setState(() => i++));
  }
}

class _PrepColorTest extends StatefulWidget {
  const _PrepColorTest();
  @override State<_PrepColorTest> createState() => _PrepColorTestState();
}

class _PrepColorTestState extends State<_PrepColorTest> {
  int i = 0;
  final qs = const [
    ('اختر اللون الأحمر', ['أحمر', 'أزرق', 'أخضر'], 'أحمر'),
    ('اختر اللون الأخضر', ['أصفر', 'أخضر', 'بنفسجي'], 'أخضر'),
    ('اختر اللون الأزرق', ['أزرق', 'وردي', 'برتقالي'], 'أزرق'),
    ('اختر اللون الأبيض', ['أسود', 'أبيض', 'بني'], 'أبيض'),
    ('اختر اللون البنفسجي', ['بنفسجي', 'تركوازي', 'رمادي'], 'بنفسجي'),
  ];

  @override
  Widget build(BuildContext context) {
    final q = qs[i % qs.length];
    return _QuestionPage('اختبار الألوان', q.$1, q.$2, q.$3, () => setState(() => i++));
  }
}

class _QuestionPage extends StatelessWidget {
  final String title;
  final String question;
  final List<String> choices;
  final String correct;
  final VoidCallback onNext;

  const _QuestionPage(this.title, this.question, this.choices, this.correct, this.onNext);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            App3DCard(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8)]),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Text(question, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 18),
            for (final choice in choices)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: App3DCard(
                  onTap: () {
                    if (choice == correct) {
                      AppFeedback.show('🎉 أحسنت! إجابة صحيحة');
                      onNext();
                    } else {
                      AppFeedback.show('💛 حاول مرة أخرى!');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF16B878), Color(0xFF18A7E8)]),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(child: Text(choice, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
