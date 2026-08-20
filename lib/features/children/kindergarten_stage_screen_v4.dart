import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../data/content.dart';
import '../../widgets/app_feedback.dart';

class KindergartenStageScreenV4 extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreenV4({super.key, required this.stageId});
  bool get kg2 => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final items = kg2
        ? const <_KgItem>[
            _KgItem('الحروف', 'أولي ووسطي وآخري + نطق', Icons.abc_rounded, Color(0xFF7652FF)),
            _KgItem('الأرقام', '١ إلى ٥٠ + الآحاد والعشرات', Icons.pin_rounded, Color(0xFF18A7E8)),
            _KgItem('الكتابة', 'حروف وأرقام + كلمات من حرفين', Icons.draw_rounded, Color(0xFF16B878)),
            _KgItem('الألوان', 'تعلّم اللون ثم لوّن الرسوم', Icons.palette_rounded, Color(0xFFFF8A3D)),
            _KgItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل وخماسي وسداسي', Icons.category_rounded, Color(0xFFE94F9B)),
            _KgItem('القصص والألعاب', 'قصص وألعاب تعليمية فعلية', Icons.auto_stories_rounded, Color(0xFFFFB300)),
          ]
        : const <_KgItem>[
            _KgItem('الحروف', '٢٨ حرفًا عربيًا + صوت واسم وكلمة', Icons.abc_rounded, Color(0xFF7652FF)),
            _KgItem('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded, Color(0xFF18A7E8)),
            _KgItem('الكتابة', 'حروف وأرقام مع لوحة كتابة واضحة', Icons.draw_rounded, Color(0xFF16B878)),
            _KgItem('الألوان', 'ألوان ورسوم قابلة للتلوين', Icons.palette_rounded, Color(0xFFFF8A3D)),
            _KgItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل', Icons.category_rounded, Color(0xFFE94F9B)),
            _KgItem('الألعاب', 'ألعاب حروف وأرقام فعلية', Icons.sports_esports_rounded, Color(0xFFFFB300)),
          ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MenuCard(title: kg2 ? 'الروضة الثانية' : 'الروضة الأولى', subtitle: 'تعلم بالصوت واللون والكتابة واللعب', icon: Icons.star_rounded, color: const Color(0xFF7652FF), onTap: () => AppFeedback.show('🌟 هيا نتعلم!')),
            const SizedBox(height: 16),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MenuCard(title: item.title, subtitle: item.subtitle, icon: item.icon, color: item.color, onTap: () => _open(context, item.title)),
              ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    final Widget page;
    switch (title) {
      case 'الحروف': page = _LettersPage(kg2: kg2); break;
      case 'الأرقام': page = _NumbersPage(kg2: kg2); break;
      case 'الكتابة': page = _WritingPage(kg2: kg2); break;
      case 'الألوان': page = const _ColorsPage(); break;
      case 'الأشكال': page = _ShapesPage(kg2: kg2); break;
      default: page = _GamesPage(kg2: kg2);
    }
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _KgItem {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _KgItem(this.title, this.subtitle, this.icon, this.color);
}

class _MenuCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MenuCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: onTap,
        encouragement: '✨ $title',
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.68)]), borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 42),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
              Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ])),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ]),
        ),
      );
}

class _Page extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Page(this.title, this.children);
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(16), children: children)),
      );
}

class _Btn extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool selected;
  const _Btn(this.text, this.color, this.onTap, {this.selected = false});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: selected ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        child: App3DCard(
          onTap: onTap,
          encouragement: '✨ $text',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(color: selected ? color.withValues(alpha: 0.9) : color, borderRadius: BorderRadius.circular(18), border: selected ? Border.all(color: Colors.white, width: 3) : null),
            child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))),
          ),
        ),
      );
}

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override State<_LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<_LettersPage> {
  int index = 0;
  int form = 0;
  static const forms = <String, List<String>>{
    'ا': ['ا', 'ـا', 'ـا'], 'ب': ['بـ', 'ـبـ', 'ـب'], 'ت': ['تـ', 'ـتـ', 'ـت'], 'ث': ['ثـ', 'ـثـ', 'ـث'],
    'ج': ['جـ', 'ـجـ', 'ـج'], 'ح': ['حـ', 'ـحـ', 'ـح'], 'خ': ['خـ', 'ـخـ', 'ـخ'], 'د': ['د', 'ـد', 'ـد'],
    'ذ': ['ذ', 'ـذ', 'ـذ'], 'ر': ['ر', 'ـر', 'ـر'], 'ز': ['ز', 'ـز', 'ـز'], 'س': ['سـ', 'ـسـ', 'ـس'],
    'ش': ['شـ', 'ـشـ', 'ـش'], 'ص': ['صـ', 'ـصـ', 'ـص'], 'ض': ['ضـ', 'ـضـ', 'ـض'], 'ط': ['طـ', 'ـطـ', 'ـط'],
    'ظ': ['ظـ', 'ـظـ', 'ـظ'], 'ع': ['عـ', 'ـعـ', 'ـع'], 'غ': ['غـ', 'ـغـ', 'ـغ'], 'ف': ['فـ', 'ـفـ', 'ـف'],
    'ق': ['قـ', 'ـقـ', 'ـق'], 'ك': ['كـ', 'ـكـ', 'ـك'], 'ل': ['لـ', 'ـلـ', 'ـل'], 'م': ['مـ', 'ـمـ', 'ـم'],
    'ن': ['نـ', 'ـنـ', 'ـن'], 'ه': ['هـ', 'ـهـ', 'ـه'], 'و': ['و', 'ـو', 'ـو'], 'ي': ['يـ', 'ـيـ', 'ـي'],
  };
  @override
  Widget build(BuildContext context) {
    final x = arabicLetters[index];
    final f = forms[x.letter] ?? [x.letter, x.letter, x.letter];
    final labels = ['أولي', 'وسطي', 'آخري'];
    return _Page('الحروف العربية', [
      Text('${arNum(index + 1)} من ${arNum(28)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      App3DCard(
        onTap: () => VoiceService.arabicLetterSound(x.letter, fallbackText: x.sound),
        encouragement: '🔊 صوت الحرف',
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF7652FF), Color(0xFF536DFE)]), borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Column(children: [
            Text(widget.kg2 ? f[form] : x.letter, style: const TextStyle(color: Colors.white, fontSize: 105, fontWeight: FontWeight.w900)),
            Text('صوت القراءة: ${x.sound}', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('اسم الحرف: ${x.letter}', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
      if (widget.kg2) ...[
        const SizedBox(height: 12),
        Row(children: [
          for (var j = 0; j < 3; j++)
            Expanded(child: Padding(padding: EdgeInsets.only(left: j == 0 ? 0 : 5), child: _Btn(labels[j] + (form == j ? ' ✓' : ''), const Color(0xFF7652FF), () => setState(() => form = j), selected: form == j))),
        ]),
        const SizedBox(height: 8),
        Text('اختر شكل الحرف ثم اسمع النطق واكتبه على السبورة.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
      ],
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() { index--; form = 0; }) : () => AppFeedback.show('💛 أنت في البداية'))),
        const SizedBox(width: 7),
        Expanded(child: _Btn('🔊 نطق', const Color(0xFF18A7E8), () => VoiceService.arabicLetterSound(x.letter, fallbackText: x.sound))),
        const SizedBox(width: 7),
        Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < 27 ? () => setState(() { index++; form = 0; }) : () => AppFeedback.show('🏆 أكملت الحروف!'))),
      ]),
    ]);
  }
}

class _NumbersPage extends StatefulWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});
  @override State<_NumbersPage> createState() => _NumbersPageState();
}
class _NumbersPageState extends State<_NumbersPage> {
  bool places = false;
  @override
  Widget build(BuildContext context) {
    if (widget.kg2 && places) return const _PlaceValuePage();
    final max = widget.kg2 ? 50 : 10;
    return _Page('الأرقام', [
      if (widget.kg2) Row(children: [
        Expanded(child: _Btn('الأعداد ١–٥٠', const Color(0xFF18A7E8), () => setState(() => places = false), selected: !places)),
        const SizedBox(width: 8),
        Expanded(child: _Btn('الآحاد والعشرات', const Color(0xFF7652FF), () => setState(() => places = true), selected: places)),
      ]),
      if (widget.kg2) const SizedBox(height: 14),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: max, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => App3DCard(onTap: () => VoiceService.arabic(_numberName(i + 1)), encouragement: '🔊 ${arNum(i + 1)}', child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF18A7E8), Color(0xFF42A5F5)]), borderRadius: BorderRadius.all(Radius.circular(20))), child: Center(child: Text(arNum(i + 1), style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900))))),
    ]);
  }
}
class _PlaceValuePage extends StatefulWidget { const _PlaceValuePage(); @override State<_PlaceValuePage> createState() => _PlaceValuePageState(); }
class _PlaceValuePageState extends State<_PlaceValuePage> {
  int number = 24, selected = 0;
  @override Widget build(BuildContext context) {
    final tens = number ~/ 10, ones = number % 10;
    return _Page('الآحاد والعشرات', [
      const Text('نميز رقم الآحاد عن رقم العشرات بصريًا وتعليميًا.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10), Text(arNum(number), textAlign: TextAlign.center, style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900)),
      const SizedBox(height: 6), Row(children: [
        Expanded(child: _ValueCard('العشرات', tens, const Color(0xFF7652FF), selected == 1, () => setState(() => selected = 1))),
        const SizedBox(width: 10), Expanded(child: _ValueCard('الآحاد', ones, const Color(0xFF16B878), selected == 2, () => setState(() => selected = 2))),
      ]),
      const SizedBox(height: 10), Text(selected == 1 ? 'العشرات: ${arNum(tens)} عشرات = ${arNum(tens * 10)}' : selected == 2 ? 'الآحاد: ${arNum(ones)} آحاد' : 'اضغط على الآحاد أو العشرات للتوضيح', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      Slider(min: 10, max: 50, divisions: 40, value: number.toDouble(), label: arNum(number), onChanged: (v) => setState(() { number = v.round(); selected = 0; })),
    ]);
  }
}
class _ValueCard extends StatelessWidget {
  final String title; final int value; final Color color; final bool selected; final VoidCallback onTap;
  const _ValueCard(this.title, this.value, this.color, this.selected, this.onTap);
  @override Widget build(BuildContext context) => App3DCard(onTap: onTap, encouragement: title, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18), border: selected ? Border.all(color: Colors.white, width: 4) : null), child: Column(children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)), Text(arNum(value), style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900))])));
}

class _WritingPage extends StatefulWidget {
  final bool kg2;
  const _WritingPage({required this.kg2});
  @override State<_WritingPage> createState() => _WritingPageState();
}
class _WritingPageState extends State<_WritingPage> {
  int tab = 0, index = 0; bool words = false; Color ink = const Color(0xFF7652FF);
  final words2 = const ['أب','أم','أخ','يد','دم','فم','من','ما','لا','هل','هو','هي','في','لي','لو','يا','رب','كل'];
  @override Widget build(BuildContext context) {
    final letters = tab == 0;
    final max = words ? words2.length : (letters ? 28 : (widget.kg2 ? 50 : 10));
    final guide = words ? words2[index] : letters ? arabicLetters[index].letter : arNum(index + 1);
    return _Page('الكتابة', [
      Row(children: [
        Expanded(child: _Btn('الحروف', const Color(0xFF7652FF), () => setState(() { tab = 0; index = 0; words = false; }), selected: letters && !words)),
        const SizedBox(width: 8), Expanded(child: _Btn('الأرقام', const Color(0xFF18A7E8), () => setState(() { tab = 1; index = 0; words = false; }), selected: !letters && !words)),
      ]),
      if (widget.kg2) ...[const SizedBox(height: 8), _Btn('🔤 كلمات من حرفين', const Color(0xFFFF8A3D), () => setState(() { words = true; index = 0; }), selected: words)],
      const SizedBox(height: 12), Text(words ? 'اكتب الكلمة:' : 'اكتب:', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      Text(guide, textAlign: TextAlign.center, style: const TextStyle(fontSize: 58, fontWeight: FontWeight.w900)),
      const SizedBox(height: 4), _DrawingBoard(color: ink, onColorChanged: (c) => setState(() => ink = c)),
      const SizedBox(height: 8), Row(children: [
        Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() => index--) : () => AppFeedback.show('💛 البداية'))),
        const SizedBox(width: 8), Expanded(child: _Btn('🔊 اسمع', const Color(0xFF7652FF), () => words ? VoiceService.arabic(words2[index]) : letters ? VoiceService.arabicLetterSound(arabicLetters[index].letter, fallbackText: arabicLetters[index].sound) : VoiceService.arabic(_numberName(index + 1)))),
        const SizedBox(width: 8), Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < max - 1 ? () => setState(() => index++) : () => AppFeedback.show('🏆 أحسنت!'))),
      ]),
    ]);
  }
}
class _DrawingBoard extends StatefulWidget {
  final Color color; final ValueChanged<Color> onColorChanged; final bool showUndo;
  const _DrawingBoard({required this.color, required this.onColorChanged, this.showUndo = true});
  @override State<_DrawingBoard> createState() => _DrawingBoardState();
}
class _DrawingBoardState extends State<_DrawingBoard> {
  final List<List<Offset>> strokes = <List<Offset>>[]; List<Offset> current = <Offset>[];
  void clear() => setState(() { strokes.clear(); current = <Offset>[]; });
  void undo() { if (strokes.isNotEmpty) setState(() => strokes.removeLast()); }
  @override Widget build(BuildContext context) {
    const colors = [Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink];
    return Column(children: [
      Container(height: 290, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: widget.color, width: 3)), child: Listener(behavior: HitTestBehavior.opaque, onPointerDown: (e) => setState(() => current = <Offset>[e.localPosition]), onPointerMove: (e) => setState(() => current = <Offset>[...current, e.localPosition]), onPointerUp: (_) { if (current.isNotEmpty) strokes.add(List<Offset>.of(current)); setState(() => current = <Offset>[]); }, onPointerCancel: (_) => setState(() => current = <Offset>[]), child: CustomPaint(painter: _DrawingPainter(widget.color, strokes, current), child: const SizedBox.expand()))),
      const SizedBox(height: 6), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [const Text('لون القلم: ', style: TextStyle(fontWeight: FontWeight.w800)), for (final color in colors) GestureDetector(onTap: () => widget.onColorChanged(color), child: Container(width: 34, height: 34, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.black12))))])),
      const SizedBox(height: 6), Row(children: [if (widget.showUndo) Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), undo)), if (widget.showUndo) const SizedBox(width: 8), Expanded(flex: 2, child: _Btn('🗑 مسح السبورة', const Color(0xFFE53935), clear))]),
    ]);
  }
}
class _DrawingPainter extends CustomPainter {
  final Color color; final List<List<Offset>> strokes; final List<Offset> current;
  _DrawingPainter(this.color, this.strokes, this.current);
  @override void paint(Canvas canvas, Size size) { final paint = Paint()..color = color..strokeWidth = 11..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round; void drawStroke(List<Offset> points) { for (var i = 1; i < points.length; i++) { canvas.drawLine(points[i - 1], points[i], paint); } } for (final stroke in strokes) { drawStroke(stroke); } drawStroke(current); }
  @override bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

class _ColorsPage extends StatefulWidget { const _ColorsPage(); @override State<_ColorsPage> createState() => _ColorsPageState(); }
class _ColorsPageState extends State<_ColorsPage> {
  int index = 0; final palette = const [Color(0xFFF44336), Color(0xFF2196F3), Color(0xFFFFC107), Color(0xFF4CAF50), Color(0xFFFF8A00), Color(0xFF8E5CF6), Color(0xFFE91E63), Color(0xFF00AFA5)]; final names = const ['أحمر','أزرق','أصفر','أخضر','برتقالي','بنفسجي','وردي','تركوازي']; final drawings = const ['قطة','سمكة','أرنب','فراشة','فيل']; Color selected = const Color(0xFFF44336); List<Color> fills = const [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];
  @override Widget build(BuildContext context) => _Page('الألوان والتلوين', [
    Text('اختر اللون: ${names[palette.indexOf(selected) >= 0 ? palette.indexOf(selected) : 0]}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6), Wrap(alignment: WrapAlignment.center, children: [for (var i = 0; i < palette.length; i++) GestureDetector(onTap: () => setState(() => selected = palette[i]), child: Container(width: 42, height: 42, margin: const EdgeInsets.all(5), decoration: BoxDecoration(color: palette[i], shape: BoxShape.circle, border: Border.all(color: selected == palette[i] ? Colors.black : Colors.transparent, width: 4))))]),
    const SizedBox(height: 8), Text('لوّن ${drawings[index]} بالضغط على أجزاء الرسم.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), Container(height: 330, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: selected, width: 3)), child: GestureDetector(onTapUp: (d) => _paintPart(d.localPosition), child: CustomPaint(painter: _ColoringPainter(index, fills), child: const SizedBox.expand()))),
    const SizedBox(height: 8), Row(children: [Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), () => setState(() { fills = List<Color>.from(fills); final p = fills.lastIndexWhere((c) => c != Colors.white); if (p >= 0) fills[p] = Colors.white; }))), const SizedBox(width: 8), Expanded(child: _Btn('🗑 مسح الألوان', const Color(0xFFE53935), () => setState(() => fills = List<Color>.filled(6, Colors.white))))]),
    const SizedBox(height: 8), Row(children: [Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() { index--; fills = List<Color>.filled(6, Colors.white); }) : () => AppFeedback.show('💛 هذا أول رسم'))), const SizedBox(width: 8), Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < drawings.length - 1 ? () => setState(() { index++; fills = List<Color>.filled(6, Colors.white); }) : () => AppFeedback.show('🏆 أكملت الرسومات!')))]),
  ]);
  void _paintPart(Offset p) { final slot = ((p.dx / 55).floor()).clamp(0, 5).toInt(); setState(() { fills = List<Color>.from(fills); fills[slot] = selected; }); }
}
class _ColoringPainter extends CustomPainter {
  final int type; final List<Color> fills; _ColoringPainter(this.type, this.fills);
  @override void paint(Canvas c, Size s) { final outline = Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = Colors.black87; final parts = [Rect.fromLTWH(s.width*.25,s.height*.25,s.width*.5,s.height*.35),Rect.fromCircle(center:Offset(s.width*.28,s.height*.28),radius:48),Rect.fromCircle(center:Offset(s.width*.72,s.height*.28),radius:48),Rect.fromCircle(center:Offset(s.width*.5,s.height*.62),radius:62),Rect.fromLTWH(s.width*.15,s.height*.62,s.width*.2,s.height*.13),Rect.fromLTWH(s.width*.65,s.height*.62,s.width*.2,s.height*.13)]; for(var i=0;i<parts.length;i++){final fill=Paint()..style=PaintingStyle.fill..color=fills[i];c.drawOval(parts[i],fill);c.drawOval(parts[i],outline);} final label=TextPainter(text:TextSpan(text:['قطة','سمكة','أرنب','فراشة','فيل'][type],style:const TextStyle(fontSize:26,color:Colors.black87,fontWeight:FontWeight.bold)),textDirection:TextDirection.rtl)..layout(); label.paint(c,Offset((s.width-label.width)/2,18)); }
  @override bool shouldRepaint(covariant _ColoringPainter oldDelegate)=>true;
}

class _ShapesPage extends StatelessWidget {
  final bool kg2; const _ShapesPage({required this.kg2});
  @override Widget build(BuildContext context) { final names = kg2 ? const ['مربع','مثلث','دائرة','مستطيل','خماسي','سداسي'] : const ['مربع','مثلث','دائرة','مستطيل']; return _Page('الأشكال', [const Text('اضغط على الشكل لتعلّمه ثم افتح صفحة الرسم.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 10), GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: names.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => App3DCard(onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => _ShapeDrawingPage(name: names[i]))), encouragement: '🔷 ${names[i]}', child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFE94F9B), Color(0xFF7652FF)]), borderRadius: BorderRadius.all(Radius.circular(22))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_shapeIcon(names[i]), color: Colors.white, size: 62), Text(names[i], style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900))]))))]); }
}
IconData _shapeIcon(String name) { switch (name) { case 'دائرة': return Icons.circle; case 'مربع': return Icons.square; case 'مثلث': return Icons.change_history; case 'مستطيل': return Icons.rectangle; case 'خماسي': return Icons.pentagon; case 'سداسي': return Icons.hexagon; default: return Icons.category_rounded; } }
class _ShapeDrawingPage extends StatefulWidget { final String name; const _ShapeDrawingPage({required this.name}); @override State<_ShapeDrawingPage> createState()=>_ShapeDrawingPageState(); }
class _ShapeDrawingPageState extends State<_ShapeDrawingPage> { Color ink=const Color(0xFF7652FF); @override Widget build(BuildContext context)=>_Page('رسم ${widget.name}', [Text('هذا هو شكل ${widget.name}. اتبع الخطوط ثم ارسمه بنفسك.',textAlign:TextAlign.center,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800)),const SizedBox(height:8),Container(height:170,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:ink,width:3)),child:CustomPaint(painter:_ShapeGuidePainter(widget.name),child:const SizedBox.expand())),const SizedBox(height:10),_DrawingBoard(color:ink,onColorChanged:(c)=>setState(()=>ink=c))]); }
class _ShapeGuidePainter extends CustomPainter { final String name; _ShapeGuidePainter(this.name); @override void paint(Canvas c,Size s){final p=Paint()..style=PaintingStyle.stroke..strokeWidth=5..color=Colors.grey;final center=Offset(s.width/2,s.height/2);if(name=='دائرة')c.drawCircle(center,55,p);else if(name=='مربع')c.drawRect(Rect.fromCenter(center:center,width:110,height:110),p);else if(name=='مستطيل')c.drawRect(Rect.fromCenter(center:center,width:150,height:90),p);else{final sides=name=='مثلث'?3:name=='خماسي'?5:6;final path=Path();for(var i=0;i<sides;i++){final a=-mathPi/2+i*2*mathPi/sides;final pt=center+Offset(60*Math.cos(a),60*Math.sin(a));if(i==0)path.moveTo(pt.dx,pt.dy);else path.lineTo(pt.dx,pt.dy);}path.close();c.drawPath(path,p);}} @override bool shouldRepaint(covariant _ShapeGuidePainter oldDelegate)=>oldDelegate.name!=name; }
const mathPi=3.141592653589793;

class _GamesPage extends StatelessWidget { final bool kg2; const _GamesPage({required this.kg2}); @override Widget build(BuildContext context)=>_Page(kg2?'القصص والألعاب':'الألعاب',[
  if(kg2)_GameButton(title:'📖 قصة الأرنب المجتهد',color:const Color(0xFF7652FF),child:const _StoryPage(title:'الأرنب المجتهد',pages:['كان أرنب صغير يحب التعلم.','تعلم الحروف ثم الأرقام كل يوم.','فرح لأنه لم يستسلم وأصبح مجتهدًا!'])),
  if(kg2)_GameButton(title:'📖 قصة رحلة الحروف',color:const Color(0xFF18A7E8),child:const _StoryPage(title:'رحلة الحروف',pages:['خرجت الحروف في رحلة جميلة.','التقت كل مجموعة بحرف جديد.','عاد الجميع وهم يعرفون أشكال الحروف!'])),
  _GameButton(title:'🔤 لعبة الحروف',color:const Color(0xFFE94F9B),child:_LetterGame()), if(kg2)_GameButton(title:'🔗 لعبة دمج الحروف',color:const Color(0xFFFF8A3D),child:_MergeGame()), _GameButton(title:'🔢 لعبة الأرقام',color:const Color(0xFF16B878),child:_NumberGame(max:kg2?20:10)), if(kg2)_GameButton(title:'🔟 لعبة العشرات',color:const Color(0xFF7652FF),child:const _PlaceGame()),
]); }
class _GameButton extends StatelessWidget { final String title; final Color color; final Widget child; const _GameButton({required this.title,required this.color,required this.child}); @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:10),child:_Btn(title,color,()=>Navigator.push(context,MaterialPageRoute<void>(builder:(_)=>child)))); }
class _StoryPage extends StatefulWidget { final String title; final List<String> pages; const _StoryPage({required this.title,required this.pages}); @override State<_StoryPage> createState()=>_StoryPageState(); }
class _StoryPageState extends State<_StoryPage> { int i=0; @override Widget build(BuildContext c)=>_Page(widget.title,[Text('📖',textAlign:TextAlign.center,style:const TextStyle(fontSize:90)),Text(widget.pages[i],textAlign:TextAlign.center,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w800)),const SizedBox(height:20),Row(children:[if(i>0)Expanded(child:_Btn('السابق',const Color(0xFFE94F9B),()=>setState(()=>i--))),if(i>0)const SizedBox(width:8),Expanded(child:_Btn(i<widget.pages.length-1?'التالي':'تم',const Color(0xFF16B878),i<widget.pages.length-1?()=>setState(()=>i++):()=>Navigator.pop(c)))])]); }
class _LetterGame extends StatefulWidget { @override State<_LetterGame> createState()=>_LetterGameState(); }
class _LetterGameState extends State<_LetterGame> { int score=0,q=0; final letters=const ['ب','ت','م','س','ن','ل']; @override Widget build(BuildContext c){final target=letters[q%letters.length];final options=[target,letters[(q+1)%letters.length],letters[(q+2)%letters.length]]..shuffle();return _Page('لعبة الحروف',[Text('اختر الحرف الصحيح',textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text('الحرف المطلوب: $target',textAlign:TextAlign.center,style:const TextStyle(fontSize:50,fontWeight:FontWeight.w900)),Text('النتيجة: ${arNum(score)} ⭐',textAlign:TextAlign.center),...options.map((x)=>Padding(padding:const EdgeInsets.only(bottom:10),child:_Btn(x,const Color(0xFF7652FF),()=>setState((){if(x==target)score++;q++;}))))]); } }
class _NumberGame extends StatefulWidget { final int max; const _NumberGame({required this.max}); @override State<_NumberGame> createState()=>_NumberGameState(); }
class _NumberGameState extends State<_NumberGame>{int score=0,q=1;@override Widget build(BuildContext c){final target=((q*3)%widget.max)+1;final options=[target,(target%widget.max)+1,(target+4)%widget.max+1]..shuffle();return _Page('لعبة الأرقام',[Text('اختر الرقم المطلوب',textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text(arNum(target),textAlign:TextAlign.center,style:const TextStyle(fontSize:70,fontWeight:FontWeight.w900)),Text('النتيجة: ${arNum(score)} ⭐',textAlign:TextAlign.center),...options.map((x)=>Padding(padding:const EdgeInsets.only(bottom:10),child:_Btn(arNum(x),const Color(0xFF18A7E8),()=>setState((){if(x==target)score++;q++;}))))]); } }
class _MergeGame extends StatefulWidget { @override State<_MergeGame> createState()=>_MergeGameState(); }
class _MergeGameState extends State<_MergeGame>{int i=0,score=0;final pairs=const [['د','و','دو'],['م','ا','ما'],['ب','ا','با'],['ل','ا','لا']];@override Widget build(BuildContext c){final p=pairs[i%pairs.length];final opts=[p[2],pairs[(i+1)%pairs.length][2],pairs[(i+2)%pairs.length][2]]..shuffle();return _Page('لعبة دمج الحروف',[Text('${p[0]} + ${p[1]} = ؟',textAlign:TextAlign.center,style:const TextStyle(fontSize:45,fontWeight:FontWeight.w900)),Text('النتيجة: ${arNum(score)} ⭐',textAlign:TextAlign.center),...opts.map((x)=>Padding(padding:const EdgeInsets.only(bottom:10),child:_Btn(x,const Color(0xFFFF8A3D),()=>setState((){if(x==p[2])score++;i++;}))))]); } }
class _PlaceGame extends StatefulWidget { const _PlaceGame(); @override State<_PlaceGame> createState()=>_PlaceGameState(); }
class _PlaceGameState extends State<_PlaceGame>{int n=24,score=0;@override Widget build(BuildContext c){final tens=n~/10,ones=n%10;final options=[tens,ones,(tens+2)%5]..shuffle();return _Page('لعبة العشرات',[Text('ما رقم العشرات في ${arNum(n)}؟',textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text('النتيجة: ${arNum(score)} ⭐',textAlign:TextAlign.center),...options.map((x)=>Padding(padding:const EdgeInsets.only(bottom:10),child:_Btn(arNum(x),const Color(0xFF7652FF),()=>setState((){if(x==tens)score++;n=n==49?10:n+1;}))))]); } }
String _numberName(int n) { const names = ['', 'واحد','اثنان','ثلاثة','أربعة','خمسة','ستة','سبعة','ثمانية','تسعة','عشرة']; return n <= 10 ? names[n] : n.toString(); }
