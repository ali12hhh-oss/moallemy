import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../data/content.dart';
import '../../widgets/app_feedback.dart';

class KindergartenStageScreen extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreen({super.key, required this.stageId});
  bool get advanced => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final items = advanced ? const [
      ('الحروف', 'أولي ووسطي وآخري • ٢٨ حرفًا', Icons.abc_rounded, Color(0xFF8E5CF6)),
      ('الأرقام', '١ إلى ٥٠ • مراتب الأعداد', Icons.pin_rounded, Color(0xFF18A7E8)),
      ('الكتابة', 'الحروف والأرقام والدمج والقيمة المكانية', Icons.draw_rounded, Color(0xFF16B878)),
      ('الألوان', 'ألوان جذابة وأنشطة بصرية', Icons.palette_rounded, Color(0xFFFF8A3D)),
      ('الأشكال', 'أساسية ومتقدمة مع النطق', Icons.category_rounded, Color(0xFFE94F9B)),
      ('القصص والألعاب', 'قصتان وأربع ألعاب تعليمية', Icons.auto_stories_rounded, Color(0xFFFFC107)),
    ] : const [
      ('الحروف', '٢٨ حرفًا عربيًا • صوت واسم وكلمة', Icons.abc_rounded, Color(0xFF8E5CF6)),
      ('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded, Color(0xFF18A7E8)),
      ('الكتابة', 'الحروف والأرقام والكتابة الحرة', Icons.draw_rounded, Color(0xFF16B878)),
      ('الألوان', 'جميع الألوان مع حيوان بنفس اللون', Icons.palette_rounded, Color(0xFFFF8A3D)),
      ('الأشكال', 'مربع ومثلث ودائرة ومستطيل وأشكال أخرى', Icons.category_rounded, Color(0xFFE94F9B)),
      ('الألعاب', 'لعبة للحروف ولعبة للأرقام', Icons.sports_esports_rounded, Color(0xFFFFC107)),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(advanced ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _Banner(title: advanced ? 'الروضة الثانية' : 'الروضة الأولى', subtitle: advanced ? 'نتعلم خطوة بخطوة مع النطق والكتابة واللعب' : 'نتعلم باللون والصوت والحركة والمرح'),
          const SizedBox(height: 16),
          ...items.map((x) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _MenuCard(title: x.$1, subtitle: x.$2, icon: x.$3, color: x.$4, onTap: () => _open(context, x.$1)))),
        ]),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    late final Widget page;
    switch (title) {
      case 'الحروف': page = _LettersPage(advanced: advanced); break;
      case 'الأرقام': page = _NumbersPage(advanced: advanced); break;
      case 'الكتابة': page = _WritingPage(advanced: advanced); break;
      case 'الألوان': page = const _ColorsPage(); break;
      case 'الأشكال': page = _ShapesPage(advanced: advanced); break;
      default: page = _FunPage(advanced: advanced);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _Banner extends StatelessWidget {
  final String title, subtitle;
  const _Banner({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => App3DCard(
    onTap: () => AppFeedback.show('💎 ${title} — أنت بطل التعلم!'),
    child: Container(padding: const EdgeInsets.all(22), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8), Color(0xFFE94F9B)]), borderRadius: BorderRadius.all(Radius.circular(26))), child: Row(children: [const Text('🌟', style: TextStyle(fontSize: 48)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4))]))])),
  );
}

class _MenuCard extends StatelessWidget {
  final String title, subtitle; final IconData icon; final Color color; final VoidCallback onTap;
  const _MenuCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => App3DCard(
    onTap: onTap, encouragement: '✨ ${title} ممتع!',
    child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: .72)]), borderRadius: BorderRadius.circular(24)), child: Row(children: [Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .22), borderRadius: BorderRadius.circular(18)), child: Icon(icon, color: Colors.white, size: 34)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))])), const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)])),
  );
}

class _LettersPage extends StatefulWidget {
  final bool advanced; const _LettersPage({required this.advanced});
  @override State<_LettersPage> createState() => _LettersPageState();
}
class _LettersPageState extends State<_LettersPage> {
  int i = 0;
  static const names = <String,String>{'أ':'ألف','ب':'باء','ت':'تاء','ث':'ثاء','ج':'جيم','ح':'حاء','خ':'خاء','د':'دال','ذ':'ذال','ر':'راء','ز':'زاي','س':'سين','ش':'شين','ص':'صاد','ض':'ضاد','ط':'طاء','ظ':'ظاء','ع':'عين','غ':'غين','ف':'فاء','ق':'قاف','ك':'كاف','ل':'لام','م':'ميم','ن':'نون','ه':'هاء','و':'واو','ي':'ياء'};
  static const forms = <String,List<String>>{'أ':['أ','ـأ','أ'],'ب':['بـ','ـبـ','ـب'],'ت':['تـ','ـتـ','ـت'],'ث':['ثـ','ـثـ','ـث'],'ج':['جـ','ـجـ','ـج'],'ح':['حـ','ـحـ','ـح'],'خ':['خـ','ـخـ','ـخ'],'د':['د','ـد','د'],'ذ':['ذ','ـذ','ذ'],'ر':['ر','ـر','ر'],'ز':['ز','ـز','ز'],'س':['سـ','ـسـ','ـس'],'ش':['شـ','ـشـ','ـش'],'ص':['صـ','ـصـ','ـص'],'ض':['ضـ','ـضـ','ـض'],'ط':['طـ','ـطـ','ـط'],'ظ':['ظـ','ـظـ','ـظ'],'ع':['عـ','ـعـ','ـع'],'غ':['غـ','ـغـ','ـغ'],'ف':['فـ','ـفـ','ـف'],'ق':['قـ','ـقـ','ـق'],'ك':['كـ','ـكـ','ـك'],'ل':['لـ','ـلـ','ـل'],'م':['مـ','ـمـ','ـم'],'ن':['نـ','ـنـ','ـن'],'ه':['هـ','ـهـ','ـه'],'و':['و','ـو','و'],'ي':['يـ','ـيـ','ـي']};
  @override
  Widget build(BuildContext context) {
    final l = arabicLetters[i]; final f = forms[l.letter]!;
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الحروف العربية')), body: ListView(padding: const EdgeInsets.all(16), children: [
      Text('الحرف ${arNum(i + 1)} من ${arNum(28)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 8), LinearProgressIndicator(value: (i + 1) / 28, minHeight: 9), const SizedBox(height: 14),
      App3DCard(onTap: () => VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound), encouragement: '🔊 صوت الحرف', child: Container(padding: const EdgeInsets.all(18), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF5C6BC0)]), borderRadius: BorderRadius.all(Radius.circular(24))), child: Column(children: [Text(l.letter, style: const TextStyle(fontSize: 112, color: Colors.white, fontWeight: FontWeight.w900)), Text('صوت الحرف: ${l.sound}', style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)), Text('اسم الحرف: ${names[l.letter]}', style: const TextStyle(color: Colors.white, fontSize: 19))]))),
      const SizedBox(height: 12),
      if (widget.advanced) Row(children: [for (var j = 0; j < 3; j++) Expanded(child: Padding(padding: const EdgeInsets.all(3), child: _ColoredButton(text: ['أولي: ${f[0]}','وسطي: ${f[1]}','آخري: ${f[2]}'][j], color: const Color(0xFF18A7E8), onTap: () => VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound))))]),
      const SizedBox(height: 12),
      App3DCard(onTap: () => VoiceService.arabic(l.word), encouragement: '🗣️ استمع إلى الكلمة', child: ListTile(leading: Text(l.emoji, style: const TextStyle(fontSize: 40)), title: Text(l.word, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), subtitle: const Text('كلمة مرتبطة بالحرف'), trailing: const Icon(Icons.volume_up_rounded))),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: _ColoredButton(text: 'السابق', color: const Color(0xFFE94F9B), onTap: i > 0 ? () => setState(() => i--) : () {})), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'التالي', color: const Color(0xFF16B878), onTap: i < 27 ? () => setState(() => i++) : () {}))]),
    ])));
  }
}

class _NumbersPage extends StatefulWidget { final bool advanced; const _NumbersPage({required this.advanced}); @override State<_NumbersPage> createState() => _NumbersPageState(); }
class _NumbersPageState extends State<_NumbersPage> {
  int tab = 0; int n = 1;
  static const names = ['','واحد','اثنان','ثلاثة','أربعة','خمسة','ستة','سبعة','ثمانية','تسعة','عشرة','أحد عشر','اثنا عشر','ثلاثة عشر','أربعة عشر','خمسة عشر','ستة عشر','سبعة عشر','ثمانية عشر','تسعة عشر','عشرون','واحد وعشرون','اثنان وعشرون','ثلاثة وعشرون','أربعة وعشرون','خمسة وعشرون','ستة وعشرون','سبعة وعشرون','ثمانية وعشرون','تسعة وعشرون','ثلاثون','واحد وثلاثون','اثنان وثلاثون','ثلاثة وثلاثون','أربعة وثلاثون','خمسة وثلاثون','ستة وثلاثون','سبعة وثلاثون','ثمانية وثلاثون','تسعة وثلاثون','أربعون','واحد وأربعون','اثنان وأربعون','ثلاثة وأربعون','أربعة وأربعون','خمسة وأربعون','ستة وأربعون','سبعة وأربعون','ثمانية وأربعون','تسعة وأربعون','خمسون'];
  @override Widget build(BuildContext context) { final max = widget.advanced ? 50 : 10; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الأرقام')), body: ListView(padding: const EdgeInsets.all(16), children: [
    if (widget.advanced) Row(children: [Expanded(child: _ColoredButton(text: 'الأعداد ١–٥٠', color: tab == 0 ? const Color(0xFF18A7E8) : const Color(0xFF9BBFD0), onTap: () => setState(() => tab = 0))), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'مراتب الأعداد', color: tab == 1 ? const Color(0xFF8E5CF6) : const Color(0xFFC5B8E8), onTap: () => setState(() => tab = 1)))]),
    const SizedBox(height: 14),
    if (widget.advanced && tab == 1) _placeValue() else GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: max, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, index) => App3DCard(onTap: () { setState(() => n = index + 1); VoiceService.arabic(names[index + 1]); }, encouragement: '🔊 ${names[index + 1]}', child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF18A7E8), Color(0xFF42A5F5)]), borderRadius: BorderRadius.all(Radius.circular(20))), child: Center(child: Text(arNum(index + 1), style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900))))))
  ]))); }
  Widget _placeValue() { final value = n.clamp(10, 50).toInt(); final tens = value ~/ 10; final ones = value % 10; return Column(children: [Text('العدد ${arNum(value)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)), const SizedBox(height: 8), const Text('درس تعليمي للقيمة المكانية، وليس اختبارًا.'), const SizedBox(height: 16), Row(children: [Expanded(child: _ColoredButton(text: 'العشرات: ${arNum(tens)}', color: const Color(0xFF8E5CF6), onTap: () => AppFeedback.show('💜 ${arNum(tens * 10)} قيمة العشرات'))), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'الآحاد: ${arNum(ones)}', color: const Color(0xFF16B878), onTap: () => AppFeedback.show('💚 ${arNum(ones)} قيمة الآحاد')))]), const SizedBox(height: 14), Row(children: [Expanded(child: _ColoredButton(text: 'السابق', color: const Color(0xFFFF8A3D), onTap: value > 10 ? () => setState(() => n = value - 1) : () {})), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'التالي', color: const Color(0xFF18A7E8), onTap: value < 50 ? () => setState(() => n = value + 1) : () {}))])]); }
}

class _WritingPage extends StatefulWidget { final bool advanced; const _WritingPage({required this.advanced}); @override State<_WritingPage> createState() => _WritingPageState(); }
class _WritingPageState extends State<_WritingPage> {
  int tab = 0, index = 0; Color pen = const Color(0xFF8E5CF6); final points = <Offset>[];
  static const numbers = ['١','٢','٣','٤','٥','٦','٧','٨','٩','١٠'];
  static const merges = ['د + و','ن + ا','د + ي','ب + ا','م + ا','ل + ا','س + م','ك + ت','ب + ي','ر + ي','و + ر','ج + م','ح + ب','ق + ل','ع + ي','ف + ي','ن + و','ش + م','ز + ر','ط + ي'];
  @override Widget build(BuildContext context) { final max = tab == 0 ? 28 : 10; final target = tab == 0 ? arabicLetters[index].letter : numbers[index]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الكتابة على الشاشة'), actions: [IconButton(onPressed: () => setState(points.clear), icon: const Icon(Icons.delete_outline_rounded))]), body: Column(children: [Padding(padding: const EdgeInsets.all(12), child: Row(children: [Expanded(child: _ColoredButton(text: 'الحروف', color: tab == 0 ? const Color(0xFF8E5CF6) : const Color(0xFFD1C4E9), onTap: () => setState(() { tab = 0; index = 0; points.clear(); }))), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'الأرقام', color: tab == 1 ? const Color(0xFF18A7E8) : const Color(0xFFB9DCEB), onTap: () => setState(() { tab = 1; index = 0; points.clear(); })))])), Text(widget.advanced && tab == 0 ? 'اكتب الحرف ثم شاهده بثلاثة أشكال' : tab == 0 ? 'اكتب الحرف العربي' : 'اكتب الرقم العربي', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text(target, style: const TextStyle(fontSize: 78, fontWeight: FontWeight.w900)), if (widget.advanced && tab == 0) Text('دمج: ${merges[index % merges.length]}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 5), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [const Text('لون الكتابة: '), for (final c in [const Color(0xFF8E5CF6), const Color(0xFF18A7E8), const Color(0xFF16B878), const Color(0xFFE94F9B), const Color(0xFFFF8A3D)]) GestureDetector(onTap: () => setState(() => pen = c), child: Container(width: 30, height: 30, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: pen == c ? Colors.black : Colors.transparent, width: 3))))])), Expanded(child: Padding(padding: const EdgeInsets.all(12), child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: pen, width: 3)), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: GestureDetector(onPanStart: (d) => setState(() => points.add(d.localPosition)), onPanUpdate: (d) => setState(() => points.add(d.localPosition)), child: CustomPaint(painter: _PenPainter(points, pen), child: const SizedBox.expand()))))), Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: Row(children: [Expanded(child: _ColoredButton(text: 'السابق', color: const Color(0xFFE94F9B), onTap: index > 0 ? () => setState(() { index--; points.clear(); }) : () {})), const SizedBox(width: 8), Expanded(child: _ColoredButton(text: 'التالي', color: const Color(0xFF16B878), onTap: index < max - 1 ? () => setState(() { index++; points.clear(); }) : () {}))]))])); }
}
class _PenPainter extends CustomPainter { final List<Offset> points; final Color color; _PenPainter(this.points, this.color); @override void paint(Canvas canvas, Size size) { final p = Paint()..color = color..strokeWidth = 12..strokeCap = StrokeCap.round; for (var i = 1; i < points.length; i++) { canvas.drawLine(points[i - 1], points[i], p); } } @override bool shouldRepaint(covariant _PenPainter oldDelegate) => oldDelegate.points != points || oldDelegate.color != color; }

class _ColorsPage extends StatelessWidget {
  const _ColorsPage();
  static const data = [('أحمر', Color(0xFFF44336), '🐞'),('أزرق', Color(0xFF2196F3), '🐳'),('أصفر', Color(0xFFFFC107), '🐥'),('أخضر', Color(0xFF4CAF50), '🐸'),('برتقالي', Color(0xFFFF8A00), '🦊'),('بنفسجي', Color(0xFF8E5CF6), '🦋'),('وردي', Color(0xFFE91E63), '🐷'),('تركوازي', Color(0xFF00AFA5), '🐢'),('بني', Color(0xFF795548), '🐻'),('رمادي', Color(0xFF78909C), '🐘'),('أبيض', Color(0xFFF5F5F5), '🕊️'),('أسود', Color(0xFF303030), '🐦'),('ذهبي', Color(0xFFFFB300), '🦁'),('فضي', Color(0xFFB0BEC5), '🐟')];
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الألوان')), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: data.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) { final x = data[i]; final light = x.$1 == 'أبيض'; return App3DCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ColorAnimalPage(name: x.$1, color: x.$2, emoji: x.$3))), encouragement: '🎨 ${x.$1}', child: Container(decoration: BoxDecoration(color: x.$2, borderRadius: BorderRadius.circular(22), border: light ? Border.all(color: Colors.grey) : null), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(x.$3, style: const TextStyle(fontSize: 48)), Text(x.$1, style: TextStyle(color: light ? Colors.black : Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), Text('حيوان بنفس اللون', style: TextStyle(color: light ? Colors.black54 : Colors.white70))]))); }));
}
class _ColorAnimalPage extends StatelessWidget { final String name, emoji; final Color color; const _ColorAnimalPage({required this.name, required this.color, required this.emoji}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text('$name • حيوان')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('مجسم حيوان بلون $name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 20), Text(emoji, style: TextStyle(fontSize: 120, shadows: [Shadow(color: color, blurRadius: 20)])), const SizedBox(height: 18), FilledButton.icon(onPressed: () => VoiceService.arabic(name), icon: const Icon(Icons.volume_up_rounded), label: Text('استمع إلى $name'))]))); }

class _ShapesPage extends StatelessWidget { final bool advanced; const _ShapesPage({required this.advanced}); @override Widget build(BuildContext context) { final names = ['مربع','مثلث','دائرة','مستطيل','منحرف','شبه منحرف',if (advanced) ...['خماسي','سداسي','ثماني','معين','ديناري']]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الأشكال')), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: names.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => App3DCard(onTap: () => VoiceService.arabic(names[i]), encouragement: '🔷 ${names[i]}', child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFE94F9B), Color(0xFF8E5CF6)]), borderRadius: BorderRadius.all(Radius.circular(22))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_shapeIcon(names[i]), color: Colors.white, size: 68), Text(names[i], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)), const Text('🔊 استمع', style: TextStyle(color: Colors.white70))])))); } }
IconData _shapeIcon(String x) => switch (x) { 'دائرة' => Icons.circle, 'مربع' => Icons.square, 'مثلث' => Icons.change_history, 'مستطيل' => Icons.rectangle, 'معين' => Icons.diamond, 'خماسي' => Icons.pentagon, 'سداسي' => Icons.hexagon, _ => Icons.category_rounded };

class _FunPage extends StatelessWidget { final bool advanced; const _FunPage({required this.advanced}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(advanced ? 'القصص والألعاب' : 'الألعاب')), body: ListView(padding: const EdgeInsets.all(16), children: [if (advanced) ...[_FunButton(title: 'القصة الأولى', sub: 'الأرنب المجتهد', color: const Color(0xFF8E5CF6), page: const _StoryPage(title: 'الأرنب المجتهد', emoji: '🐰', text: 'كان أرنب صغير يحب التعلم. كل يوم يتعلم حرفًا وكلمة جديدة. عندما أخطأ لم يحزن، بل حاول مرة أخرى حتى نجح.')), _FunButton(title: 'القصة الثانية', sub: 'رحلة الحروف', color: const Color(0xFF18A7E8), page: const _StoryPage(title: 'رحلة الحروف', emoji: '🌈', text: 'اجتمعت الحروف في مدينة جميلة، وقرر كل حرف أن يصنع كلمة مفيدة. تعلم الأطفال أن الحروف عندما تجتمع تصنع كلمات وقصصًا.'))], _FunButton(title: 'لعبة الحروف', sub: 'اختيار الحرف الصحيح', color: const Color(0xFFE94F9B), page: const _LetterGame()), if (advanced) _FunButton(title: 'لعبة دمج الحروف', sub: 'دمج حرفين', color: const Color(0xFFFF8A3D), page: const _MergeGame()), _FunButton(title: 'لعبة الأرقام', sub: 'اختيار الرقم الصحيح', color: const Color(0xFF16B878), page: const _NumberGame()), if (advanced) _FunButton(title: 'لعبة العشرات', sub: 'تعلم قيمة العشرات', color: const Color(0xFF8E5CF6), page: const _TensGame())])); }
}
class _FunButton extends StatelessWidget { final String title, sub; final Color color; final Widget page; const _FunButton({required this.title, required this.sub, required this.color, required this.page}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: App3DCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)), encouragement: '🎉 هيا نبدأ!', child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: .72)]), borderRadius: BorderRadius.circular(22)), child: Row(children: [const Icon(Icons.stars_rounded, color: Colors.white, size: 42), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), Text(sub, style: const TextStyle(color: Colors.white70))])), const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)])))); }
class _StoryPage extends StatelessWidget { final String title, emoji, text; const _StoryPage({required this.title, required this.emoji, required this.text}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize: 82)), const SizedBox(height: 16), Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 16), Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, height: 1.8)), const SizedBox(height: 20), FilledButton.icon(onPressed: () => VoiceService.arabic(text), icon: const Icon(Icons.volume_up_rounded), label: const Text('استمع إلى القصة'))])))); }
class _LetterGame extends StatefulWidget { const _LetterGame(); @override State<_LetterGame> createState() => _LetterGameState(); }
class _LetterGameState extends State<_LetterGame> { int i = 0; final letters = ['أ','ب','ت','ث','ج','ح']; @override Widget build(BuildContext context) { final answer = letters[i % letters.length]; final choices = [...letters]..shuffle(); return _Game(title: 'لعبة الحروف', question: 'اختر الحرف ${answer}', choices: choices, correct: answer, onNext: () => setState(() => i++)); } }
class _MergeGame extends StatefulWidget { const _MergeGame(); @override State<_MergeGame> createState() => _MergeGameState(); }
class _MergeGameState extends State<_MergeGame> { int i = 0; final pairs = [('د + و','دو'),('ن + ا','نا'),('د + ي','دي'),('ب + ا','با'),('م + ا','ما'),('ل + ا','لا')]; @override Widget build(BuildContext context) { final p = pairs[i % pairs.length]; return _Game(title: 'دمج الحروف', question: 'ادمج ${p.$1}', choices: ['دو','نا','دي','با','ما','لا'], correct: p.$2, onNext: () => setState(() => i++)); } }
class _NumberGame extends StatefulWidget { const _NumberGame(); @override State<_NumberGame> createState() => _NumberGameState(); }
class _NumberGameState extends State<_NumberGame> { int n = 1; @override Widget build(BuildContext context) { final choices = {n, n == 10 ? 1 : n + 1, n == 1 ? 3 : n - 1}.toList()..shuffle(); return _Game(title: 'لعبة الأرقام', question: 'اختر الرقم ${arNum(n)}', choices: choices.map(arNum).toList(), correct: arNum(n), onNext: () => setState(() => n = n == 10 ? 1 : n + 1)); } }
class _TensGame extends StatefulWidget { const _TensGame(); @override State<_TensGame> createState() => _TensGameState(); }
class _TensGameState extends State<_TensGame> { int n = 10; @override Widget build(BuildContext context) { final correct = arNum(n ~/ 10); return _Game(title: 'لعبة العشرات', question: 'كم عشرة في ${arNum(n)}؟', choices: [correct, arNum(n ~/ 10 + 1), arNum(1)], correct: correct, onNext: () => setState(() => n = n == 50 ? 10 : n + 10)); } }
class _Game extends StatelessWidget { final String title, question, correct; final List<String> choices; final VoidCallback onNext; const _Game({required this.title, required this.question, required this.choices, required this.correct, required this.onNext}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(18), children: [App3DCard(onTap: () {}, child: Container(padding: const EdgeInsets.all(22), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8)]), borderRadius: BorderRadius.all(Radius.circular(24))), child: Text(question, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900))), const SizedBox(height: 18), ...choices.map((x) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _ColoredButton(text: x, color: const Color(0xFF16B878), onTap: () { if (x == correct) { AppFeedback.show('🎉 أحسنت! إجابة صحيحة'); onNext(); } else { AppFeedback.show('💛 حاول مرة أخرى'); } }))) ])); }
}
class _ColoredButton extends StatelessWidget { final String text; final Color color; final VoidCallback onTap; const _ColoredButton({required this.text, required this.color, required this.onTap}); @override Widget build(BuildContext context) => App3DCard(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)))); }
