import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../data/content.dart';
import '../../widgets/app_feedback.dart';

class KindergartenStageScreen extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreen({super.key, required this.stageId});

  bool get kg1 => stageId == 'kg1';

  @override
  Widget build(BuildContext context) {
    final title = kg1 ? 'الروضة الأولى' : 'الروضة الثانية';
    final colors = kg1
        ? [const Color(0xFFFF8A65), const Color(0xFFFFD54F)]
        : [const Color(0xFF42A5F5), const Color(0xFFAB47BC)];
    final items = kg1
        ? <_MenuItem>[
            _MenuItem('الحروف', '٢٨ حرفًا عربيًا • الصوت والاسم والكلمة', Icons.abc_rounded, const Color(0xFF8E5CF6)),
            _MenuItem('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded, const Color(0xFF18A7E8)),
            _MenuItem('الكتابة', 'الحروف والأرقام والكتابة الحرة', Icons.draw_rounded, const Color(0xFF16B878)),
            _MenuItem('الألوان', 'ألوان وأسماء وحيوانات بنفس اللون', Icons.palette_rounded, const Color(0xFFFF8A3D)),
            _MenuItem('الأشكال', 'أشكال أساسية مع النطق والألوان', Icons.category_rounded, const Color(0xFFE94F9B)),
            _MenuItem('الألعاب', 'لعبة للحروف ولعبة للأرقام', Icons.sports_esports_rounded, const Color(0xFFFFC107)),
          ]
        : <_MenuItem>[
            _MenuItem('الحروف', 'أولي ووسطي وآخري مع النطق', Icons.abc_rounded, const Color(0xFF8E5CF6)),
            _MenuItem('الأرقام', '١–٥٠ ومراتب الأعداد', Icons.pin_rounded, const Color(0xFF18A7E8)),
            _MenuItem('الكتابة', 'حروف وأشكال ودمج وقيمة مكانية', Icons.draw_rounded, const Color(0xFF16B878)),
            _MenuItem('الألوان', 'ألوان جذابة وأنشطة بصرية', Icons.palette_rounded, const Color(0xFFFF8A3D)),
            _MenuItem('الأشكال', 'أساسية ومتقدمة مع النطق', Icons.category_rounded, const Color(0xFFE94F9B)),
            _MenuItem('القصص والألعاب', 'قصتان وأربع ألعاب تعليمية', Icons.auto_stories_rounded, const Color(0xFFFFC107)),
          ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            _Hero(title: title, subtitle: kg1 ? 'تعلم باللعب واللون والصوت والحركة' : 'نتعلم الحرف والعدد والكتابة خطوة بخطوة', colors: colors),
            const SizedBox(height: 18),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _3DMenuButton(item: item, onTap: () => _open(context, item.title)),
            )),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    Widget page;
    if (title == 'الحروف') {
      page = KindergartenLettersScreen(advanced: !kg1);
    } else if (title == 'الأرقام') {
      page = KindergartenNumbersScreen(advanced: !kg1);
    } else if (title == 'الكتابة') {
      page = KindergartenWritingScreen(advanced: !kg1);
    } else if (title == 'الألوان') {
      page = const KindergartenColorsScreen();
    } else if (title == 'الأشكال') {
      page = KindergartenShapesScreen(advanced: !kg1);
    } else {
      page = KindergartenFunScreen(advanced: !kg1);
    }
    AppFeedback.show('✨ ${title == 'القصص والألعاب' ? 'وقت اللعب والقصة' : title} ممتع!');
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _MenuItem {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _MenuItem(this.title, this.subtitle, this.icon, this.color);
}

class _3DMenuButton extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;
  const _3DMenuButton({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: onTap,
        encouragement: '🌟 أحسنت! ${item.title}',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [item.color, item.color.withValues(alpha: .72)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: item.color.withValues(alpha: .25), blurRadius: 14, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .22), borderRadius: BorderRadius.circular(18)), child: Icon(item.icon, color: Colors.white, size: 34)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(item.subtitle, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))])),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ]),
        ),
      );
}

class _Hero extends StatelessWidget {
  final String title, subtitle;
  final List<Color> colors;
  const _Hero({required this.title, required this.subtitle, required this.colors});
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: () => AppFeedback.show('💎 ${title} — أنت بطل التعلم!'),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(26)),
          child: Row(children: [
            const Text('🌟', style: TextStyle(fontSize: 48)), const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4))])),
          ]),
        ),
      );
}

class KindergartenLettersScreen extends StatefulWidget {
  final bool advanced;
  const KindergartenLettersScreen({super.key, required this.advanced});
  @override State<KindergartenLettersScreen> createState() => _KindergartenLettersScreenState();
}

class _KindergartenLettersScreenState extends State<KindergartenLettersScreen> {
  int index = 0;
  static const names = <String, String>{'أ':'ألف','ب':'باء','ت':'تاء','ث':'ثاء','ج':'جيم','ح':'حاء','خ':'خاء','د':'دال','ذ':'ذال','ر':'راء','ز':'زاي','س':'سين','ش':'شين','ص':'صاد','ض':'ضاد','ط':'طاء','ظ':'ظاء','ع':'عين','غ':'غين','ف':'فاء','ق':'قاف','ك':'كاف','ل':'لام','م':'ميم','ن':'نون','ه':'هاء','و':'واو','ي':'ياء'};
  static const forms = <String, List<String>>{
    'أ':['أ','ـأ','أ'], 'ب':['بـ','ـبـ','ـب'], 'ت':['تـ','ـتـ','ـت'], 'ث':['ثـ','ـثـ','ـث'], 'ج':['جـ','ـجـ','ـج'], 'ح':['حـ','ـحـ','ـح'], 'خ':['خـ','ـخـ','ـخ'],
    'د':['د','ـد','د'], 'ذ':['ذ','ـذ','ذ'], 'ر':['ر','ـر','ر'], 'ز':['ز','ـز','ز'], 'س':['سـ','ـسـ','ـس'], 'ش':['شـ','ـشـ','ـش'], 'ص':['صـ','ـصـ','ـص'], 'ض':['ضـ','ـضـ','ـض'],
    'ط':['طـ','ـطـ','ـط'], 'ظ':['ظـ','ـظـ','ـظ'], 'ع':['عـ','ـعـ','ـع'], 'غ':['غـ','ـغـ','ـغ'], 'ف':['فـ','ـفـ','ـف'], 'ق':['قـ','ـقـ','ـق'], 'ك':['كـ','ـكـ','ـك'], 'ل':['لـ','ـلـ','ـل'], 'م':['مـ','ـمـ','ـم'], 'ن':['نـ','ـنـ','ـن'], 'ه':['هـ','ـهـ','ـه'], 'و':['و','ـو','و'], 'ي':['يـ','ـيـ','ـي'],
  };

  @override
  Widget build(BuildContext context) {
    final l = arabicLetters[index];
    final f = forms[l.letter] ?? [l.letter, l.letter, l.letter];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: const Text('الحروف العربية')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('الحرف ${arNum(index + 1)} من ${arNum(arabicLetters.length)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        const SizedBox(height: 10), LinearProgressIndicator(value: (index + 1) / arabicLetters.length, minHeight: 9), const SizedBox(height: 14),
        App3DCard(onTap: () => VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound), encouragement: '🔊 استمع لصوت الحرف', child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF5C6BC0)]), borderRadius: BorderRadius.circular(24)), child: Column(children: [Text(l.letter, style: const TextStyle(fontSize: 110, color: Colors.white, fontWeight: FontWeight.w900)), Text('صوت الحرف: ${l.sound}', style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)), Text('اسم الحرف: ${names[l.letter]}', style: const TextStyle(fontSize: 19, color: Colors.white))]))),
        const SizedBox(height: 12),
        if (widget.advanced) Row(children: [for (var i = 0; i < 3; i++) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: _smallCard('${['أولي','وسطي','آخري'][i]}\n${f[i]}', const Color(0xFF18A7E8), () => VoiceService.arabicLetterSound(l.letter, fallbackText: l.sound))))]),
        const SizedBox(height: 12),
        App3DCard(onTap: () => VoiceService.arabic(l.word), encouragement: '🗣️ كرر الكلمة بصوتك', child: ListTile(contentPadding: const EdgeInsets.all(14), leading: Text(l.emoji, style: const TextStyle(fontSize: 38)), title: Text(l.word, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)), subtitle: const Text('كلمة تبدأ بهذا الحرف • اضغط لسماعها'), trailing: const Icon(Icons.volume_up_rounded))),
        const SizedBox(height: 18),
        Row(children: [Expanded(child: _nav('السابق', index > 0 ? () => setState(() => index--) : null, const Color(0xFFE94F9B))), const SizedBox(width: 10), Expanded(child: _nav('التالي', index < arabicLetters.length - 1 ? () => setState(() => index++) : null, const Color(0xFF16B878)))]),
      ]),
    ));
  }
}

class KindergartenNumbersScreen extends StatefulWidget {
  final bool advanced;
  const KindergartenNumbersScreen({super.key, required this.advanced});
  @override State<KindergartenNumbersScreen> createState() => _KindergartenNumbersScreenState();
}

class _KindergartenNumbersScreenState extends State<KindergartenNumbersScreen> {
  int tab = 0;
  int number = 1;
  static const names = ['','واحد','اثنان','ثلاثة','أربعة','خمسة','ستة','سبعة','ثمانية','تسعة','عشرة','أحد عشر','اثنا عشر','ثلاثة عشر','أربعة عشر','خمسة عشر','ستة عشر','سبعة عشر','ثمانية عشر','تسعة عشر','عشرون','واحد وعشرون','اثنان وعشرون','ثلاثة وعشرون','أربعة وعشرون','خمسة وعشرون','ستة وعشرون','سبعة وعشرون','ثمانية وعشرون','تسعة وعشرون','ثلاثون','واحد وثلاثون','اثنان وثلاثون','ثلاثة وثلاثون','أربعة وثلاثون','خمسة وثلاثون','ستة وثلاثون','سبعة وثلاثون','ثمانية وثلاثون','تسعة وثلاثون','أربعون','واحد وأربعون','اثنان وأربعون','ثلاثة وأربعون','أربعة وأربعون','خمسة وأربعون','ستة وأربعون','سبعة وأربعون','ثمانية وأربعون','تسعة وأربعون','خمسون'];
  @override
  Widget build(BuildContext context) {
    final max = widget.advanced ? 50 : 10;
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الأرقام')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (widget.advanced) Row(children: [Expanded(child: _tab('الأعداد ١–٥٠', tab == 0, () => setState(() => tab = 0), const Color(0xFF18A7E8))), const SizedBox(width: 8), Expanded(child: _tab('مراتب الأعداد', tab == 1, () => setState(() => tab = 1), const Color(0xFF8E5CF6)))]),
        const SizedBox(height: 14),
        if (widget.advanced && tab == 1) _placeValueLesson() else GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: max, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.15), itemBuilder: (_, i) => _numberCard(i + 1)),
      ]),
    ));
  }

  Widget _numberCard(int n) => App3DCard(onTap: () { setState(() => number = n); VoiceService.arabic(names[n]); }, encouragement: '🔊 ${names[n]}', child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF18A7E8), const Color(0xFF42A5F5).withValues(alpha: .72)]), borderRadius: BorderRadius.circular(20)), child: Center(child: Text(arNum(n), style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w900)))));

  Widget _placeValueLesson() {
    final n = number.clamp(10, 50);
    final tens = n ~/ 10, ones = n % 10;
    return Column(children: [
      Text('القيمة المكانية', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), const SizedBox(height: 8),
      const Text('هذا درس تعليمي: نرى قيمة كل رقم ولا يوجد اختبار.', textAlign: TextAlign.center), const SizedBox(height: 16),
      App3DCard(onTap: () => VoiceService.arabic(names[n]), encouragement: '💎 تعلمت أن لكل رقم قيمة!', child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFFE94F9B)]), borderRadius: BorderRadius.circular(24)), child: Column(children: [Text(arNum(n), style: const TextStyle(fontSize: 74, color: Colors.white, fontWeight: FontWeight.w900)), Text(names[n], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 14),
      Row(children: [Expanded(child: _smallCard('العشرات\n${arNum(tens)}', const Color(0xFF8E5CF6), () => AppFeedback.show('💜 ${arNum(tens * 10)} = عشرات'))), Expanded(child: _smallCard('الآحاد\n${arNum(ones)}', const Color(0xFF16B878), () => AppFeedback.show('💚 ${arNum(ones)} = آحاد')))]),
      const SizedBox(height: 14),
      Row(children: [Expanded(child: _nav('العدد السابق', n > 10 ? () => setState(() => number--) : null, const Color(0xFFFF8A3D))), const SizedBox(width: 8), Expanded(child: _nav('العدد التالي', n < 50 ? () => setState(() => number++) : null, const Color(0xFF18A7E8)))])
    ]);
  }
}

class KindergartenWritingScreen extends StatefulWidget {
  final bool advanced;
  const KindergartenWritingScreen({super.key, required this.advanced});
  @override State<KindergartenWritingScreen> createState() => _KindergartenWritingScreenState();
}

class _KindergartenWritingScreenState extends State<KindergartenWritingScreen> {
  int tab = 0;
  int index = 0;
  Color pen = const Color(0xFF8E5CF6);
  final points = <Offset>[];
  static const numberNames = ['', 'واحد','اثنان','ثلاثة','أربعة','خمسة','ستة','سبعة','ثمانية','تسعة','عشرة'];
  static const mixes = ['د + و','ن + ا','د + ي','ب + ا','م + ا','ل + ا','س + م','ك + ت','ب + ي','ر + ي','و + ر','ج + م','ح + ب','ق + ل','ع + ي','ف + ي','ن + و','ش + م','ز + ر','ط + ي'];
  String get target => tab == 0 ? arabicLetters[index].letter : arNum(index + 1);
  String get label => tab == 0 ? (widget.advanced && index % 3 == 1 ? 'اكتب الشكل الوسطي' : widget.advanced && index % 3 == 2 ? 'اكتب الشكل الآخري' : 'اكتب الحرف') : 'اكتب الرقم';

  @override
  Widget build(BuildContext context) {
    final max = tab == 0 ? arabicLetters.length : 10;
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الكتابة على الشاشة'), actions: [IconButton(onPressed: () => setState(points.clear), icon: const Icon(Icons.delete_outline_rounded))]), body: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 4), child: Row(children: [Expanded(child: _tab('الحروف', tab == 0, () => _switchTab(0), const Color(0xFF8E5CF6))), const SizedBox(width: 8), Expanded(child: _tab('الأرقام', tab == 1, () => _switchTab(1), const Color(0xFF18A7E8)))])),
      const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), const SizedBox(height: 4),
      Text(target, style: const TextStyle(fontSize: 78, fontWeight: FontWeight.w900)),
      if (widget.advanced && tab == 0) Text('النموذج ${arNum((index % 3) + 1)} من ٣', style: const TextStyle(fontSize: 15)),
      if (widget.advanced && tab == 0) Padding(padding: const EdgeInsets.all(8), child: _smallCard('دمج حرفين: ${mixes[index % mixes.length]}', const Color(0xFFE94F9B), () => VoiceService.arabic(mixes[index % mixes.length].replaceAll(' + ', '')))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: Row(children: [const Text('لون القلم: '), ...[const Color(0xFF8E5CF6), const Color(0xFF18A7E8), const Color(0xFF16B878), const Color(0xFFFF4F81), const Color(0xFFFF8A3D)].map((c) => GestureDetector(onTap: () => setState(() => pen = c), child: Container(width: 30, height: 30, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: pen == c ? Colors.black : Colors.transparent, width: 3)))))]),
      ),
      Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(14, 6, 14, 8), child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: pen.withValues(alpha: .45), width: 3), boxShadow: [BoxShadow(color: pen.withValues(alpha: .15), blurRadius: 14, offset: const Offset(0, 6))]), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: GestureDetector(onPanStart: (d) => setState(() => points.add(d.localPosition)), onPanUpdate: (d) => setState(() => points.add(d.localPosition)), child: CustomPaint(painter: _PenPainter(points, pen), child: const SizedBox.expand()))))),
      Padding(padding: const EdgeInsets.fromLTRB(14, 2, 14, 14), child: Row(children: [Expanded(child: _nav('السابق', index > 0 ? () => setState(() { index--; points.clear(); }) : null, const Color(0xFFE94F9B))), const SizedBox(width: 8), Expanded(child: _nav('التالي', index < max - 1 ? () => setState(() { index++; points.clear(); }) : null, const Color(0xFF16B878)))])),
    ])));
  }
  void _switchTab(int value) => setState(() { tab = value; index = 0; points.clear(); });
}

class _PenPainter extends CustomPainter {
  final List<Offset> points; final Color color;
  _PenPainter(this.points, this.color);
  @override void paint(Canvas canvas, Size size) { final p = Paint()..color = color..strokeWidth = 12..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round; for (var i = 1; i < points.length; i++) { canvas.drawLine(points[i - 1], points[i], p); } }
  @override bool shouldRepaint(covariant _PenPainter oldDelegate) => oldDelegate.points != points || oldDelegate.color != color;
}

class KindergartenColorsScreen extends StatelessWidget {
  const KindergartenColorsScreen({super.key});
  static const colors = <_ColorItem>[
    _ColorItem('أحمر', Color(0xFFF44336), '🐞'), _ColorItem('أزرق', Color(0xFF2196F3), '🐳'), _ColorItem('أصفر', Color(0xFFFFC107), '🐥'), _ColorItem('أخضر', Color(0xFF4CAF50), '🐸'), _ColorItem('برتقالي', Color(0xFFFF8A00), '🦊'), _ColorItem('بنفسجي', Color(0xFF8E5CF6), '🦋'), _ColorItem('وردي', Color(0xFFE91E63), '🐷'), _ColorItem('تركوازي', Color(0xFF00AFA5), '🐢'), _ColorItem('بني', Color(0xFF795548), '🐻'), _ColorItem('رمادي', Color(0xFF78909C), '🐘'), _ColorItem('أبيض', Color(0xFFF5F5F5), '🕊️'), _ColorItem('أسود', Color(0xFF303030), '🐦'), _ColorItem('ذهبي', Color(0xFFFFB300), '🦁'), _ColorItem('فضي', Color(0xFFB0BEC5), '🐟'),
  ];
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الألوان')), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: colors.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.15), itemBuilder: (_, i) { final c = colors[i]; return App3DCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _ColorAnimalScreen(item: c))), encouragement: '🎨 هذا لون ${c.name}', child: Container(decoration: BoxDecoration(color: c.color, borderRadius: BorderRadius.circular(24), border: c.name == 'أبيض' ? Border.all(color: Colors.grey.shade300, width: 2) : null), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(c.emoji, style: const TextStyle(fontSize: 48)), Text(c.name, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: c.name == 'أبيض' ? Colors.black87 : Colors.white)), const SizedBox(height: 4), Text('اضغط وارسم الحيوان', style: TextStyle(color: c.name == 'أبيض' ? Colors.black54 : Colors.white70))]))); }));
}

class _ColorItem { final String name; final Color color; final String emoji; const _ColorItem(this.name, this.color, this.emoji); }

class _ColorAnimalScreen extends StatelessWidget {
  final _ColorItem item; const _ColorAnimalScreen({required this.item});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text('${item.name} • حيوان بنفس اللون')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('ارسم مجسم الحيوان ${item.emoji}', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 20), CustomPaint(size: const Size(240, 220), painter: _AnimalPainter(item.color)), const SizedBox(height: 18), FilledButton.icon(onPressed: () => VoiceService.arabic(item.name), icon: const Icon(Icons.volume_up_rounded), label: Text('استمع إلى ${item.name}'))])));
}

class _AnimalPainter extends CustomPainter {
  final Color color; _AnimalPainter(this.color);
  @override void paint(Canvas canvas, Size s) { final p = Paint()..color = color; final dark = Paint()..color = color.withValues(alpha: .75); final center = Offset(s.width / 2, s.height / 2); canvas.drawOval(Rect.fromCenter(center: center, width: 145, height: 105), p); canvas.drawCircle(Offset(center.dx + 65, center.dy - 38), 43, p); final ears = Path()..moveTo(center.dx + 43, center.dy - 62)..lineTo(center.dx + 54, center.dy - 105)..lineTo(center.dx + 75, center.dy - 65)..close(); canvas.drawPath(ears, p); final ear2 = Path()..moveTo(center.dx + 75, center.dy - 65)..lineTo(center.dx + 92, center.dy - 103)..lineTo(center.dx + 103, center.dy - 50)..close(); canvas.drawPath(ear2, p); for (final x in [-48.0, -10.0, 35.0, 70.0]) canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center.dx + x, center.dy + 42, 14, 58), const Radius.circular(7)), dark); final eye = Paint()..color = Colors.white; canvas.drawCircle(Offset(center.dx + 78, center.dy - 45), 7, eye); canvas.drawCircle(Offset(center.dx + 80, center.dy - 45), 3, Paint()..color = Colors.black); canvas.drawCircle(Offset(center.dx + 98, center.dy - 30), 5, Paint()..color = Colors.black); }
  @override bool shouldRepaint(covariant _AnimalPainter oldDelegate) => oldDelegate.color != color;
}

class KindergartenShapesScreen extends StatelessWidget {
  final bool advanced; const KindergartenShapesScreen({super.key, required this.advanced});
  static const base = ['مربع','مثلث','دائرة','مستطيل','منحرف','شبه منحرف'];
  static const extra = ['خماسي','سداسي','ثماني','معين','ديناري'];
  @override Widget build(BuildContext context) { final all = [...base, if (advanced) ...extra]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('الأشكال')), body: GridView.builder(padding: const EdgeInsets.all(16), itemCount: all.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12), itemBuilder: (_, i) => App3DCard(onTap: () => VoiceService.arabic(all[i]), encouragement: '🔷 ${all[i]}', child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFE94F9B), const Color(0xFF8E5CF6).withValues(alpha: .75)]), borderRadius: BorderRadius.circular(24)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_ShapeIcon(kind: all[i]), const SizedBox(height: 8), Text(all[i], style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)), const Text('🔊 استمع', style: TextStyle(color: Colors.white70))])))); }); }
}

class _ShapeIcon extends StatelessWidget { final String kind; const _ShapeIcon({required this.kind}); @override Widget build(BuildContext context) { final icon = switch (kind) { 'دائرة' => Icons.circle, 'مربع' => Icons.square, 'مثلث' => Icons.change_history, 'مستطيل' => Icons.rectangle, 'معين' => Icons.diamond, 'خماسي' => Icons.pentagon, 'سداسي' => Icons.hexagon, _ => Icons.category_rounded }; return Icon(icon, size: 76, color: Colors.white); } }

class KindergartenFunScreen extends StatelessWidget {
  final bool advanced; const KindergartenFunScreen({super.key, required this.advanced});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(advanced ? 'القصص والألعاب' : 'الألعاب')), body: ListView(padding: const EdgeInsets.all(16), children: [
    if (advanced) ...[
      _funButton(context, 'القصة الأولى', 'الأرنب المجتهد', Icons.menu_book_rounded, const Color(0xFF8E5CF6), const _StoryScreen(title: 'الأرنب المجتهد', text: 'كان أرنب صغير يحب التعلم. كل يوم يتعلم حرفًا وكلمة جديدة. عندما أخطأ لم يحزن، بل حاول مرة أخرى حتى نجح.', emoji: '🐰')),
      _funButton(context, 'القصة الثانية', 'رحلة الحروف', Icons.auto_stories_rounded, const Color(0xFF18A7E8), const _StoryScreen(title: 'رحلة الحروف', text: 'اجتمعت الحروف في مدينة جميلة، وقرر كل حرف أن يصنع كلمة مفيدة. تعلم الأطفال أن الحروف عندما تجتمع تصنع كلمات وقصصًا.', emoji: '🌈')),
      const SizedBox(height: 8),
    ],
    _funButton(context, 'لعبة الحروف', 'اختر الحرف المطلوب', Icons.abc_rounded, const Color(0xFFE94F9B), const _LetterGame()),
    if (advanced) _funButton(context, 'لعبة دمج الحروف', 'د + و وأمثلة أخرى', Icons.extension_rounded, const Color(0xFFFF8A3D), const _MergeGame()),
    _funButton(context, 'لعبة الأرقام', 'اختر الرقم الصحيح', Icons.pin_rounded, const Color(0xFF16B878), const _NumberGame()),
    if (advanced) _funButton(context, 'لعبة العشرات', 'تعلم العشرات بطريقة ممتعة', Icons.view_week_rounded, const Color(0xFF8E5CF6), const _TensGame()),
  ]));
  Widget _funButton(BuildContext c, String title, String sub, IconData icon, Color color, Widget page) => Padding(padding: const EdgeInsets.only(bottom: 12), child: App3DCard(onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)), encouragement: '🎉 هيا نبدأ!', child: Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: .72)]), borderRadius: BorderRadius.circular(24)), child: Row(children: [Icon(icon, size: 45, color: Colors.white), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), Text(sub, style: const TextStyle(color: Colors.white70))])), const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)])));
}

class _StoryScreen extends StatelessWidget { final String title, text, emoji; const _StoryScreen({required this.title, required this.text, required this.emoji}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Padding(padding: const EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(emoji, style: const TextStyle(fontSize: 78)), const SizedBox(height: 18), Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 18), Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, height: 1.8)), const SizedBox(height: 24), FilledButton.icon(onPressed: () => VoiceService.arabic(text), icon: const Icon(Icons.volume_up_rounded), label: const Text('استمع إلى القصة'))])))); }

class _LetterGame extends StatefulWidget { const _LetterGame(); @override State<_LetterGame> createState() => _LetterGameState(); }
class _LetterGameState extends State<_LetterGame> { int q = 0; final options = ['أ','ب','ت','ث']; final answers = ['أ','ب','ت','ث']; @override Widget build(BuildContext context) { final answer = answers[q % answers.length]; final choices = [...options]..shuffle(); return _GameFrame(title: 'لعبة الحروف', question: 'أين حرف $answer ؟', children: choices.map((x) => _gameChoice(context, x, x == answer, () => _next(x == answer))).toList()); } void _next(bool ok) { if (ok) { AppFeedback.show('🌟 أحسنت! إجابة صحيحة'); setState(() => q++); } else { AppFeedback.show('💛 حاول مرة أخرى'); } } Widget _gameChoice(BuildContext c, String x, bool correct, VoidCallback onTap) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _nav(x, onTap, const Color(0xFFE94F9B))); }

class _MergeGame extends StatefulWidget { const _MergeGame(); @override State<_MergeGame> createState() => _MergeGameState(); }
class _MergeGameState extends State<_MergeGame> { int i = 0; final pairs = ['د + و','ن + ا','د + ي','ب + ا','م + ا','ل + ا']; @override Widget build(BuildContext context) => _GameFrame(title: 'لعبة دمج الحروف', question: 'ادمج: ${pairs[i % pairs.length]}', children: [Text('اضغط على الكلمة الناتجة الصحيحة', style: const TextStyle(fontSize: 18)), const SizedBox(height: 12), _nav('دو', () => _ok('دو'), const Color(0xFFFF8A3D)), _nav('با', () => _ok('با'), const Color(0xFF16B878)), _nav('نا', () => _ok('نا'), const Color(0xFF18A7E8))]); void _ok(String x) { final expected = switch (pairs[i % pairs.length]) { 'د + و' => 'دو', 'ن + ا' => 'نا', 'د + ي' => 'دي', 'ب + ا' => 'با', 'م + ا' => 'ما', _ => 'لا' }; if (x == expected) { AppFeedback.show('💎 ممتاز! دمج رائع'); setState(() => i++); } else { AppFeedback.show('🌱 جرب مرة أخرى'); } } }

class _NumberGame extends StatefulWidget { const _NumberGame(); @override State<_NumberGame> createState() => _NumberGameState(); }
class _NumberGameState extends State<_NumberGame> { int q = 1; @override Widget build(BuildContext context) { final correct = q; final choices = {correct, correct + 1, correct == 1 ? 3 : correct - 1}.toList()..shuffle(); return _GameFrame(title: 'لعبة الأرقام', question: 'اختر الرقم ${arNum(correct)}', children: choices.map((n) => _nav(arNum(n), () { if (n == correct) { AppFeedback.show('🎉 رائع! إجابة صحيحة'); setState(() => q = q == 10 ? 1 : q + 1); } else { AppFeedback.show('💛 ليس هذا، حاول مرة أخرى'); } }, const Color(0xFF16B878))).toList()); } }

class _TensGame extends StatefulWidget { const _TensGame(); @override State<_TensGame> createState() => _TensGameState(); }
class _TensGameState extends State<_TensGame> { int n = 10; @override Widget build(BuildContext context) => _GameFrame(title: 'لعبة العشرات', question: 'العدد ${arNum(n)} فيه كم عشرة؟', children: [for (final x in [1, n ~/ 10, 3]) _nav(arNum(x), () { if (x == n ~/ 10) { AppFeedback.show('🌟 أحسنت! ${arNum(x)} عشرات'); setState(() => n = n == 50 ? 10 : n + 10); } else { AppFeedback.show('💛 فكر في قيمة العدد'); } }, const Color(0xFF8E5CF6))]); }

class _GameFrame extends StatelessWidget { final String title, question; final List<Widget> children; const _GameFrame({required this.title, required this.question, required this.children}); @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(18), children: [App3DCard(onTap: () {}, child: Container(padding: const EdgeInsets.all(20), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8)]), borderRadius: BorderRadius.all(Radius.circular(24))), child: Text(question, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900))), const SizedBox(height: 20), ...children]))); }

Widget _smallCard(String text, Color color, VoidCallback onTap) => App3DCard(onTap: onTap, encouragement: '✨ ${text.split('\n').first}', child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))));
Widget _nav(String text, VoidCallback? onTap, Color color) => App3DCard(onTap: onTap ?? () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: onTap == null ? Colors.grey : color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))));
Widget _tab(String text, bool selected, VoidCallback onTap, Color color) => App3DCard(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: selected ? color : color.withValues(alpha: .18), borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, style: TextStyle(color: selected ? Colors.white : color, fontWeight: FontWeight.w900, fontSize: 17))));
