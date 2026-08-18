import 'package:flutter/material.dart';
import '../arabic/arabic_curriculum_screen_v16.dart';
import '../arabic/arabic_grammar_screen_v12.dart';
import '../english/english_home_screen.dart';
import '../math/math_curriculum_screen_v15.dart';
import '../math/multiplication_screen_v13.dart';
import '../letters/letters_screen.dart';
import '../numbers/numbers_screen_v6.dart';
import '../writing/writing_screen.dart';
import '../children/early_basics_screen.dart';
import '../games/games_screen_v11.dart';
import '../stories/stories_screen.dart';

class StageScreen extends StatelessWidget {
  final String stageId;
  const StageScreen({super.key, required this.stageId});
  static const data = {
    'kg1': ('الروضة الأولى','٣–٤ سنوات','🎨'), 'kg2': ('الروضة الثانية','٤–٥ سنوات','🔤'), 'prep': ('التمهيدي','٥–٦ سنوات','📚'),
    'g1': ('الصف الأول','٦–٧ سنوات','🌟'), 'g2': ('الصف الثاني','٧–٨ سنوات','🚀'), 'g3': ('الصف الثالث','٨–٩ سنوات','🏆'),
  };
  void open(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));
  @override Widget build(BuildContext context) {
    final d = data[stageId]!;
    final grade = stageId == 'g1' ? 1 : stageId == 'g2' ? 2 : stageId == 'g3' ? 3 : 1;
    final cards = <Widget>[];
    void add(String title, String subtitle, String emoji, Widget page) => cards.add(_ActivityCard(title: title, subtitle: subtitle, emoji: emoji, onTap: () => open(context, page)));
    if (stageId == 'kg1') {
      add('الألوان والأشكال','تعلم الألوان والأشكال والاستماع', '🎨', const EarlyBasicsScreen(stageId: 'kg1'));
      add('الأعداد والأرقام','العد والتمييز بين الأعداد', '🔢', const NumbersScreenV6());
      add('الحروف العربية','استماع وتمييز الحروف', '🔤', const LettersScreen());
      add('الكتابة والرسم','تدريب اليد على الكتابة والرسم', '✏️', WritingScreen(stageId: stageId));
      add('الألعاب','مطابقة واستماع وتحديات بسيطة', '🎮', const GamesScreenV11());
    } else if (stageId == 'kg2') {
      add('الألوان والأشكال','مراجعة الألوان والأشكال مع النطق', '🎨', const EarlyBasicsScreen(stageId: 'kg2'));
      add('الحروف العربية','صوت الحرف واسم الحرف والكلمة', '🔤', const LettersScreen());
      add('الأرقام','العد والأنشطة العددية', '🔢', const NumbersScreenV6());
      add('الكتابة','تتبع الحروف والرسم على الشاشة', '✏️', WritingScreen(stageId: stageId));
      add('الألعاب','مطابقة الحروف والكلمات', '🎮', const GamesScreenV11());
      add('القصص','قصص قصيرة مناسبة للعمر', '📖', const StoriesScreen());
    } else if (stageId == 'prep') {
      add('العربية','الحركات والتهجي والقراءة المبكرة', '📚', const ArabicCurriculumScreenV16(grade: 1));
      add('الرياضيات','الأعداد والجمع والطرح والمقارنة', '🧮', const MathCurriculumScreenV15(grade: 1));
      add('الإنجليزية','الحروف الصغيرة والأرقام والأصوات', '🔤', EnglishHomeScreen(stageId: stageId));
      add('الكتابة','الحروف والأرقام على الشاشة', '✏️', WritingScreen(stageId: stageId));
      add('الألعاب والقصص','تعلم باللعب والاستماع', '🎮', const GamesScreenV11());
    } else {
      add('العربية','منهج العربية المناسب للمرحلة', '📚', ArabicCurriculumScreenV16(grade: grade));
      if (grade >= 2) add('قواعد اللغة العربية','مفرد ومثنى والجمع والـ التعريف وحروف الجر وغيرها', '📝', const ArabicGrammarScreenV12());
      add('الرياضيات','جمع وطرح وترتيب وقيمة مكانية ومهارات أخرى', '🧮', MathCurriculumScreenV15(grade: grade));
      if (grade >= 1) add('جدول الضرب','حسب المرحلة: ١–٢ ثم ١–٥ ثم ١–١٠', '✖️', const MultiplicationScreenV13());
      add('الإنجليزية','قراءة وكتابة وتعلم تدريجي مناسب للعمر', '🇬🇧', EnglishHomeScreen(stageId: stageId));
      add('الكتابة','في الصفين الثاني والثالث نكتب كلمات وجملاً', '✍️', WritingScreen(stageId: stageId));
      add('الألعاب والقصص','نشاطات وتحديات مرتبطة بالتعلم', '🎮', const GamesScreenV11());
    }
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(d.$1)), body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.tertiaryContainer]), borderRadius: BorderRadius.circular(24)), child: Row(children: [Text(d.$3, style: const TextStyle(fontSize: 45)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d.$1, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), Text(d.$2), const SizedBox(height: 6), const Text('اختر النشاط الذي تريد أن تتعلمه اليوم.')] ))])),
      const SizedBox(height: 16), const Text('مواد المرحلة', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(height: 10), ...cards,
    ])));
  }
}
class _ActivityCard extends StatelessWidget { final String title,subtitle,emoji; final VoidCallback onTap; const _ActivityCard({required this.title,required this.subtitle,required this.emoji,required this.onTap}); @override Widget build(BuildContext context)=>Card(child: InkWell(onTap:onTap,borderRadius:BorderRadius.circular(22),child:ListTile(contentPadding:const EdgeInsets.all(15),leading:CircleAvatar(radius:27,child:Text(emoji,style:const TextStyle(fontSize:25))),title:Text(title,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w900)),subtitle:Text(subtitle),trailing:const Icon(Icons.arrow_back_ios_new_rounded)))); }
