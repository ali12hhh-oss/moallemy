import 'package:flutter/material.dart';
import '../../widgets/app_feedback.dart';
import '../arabic/arabic_curriculum_screen_v16.dart';
import '../arabic/arabic_grammar_screen_v12.dart';
import '../english/english_home_screen.dart';
import '../math/math_curriculum_screen_v15.dart';
import '../math/multiplication_screen_v13.dart';
import '../writing/writing_screen.dart';
import '../children/kindergarten_stage_screen.dart';
import '../games/games_screen_v11.dart';

class StageScreen extends StatelessWidget {
  final String stageId;
  const StageScreen({super.key, required this.stageId});

  static const Map<String, (String, String, String)> data = {
    'kg1': ('الروضة الأولى', '٣–٤ سنوات', '🎨'),
    'kg2': ('الروضة الثانية', '٤–٥ سنوات', '🔤'),
    'prep': ('التمهيدي', '٥–٦ سنوات', '📚'),
    'g1': ('الصف الأول', '٦–٧ سنوات', '🌟'),
    'g2': ('الصف الثاني', '٧–٨ سنوات', '🚀'),
    'g3': ('الصف الثالث', '٨–٩ سنوات', '🏆'),
  };

  void open(BuildContext context, Widget page, String message) {
    AppFeedback.show(message);
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final d = data[stageId]!;
    final grade = switch (stageId) {
      'g1' => 1,
      'g2' => 2,
      'g3' => 3,
      _ => 1,
    };

    if (stageId == 'kg1' || stageId == 'kg2') {
      return KindergartenStageScreen(stageId: stageId);
    }

    final cards = <Widget>[];
    void add(String title, String subtitle, IconData icon, Widget page, String message) {
      cards.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: App3DCard(
          encouragement: message,
          onTap: () => open(context, page, message),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            leading: _iconBox(context, icon),
            title: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      ));
    }

    if (stageId == 'prep') {
      add('العربية', 'الحركات والتهجي والقراءة المبكرة', Icons.menu_book_rounded, const ArabicCurriculumScreenV16(grade: 1), '📚 هيا نتهجى ونقرأ!');
      add('الرياضيات', 'الأعداد والجمع والطرح والمقارنة', Icons.calculate_rounded, const MathCurriculumScreenV15(grade: 1), '🧮 لنحل مسائل ذكية!');
      add('الإنجليزية', 'حروف وأرقام وأصوات مع شرح عربي', Icons.language_rounded, EnglishHomeScreen(stageId: stageId), '🔤 Let’s learn English!');
      add('الكتابة', 'الحروف والأرقام على الشاشة', Icons.draw_rounded, WritingScreen(stageId: stageId), '✏️ اكتب بنفسك على الشاشة!');
      add('الألعاب والقصص', 'تعلم باللعب والاستماع', Icons.sports_esports_rounded, const GamesScreenV11(), '🎮 اللعب يجعل التعلم أجمل!');
    } else {
      add('العربية', 'منهج العربية المناسب للمرحلة', Icons.menu_book_rounded, ArabicCurriculumScreenV16(grade: grade), '📚 خطوة جديدة في القراءة!');
      if (grade >= 2) {
        add('قواعد اللغة العربية', 'مفرد ومثنى والجمع والـ التعريف وحروف الجر وغيرها', Icons.spellcheck_rounded, const ArabicGrammarScreenV12(), '📝 هيا نكتشف قواعد العربية!');
      }
      add('الرياضيات', 'جمع وطرح وترتيب وقيمة مكانية ومهارات أخرى', Icons.calculate_rounded, MathCurriculumScreenV15(grade: grade), '🧮 عقل رياضي رائع!');
      add('جدول الضرب', 'حسب المرحلة: الأول ١–٢، الثاني ١–٥، الثالث ١–١٠', Icons.close_rounded, const MultiplicationScreenV13(), '✖️ لنصبح أبطال جدول الضرب!');
      add('الإنجليزية', 'قراءة وكتابة وتعلم تدريجي مناسب للعمر', Icons.language_rounded, EnglishHomeScreen(stageId: stageId), '🇬🇧 Great! لنقرأ الإنجليزية بشكل صحيح!');
      add('الكتابة', 'في الصفين الثاني والثالث نكتب كلمات وجملاً', Icons.edit_note_rounded, WritingScreen(stageId: stageId), '✍️ الآن اكتب كلماتك بنفسك!');
      add('الألعاب والقصص', 'نشاطات وتحديات مرتبطة بالتعلم', Icons.sports_esports_rounded, const GamesScreenV11(), '🏆 تحدٍ جديد بانتظارك!');
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(d.$1)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            App3DCard(
              onTap: () => AppFeedback.show('🌟 ${d.$1} — أنت تستطيع!'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.tertiaryContainer]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(children: [
                  Text(d.$3, style: const TextStyle(fontSize: 45)), const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.$1, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                    Text(d.$2), const SizedBox(height: 6), const Text('اختر النشاط الذي تريد أن تتعلمه اليوم.'),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 20),
            const Text('مواد المرحلة', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...cards,
          ],
        ),
      ),
    );
  }

  Widget _iconBox(BuildContext context, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [scheme.primaryContainer, scheme.secondaryContainer]), borderRadius: BorderRadius.circular(17)),
      child: Icon(icon, color: scheme.primary, size: 30),
    );
  }
}
