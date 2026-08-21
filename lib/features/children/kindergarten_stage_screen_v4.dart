import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';

class KindergartenStageScreenV4 extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreenV4({super.key, required this.stageId});
  bool get kg2 => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final items = kg2
        ? const [
            _MenuItem('الحروف', 'أولي ووسطي وآخري + نطق', Icons.abc_rounded),
            _MenuItem('الأرقام', '١ إلى ٥٠ + الآحاد والعشرات', Icons.pin_rounded),
            _MenuItem('الكتابة', 'حروف وأرقام + كلمات من حرفين', Icons.draw_rounded),
            _MenuItem('الألوان', 'تعلّم اللون ثم لوّن الرسوم', Icons.palette_rounded),
            _MenuItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل وخماسي وسداسي', Icons.category_rounded),
            _MenuItem('القصص والألعاب', 'قصص وألعاب تعليمية فعلية', Icons.auto_stories_rounded),
          ]
        : const [
            _MenuItem('الحروف', '٢٨ حرفًا عربيًا + صوت واسم', Icons.abc_rounded),
            _MenuItem('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded),
            _MenuItem('الكتابة', 'حروف وأرقام مع لوحة كتابة', Icons.draw_rounded),
            _MenuItem('الألوان', 'ألوان ورسوم قابلة للتلوين', Icons.palette_rounded),
            _MenuItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل', Icons.category_rounded),
            _MenuItem('الألعاب', 'ألعاب حروف وأرقام فعلية', Icons.sports_esports_rounded),
          ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final item in items) ...[
              _MenuCard(title: item.title, subtitle: item.subtitle, icon: item.icon, onTap: () => _open(context, item.title)),
              const SizedBox(height: 12),
            ],
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

class _MenuItem {
  final String title, subtitle;
  final IconData icon;
  const _MenuItem(this.title, this.subtitle, this.icon);
}

class _MenuCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _MenuCard({required this.title, required this.subtitle, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    elevation: 5,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: const LinearGradient(colors: [Color(0xFF7652FF), Color(0xFF18A7E8)])),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 42), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ])),
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ]),
      ),
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

class _FixedPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _FixedPage(this.title, this.child);
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: Text(title)), body: SafeArea(child: Padding(padding: const EdgeInsets.all(12), child: child))),
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
    duration: const Duration(milliseconds: 160),
    decoration: BoxDecoration(color: selected ? color.withValues(alpha: .72) : color, borderRadius: BorderRadius.circular(15), border: selected ? Border.all(color: Colors.white, width: 3) : null, boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(0, 2))]),
    child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(15), onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)))))) ,
  );
}

String _ar(int n) => n.toString().replaceAllMapped(RegExp(r'\d'), (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m.group(0)!)]);

const _letters = <String>['ا','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','و','ي'];
const _sounds = <String>['أ','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','هـ','و','ي'];
const _forms = <List<String>>[
  ['ا','ـا','ـا'],['بـ','ـبـ','ـب'],['تـ','ـتـ','ـت'],['ثـ','ـثـ','ـث'],['جـ','ـجـ','ـج'],['حـ','ـحـ','ـح'],['خـ','ـخـ','ـخ'],
  ['د','ـد','ـد'],['ذ','ـذ','ـذ'],['ر','ـر','ـر'],['ز','ـز','ـز'],['سـ','ـسـ','ـس'],['شـ','ـشـ','ـش'],['صـ','ـصـ','ـص'],
  ['ضـ','ـضـ','ـض'],['طـ','ـطـ','ـط'],['ظـ','ـظـ','ـظ'],['عـ','ـعـ','ـع'],['غـ','ـغـ','ـغ'],['فـ','ـفـ','ـف'],['قـ','ـقـ','ـق'],
  ['كـ','ـكـ','ـك'],['لـ','ـلـ','ـل'],['مـ','ـمـ','ـم'],['نـ','ـنـ','ـن'],['هـ','ـهـ','ـه'],['و','ـو','ـو'],['يـ','ـيـ','ـي'],
];

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override State<_LettersPage> createState() => _LettersPageState();
}
class _LettersPageState extends State<_LettersPage> {
  int index = 0, form = 0;
  void _speak() => VoiceService.arabic(_sounds[index]);
  @override
  Widget build(BuildContext context) {
    final shown = widget.kg2 ? _forms[index][form] : _letters[index];
    return _Page('الحروف العربية', [
      Text('${_ar(index + 1)} من ٢٨', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Text(shown, style: const TextStyle(fontSize: 105, fontWeight: FontWeight.w900)),
        Text('صوت القراءة: ${_sounds[index]}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        Text('اسم الحرف: ${_letters[index]}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10), _Btn('🔊 نطق الحرف', const Color(0xFF18A7E8), _speak),
      ]))),
      if (widget.kg2) Row(children: [for (var i = 0; i < 3; i++) ...[
        Expanded(child: _Btn(['أولي','وسطي','آخري'][i], const Color(0xFF7652FF), () => setState(() => form = i), selected: form == i)), if (i < 2) const SizedBox(width: 6),
      ]]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() { index--; form = 0; }) : () {})), const SizedBox(width: 7),
        Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < 27 ? () => setState(() { index++; form = 0; }) : () {})),
      ]),
    ]);
  }
}

class _NumbersPage extends StatelessWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _Page('الأرقام', [
    if (kg2) _Btn('الآحاد والعشرات', const Color(0xFF7652FF), () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const _PlaceValuePage()))),
    const SizedBox(height: 12),
    GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: kg2 ? 50 : 10, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) {
      final n = i + 1;
      return _Btn(_ar(n), const Color(0xFF18A7E8), () => VoiceService.arabic(_ar(n)));
    }),
  ]);
}

class _PlaceValuePage extends StatefulWidget {
  const _PlaceValuePage();
  @override State<_PlaceValuePage> createState() => _PlaceValuePageState();
}
class _PlaceValuePageState extends State<_PlaceValuePage> {
  int number = 24, selected = 0;
  @override
  Widget build(BuildContext context) {
    final tens = number ~/ 10, ones = number % 10;
    return _Page('الآحاد والعشرات', [
      const Text('اضغط على الآحاد أو العشرات لتمييز كل منزلة.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      Text(_ar(number), textAlign: TextAlign.center, style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900)),
      Row(children: [Expanded(child: _Btn('العشرات\n${_ar(tens)}', const Color(0xFF7652FF), () => setState(() => selected = 1), selected: selected == 1)), const SizedBox(width: 10), Expanded(child: _Btn('الآحاد\n${_ar(ones)}', const Color(0xFF16B878), () => setState(() => selected = 2), selected: selected == 2))]),
      const SizedBox(height: 10),
      Text(selected == 1 ? 'العشرات = ${_ar(tens)} عشرات = ${_ar(tens * 10)}' : selected == 2 ? 'الآحاد = ${_ar(ones)}' : 'اختر منزلة للتوضيح', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      Slider(value: number.toDouble(), min: 10, max: 50, divisions: 40, label: _ar(number), onChanged: (v) => setState(() => number = v.round())),
    ]);
  }
}

class _WritingPage extends StatefulWidget {
  final bool kg2;
  const _WritingPage({required this.kg2});
  @override State<_WritingPage> createState() => _WritingPageState();
}
class _WritingPageState extends State<_WritingPage> {
  int tab = 0, index = 0;
  bool words = false;
  Color ink = const Color(0xFF7652FF);
  final words2 = const ['أب','أم','أخ','يد','دم','فم','من','ما','لا','هل','هو','هي','في','لي','لو','يا','رب','كل'];
  @override
  Widget build(BuildContext context) {
    final guide = words ? words2[index] : tab == 0 ? _letters[index] : _ar(index + 1);
    final max = words ? words2.length : tab == 0 ? 28 : (widget.kg2 ? 50 : 10);
    return _FixedPage('الكتابة', Column(children: [
      Row(children: [Expanded(child: _Btn('الحروف', const Color(0xFF7652FF), () => setState(() { tab = 0; index = 0; words = false; }), selected: tab == 0 && !words)), const SizedBox(width: 8), Expanded(child: _Btn('الأرقام', const Color(0xFF18A7E8), () => setState(() { tab = 1; index = 0; words = false; }), selected: tab == 1 && !words))]),
      if (widget.kg2) Padding(padding: const EdgeInsets.only(top: 7), child: _Btn('🔤 كلمات من حرفين', const Color(0xFFFF8A3D), () => setState(() { words = true; index = 0; }), selected: words)),
      const SizedBox(height: 5), Text(words ? 'اكتب الكلمة:' : 'اكتب:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      Text(guide, style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900)),
      Expanded(child: _DrawingBoard(color: ink, onColorChanged: (c) => setState(() => ink = c))),
      const SizedBox(height: 7),
      Row(children: [Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() => index--) : () {})), const SizedBox(width: 6), Expanded(child: _Btn('🔊 اسمع', const Color(0xFF7652FF), () => VoiceService.arabic(guide))), const SizedBox(width: 6), Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < max - 1 ? () => setState(() => index++) : () {}))]),
    ]));
  }
}

class _DrawingBoard extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  const _DrawingBoard({required this.color, required this.onColorChanged});
  @override State<_DrawingBoard> createState() => _DrawingBoardState();
}
class _DrawingBoardState extends State<_DrawingBoard> {
  final strokes = <List<Offset>>[];
  List<Offset> current = <Offset>[];
  static const colors = <Color>[Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
  @override
  Widget build(BuildContext context) => Column(children: [
    Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 3)), child: Listener(behavior: HitTestBehavior.opaque, onPointerDown: (e) => setState(() => current = [e.localPosition]), onPointerMove: (e) => setState(() => current = [...current, e.localPosition]), onPointerUp: (_) { if (current.isNotEmpty) strokes.add(List<Offset>.of(current)); setState(() => current = []); }, onPointerCancel: (_) => setState(() => current = []), child: CustomPaint(painter: _DrawingPainter(widget.color, strokes, current), child: const SizedBox.expand())))),
    const SizedBox(height: 4),
    SizedBox(height: 42, child: Row(children: [const Text('لون القلم: ', style: TextStyle(fontWeight: FontWeight.w800)), for (final c in colors) GestureDetector(onTap: () { widget.onColorChanged(c); VoiceService.arabic(_colorName(c)); }, child: Container(width: 30, height: 30, margin: const EdgeInsets.all(3), decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.black26))))])),
    SizedBox(height: 43, child: Row(children: [Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), () => setState(() { if (strokes.isNotEmpty) strokes.removeLast(); }))), const SizedBox(width: 7), Expanded(child: _Btn('🗑 مسح السبورة', const Color(0xFFE53935), () => setState(() { strokes.clear(); current = []; }))) ])),
  ]);
}
String _colorName(Color c) { if (c == Colors.black) return 'أسود'; if (c == Colors.red) return 'أحمر'; if (c == Colors.blue) return 'أزرق'; if (c == Colors.green) return 'أخضر'; if (c == Colors.orange) return 'برتقالي'; if (c == Colors.purple) return 'بنفسجي'; return 'وردي'; }

class _DrawingPainter extends CustomPainter {
  final Color color; final List<List<Offset>> strokes; final List<Offset> current;
  _DrawingPainter(this.color, this.strokes, this.current);
  @override void paint(Canvas canvas, Size size) { final p = Paint()..color = color..strokeWidth = 8..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round; void line(List<Offset> pts) { for (var i = 1; i < pts.length; i++) { canvas.drawLine(pts[i - 1], pts[i], p); } } for (final s in strokes) { line(s); } line(current); }
  @override bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

class _ColorsPage extends StatefulWidget {
  const _ColorsPage();
  @override State<_ColorsPage> createState() => _ColorsPageState();
}
class _ColorsPageState extends State<_ColorsPage> {
  int drawing = 0; Color selected = const Color(0xFFF44336);
  final colors = const <Color>[Color(0xFFF44336), Color(0xFF2196F3), Color(0xFFFFC107), Color(0xFF4CAF50), Color(0xFFFF8A00), Color(0xFF8E5CF6), Color(0xFF00AFA5)];
  final names = const ['أحمر','أزرق','أصفر','أخضر','برتقالي','بنفسجي','تركوازي'];
  final drawings = const ['قطة'];
  final fills = List<Color>.filled(6, Colors.white);
  @override
  Widget build(BuildContext context) => _Page('الألوان والتلوين', [
    Text('اختر اللون: ${names[colors.indexOf(selected)]}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
    Wrap(alignment: WrapAlignment.center, children: [for (var i = 0; i < colors.length; i++) GestureDetector(onTap: () { setState(() => selected = colors[i]); VoiceService.arabic(names[i]); }, child: Container(width: 42, height: 42, margin: const EdgeInsets.all(5), decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle, border: Border.all(color: selected == colors[i] ? Colors.black : Colors.transparent, width: 4))))]),
    const SizedBox(height: 8),
    Text('لوّن ${drawings[drawing]} بالضغط على أجزاء الرسم.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
    Container(height: 330, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: selected, width: 3)), child: GestureDetector(onTapUp: (d) => _paintPart(d.localPosition), child: CustomPaint(painter: _ColoringPainter(drawing, fills), child: const SizedBox.expand()))),
    const SizedBox(height: 8),
    Row(children: [Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), () => setState(() { final p = fills.lastIndexWhere((c) => c != Colors.white); if (p >= 0) fills[p] = Colors.white; }))), const SizedBox(width: 8), Expanded(child: _Btn('🗑 مسح الألوان', const Color(0xFFE53935), () => setState(() { for (var i = 0; i < fills.length; i++) { fills[i] = Colors.white; } }))) ]),
    const SizedBox(height: 8),
    Row(children: [Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), drawing > 0 ? () => setState(() => drawing--) : () {})), const SizedBox(width: 8), Expanded(child: _Btn('التالي', const Color(0xFF16B878), drawing < drawings.length - 1 ? () => setState(() => drawing++) : () {}))]),
  ]);
  void _paintPart(Offset p) { final slot = (p.dx / 55).floor().clamp(0, 5); setState(() => fills[slot] = selected); }
}

class _ColoringPainter extends CustomPainter {
  final int type; final List<Color> fills;
  _ColoringPainter(this.type, this.fills);
  @override void paint(Canvas canvas, Size size) {
    final fill = Paint(), outline = Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = Colors.black87;
    final center = Offset(size.width / 2, size.height / 2 + 20);
    if (type == 0) { // قطة
      final body = Rect.fromCenter(center: center.translate(0, 30), width: 190, height: 120); fill.color = fills[0]; canvas.drawOval(body, fill); canvas.drawOval(body, outline);
      final head = Rect.fromCenter(center: center.translate(0, -55), width: 135, height: 115); fill.color = fills[1]; canvas.drawOval(head, fill); canvas.drawOval(head, outline);
      final l = Path()..moveTo(center.dx - 55, center.dy - 105)..lineTo(center.dx - 40, center.dy - 160)..lineTo(center.dx - 5, center.dy - 120)..close(); fill.color = fills[2]; canvas.drawPath(l, fill); canvas.drawPath(l, outline);
      final r = Path()..moveTo(center.dx + 55, center.dy - 105)..lineTo(center.dx + 40, center.dy - 160)..lineTo(center.dx + 5, center.dy - 120)..close(); fill.color = fills[3]; canvas.drawPath(r, fill); canvas.drawPath(r, outline);
      final tail = Path()..moveTo(center.dx + 85, center.dy + 30)..quadraticBezierTo(center.dx + 150, center.dy - 5, center.dx + 125, center.dy - 45); canvas.drawPath(tail, outline);
      canvas.drawCircle(center.translate(-25, -65), 7, Paint()..color = Colors.black); canvas.drawCircle(center.translate(25, -65), 7, Paint()..color = Colors.black);
    } else { // حيوانات مبسطة قابلة للتلوين
      final body = Rect.fromCenter(center: center, width: 210, height: 120); fill.color = fills[0]; canvas.drawOval(body, fill); canvas.drawOval(body, outline);
      final head = Rect.fromCenter(center: center.translate(90, -35), width: 80, height: 75); fill.color = fills[1]; canvas.drawOval(head, fill); canvas.drawOval(head, outline);
      canvas.drawCircle(center.translate(110, -45), 5, Paint()..color = Colors.black);
      canvas.drawLine(center.translate(-80, 55), center.translate(-80, 100), outline);
      canvas.drawLine(center.translate(-25, 55), center.translate(-25, 100), outline);
      canvas.drawLine(center.translate(25, 55), center.translate(25, 100), outline);
      canvas.drawLine(center.translate(80, 45), center.translate(80, 100), outline);
    }
    final label = TextPainter(text: TextSpan(text: drawingsLabel(type), style: const TextStyle(fontSize: 26, color: Colors.black87, fontWeight: FontWeight.bold)), textDirection: TextDirection.rtl)..layout(); label.paint(canvas, Offset((size.width - label.width) / 2, 10));
  }
  @override bool shouldRepaint(covariant _ColoringPainter oldDelegate) => true;
}
String drawingsLabel(int i) => const ['قطة'][i];

class _ShapesPage extends StatelessWidget {
  final bool kg2;
  const _ShapesPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    final names = kg2 ? const ['مربع','مثلث','دائرة','مستطيل','خماسي','سداسي'] : const ['مربع','مثلث','دائرة','مستطيل'];
    return _Page('الأشكال', [
      const Text('اضغط على الشكل لفتح صفحة الرسم.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: names.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) => _Btn(names[i], const Color(0xFFE94F9B), () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => _ShapeDrawingPage(name: names[i]))))),
    ]);
  }
}

class _ShapeDrawingPage extends StatefulWidget {
  final String name;
  const _ShapeDrawingPage({required this.name});
  @override State<_ShapeDrawingPage> createState() => _ShapeDrawingPageState();
}
class _ShapeDrawingPageState extends State<_ShapeDrawingPage> {
  Color ink = const Color(0xFF7652FF);
  @override
  Widget build(BuildContext context) => _FixedPage('رسم ${widget.name}', Column(children: [
    Text('اتبع الشكل ثم ارسمه بنفسك.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
    const SizedBox(height: 6),
    SizedBox(height: 150, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: ink, width: 3)), child: CustomPaint(painter: _ShapeGuidePainter(widget.name), child: const SizedBox.expand()))),
    const SizedBox(height: 7),
    Expanded(child: _DrawingBoard(color: ink, onColorChanged: (c) => setState(() => ink = c))),
  ]));
}
class _ShapeGuidePainter extends CustomPainter {
  final String name;
  _ShapeGuidePainter(this.name);
  @override void paint(Canvas canvas, Size size) { final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = Colors.grey; final c = Offset(size.width / 2, size.height / 2); if (name == 'دائرة') { canvas.drawCircle(c, 50, p); return; } if (name == 'مربع') { canvas.drawRect(Rect.fromCenter(center: c, width: 90, height: 90), p); return; } if (name == 'مستطيل') { canvas.drawRect(Rect.fromCenter(center: c, width: 140, height: 80), p); return; } final sides = name == 'مثلث' ? 3 : name == 'خماسي' ? 5 : 6; final path = Path(); for (var i = 0; i < sides; i++) { final a = -math.pi / 2 + i * 2 * math.pi / sides; final q = c + Offset(50 * math.cos(a), 50 * math.sin(a)); if (i == 0) { path.moveTo(q.dx, q.dy); } else { path.lineTo(q.dx, q.dy); } } path.close(); canvas.drawPath(path, p); }
  @override bool shouldRepaint(covariant _ShapeGuidePainter oldDelegate) => oldDelegate.name != name;
}

class _GamesPage extends StatelessWidget {
  final bool kg2;
  const _GamesPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _Page(kg2 ? 'القصص والألعاب' : 'الألعاب', [
    if (kg2) ...[
      _GameButton(title: '📖 قصة الأرنب المجتهد', color: const Color(0xFF7652FF), page: const _StoryPage(title: 'الأرنب المجتهد', pages: ['كان أرنب صغير يحب التعلم.','تعلم الحروف ثم الأرقام كل يوم.','فرح لأنه لم يستسلم وأصبح مجتهدًا!'])),
      const SizedBox(height: 10),
      _GameButton(title: '📖 قصة رحلة الحروف', color: const Color(0xFF18A7E8), page: const _StoryPage(title: 'رحلة الحروف', pages: ['خرجت الحروف في رحلة جميلة.','التقت كل مجموعة بحرف جديد.','عاد الجميع وهم يعرفون أشكال الحروف!'])),
      const SizedBox(height: 10),
    ],
    _GameButton(title: '🔤 لعبة الحروف', color: const Color(0xFFE94F9B), page: const _LetterGame()),
    const SizedBox(height: 10),
    _GameButton(title: '🔢 لعبة الأرقام', color: const Color(0xFF16B878), page: _NumberGame(max: kg2 ? 20 : 10)),
    if (kg2) ...[const SizedBox(height: 10), _GameButton(title: '🔟 لعبة العشرات', color: const Color(0xFF7652FF), page: const _PlaceGame())],
  ]);
}
class _GameButton extends StatelessWidget {
  final String title; final Color color; final Widget page;
  const _GameButton({required this.title, required this.color, required this.page});
  @override Widget build(BuildContext context) => _Btn(title, color, () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page)));
}
class _StoryPage extends StatefulWidget {
  final String title; final List<String> pages;
  const _StoryPage({required this.title, required this.pages});
  @override State<_StoryPage> createState() => _StoryPageState();
}
class _StoryPageState extends State<_StoryPage> {
  int index = 0;
  @override Widget build(BuildContext context) => _Page(widget.title, [const Icon(Icons.menu_book_rounded, size: 90, color: Color(0xFF7652FF)), Text(widget.pages[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 18), Row(children: [Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() => index--) : () {})), const SizedBox(width: 8), Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < widget.pages.length - 1 ? () => setState(() => index++) : () {}))])]);
}

class _LetterGame extends StatefulWidget { const _LetterGame(); @override State<_LetterGame> createState() => _LetterGameState(); }
class _LetterGameState extends State<_LetterGame> {
  final random = math.Random(); int target = 0, score = 0; late List<String> options;
  @override void initState() { super.initState(); _newRound(); }
  void _newRound() { final set = <String>{_letters[target]}; while (set.length < 4) { set.add(_letters[random.nextInt(_letters.length)]); } options = set.toList()..shuffle(random); }
  void answer(String letter) { if (letter != _letters[target]) { VoiceService.arabic('حاول مرة أخرى'); return; } setState(() { score++; target = random.nextInt(_letters.length); _newRound(); }); VoiceService.arabic(_letters[target]); }
  @override Widget build(BuildContext context) => _Page('لعبة الحروف', [const Text('اختر الحرف المطابق للسؤال', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text(_letters[target], textAlign: TextAlign.center, style: const TextStyle(fontSize: 82, fontWeight: FontWeight.w900)), Text('النقاط: ${_ar(score)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), for (final letter in options) ...[const SizedBox(height: 8), _Btn(letter, const Color(0xFF7652FF), () => answer(letter))]]);
}

class _NumberGame extends StatefulWidget { final int max; const _NumberGame({required this.max}); @override State<_NumberGame> createState() => _NumberGameState(); }
class _NumberGameState extends State<_NumberGame> {
  final random = math.Random(); int target = 1, score = 0; late List<int> choices;
  @override void initState() { super.initState(); _newRound(); }
  void _newRound() { final set = <int>{target}; while (set.length < 4) set.add(random.nextInt(widget.max) + 1); choices = set.toList()..shuffle(random); }
  void answer(int n) { if (n != target) { VoiceService.arabic('حاول مرة أخرى'); return; } setState(() { score++; target = random.nextInt(widget.max) + 1; _newRound(); }); }
  @override Widget build(BuildContext context) => _Page('لعبة الأرقام', [const Text('اختر الرقم المطابق للسؤال', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text(_ar(target), textAlign: TextAlign.center, style: const TextStyle(fontSize: 76, fontWeight: FontWeight.w900)), Text('النقاط: ${_ar(score)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), for (final n in choices) ...[const SizedBox(height: 8), _Btn(_ar(n), const Color(0xFF16B878), () => answer(n))]]);
}

class _PlaceGame extends StatelessWidget { const _PlaceGame(); @override Widget build(BuildContext context) => _Page('لعبة العشرات', [const Text('هذه اللعبة ستختبر الآحاد والعشرات في المرحلة الثانية.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))]); }
