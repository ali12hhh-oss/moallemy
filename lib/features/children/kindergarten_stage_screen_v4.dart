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
            _KgItem('الكتابة', 'حروف وأرقام ودمج + لون القلم', Icons.draw_rounded, Color(0xFF16B878)),
            _KgItem('الألوان', 'ألوان وحيوان بنفس اللون', Icons.palette_rounded, Color(0xFFFF8A3D)),
            _KgItem('الأشكال', 'أساسية ومتقدمة مع النطق', Icons.category_rounded, Color(0xFFE94F9B)),
            _KgItem('القصص والألعاب', 'قصص وألعاب تعليمية', Icons.auto_stories_rounded, Color(0xFFFFB300)),
          ]
        : const <_KgItem>[
            _KgItem('الحروف', '٢٨ حرفًا عربيًا + صوت واسم وكلمة', Icons.abc_rounded, Color(0xFF7652FF)),
            _KgItem('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded, Color(0xFF18A7E8)),
            _KgItem('الكتابة', 'حروف وأرقام + اختيار لون القلم', Icons.draw_rounded, Color(0xFF16B878)),
            _KgItem('الألوان', 'ألوان وحيوان بنفس اللون', Icons.palette_rounded, Color(0xFFFF8A3D)),
            _KgItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل ومنحرف وشبه منحرف', Icons.category_rounded, Color(0xFFE94F9B)),
            _KgItem('الألعاب', 'لعبة حروف ولعبة أرقام', Icons.sports_esports_rounded, Color(0xFFFFB300)),
          ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _MenuCard(
              title: kg2 ? 'الروضة الثانية' : 'الروضة الأولى',
              subtitle: 'تعلم بالصوت واللون والكتابة واللعب',
              icon: Icons.star_rounded,
              color: const Color(0xFF7652FF),
              onTap: () => AppFeedback.show('🌟 هيا نتعلم!'),
            ),
            const SizedBox(height: 16),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MenuCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: item.icon,
                  color: item.color,
                  onTap: () => _open(context, item.title),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    final Widget page;
    switch (title) {
      case 'الحروف':
        page = _LettersPage(kg2: kg2);
        break;
      case 'الأرقام':
        page = _NumbersPage(kg2: kg2);
        break;
      case 'الكتابة':
        page = _WritingPage(kg2: kg2);
        break;
      case 'الألوان':
        page = const _ColorsPage();
        break;
      case 'الأشكال':
        page = _ShapesPage(kg2: kg2);
        break;
      default:
        page = _GamesPage(kg2: kg2);
    }
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _KgItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _KgItem(this.title, this.subtitle, this.icon, this.color);
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return App3DCard(
      onTap: onTap,
      encouragement: '✨ $title',
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.68)]),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 42),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
                  Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Page(this.title, this.children);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(padding: const EdgeInsets.all(16), children: children),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  const _Btn(this.text, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return App3DCard(
      onTap: onTap,
      encouragement: '✨ $text',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override State<_LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<_LettersPage> {
  int index = 0;
  static const forms = <String, List<String>>{
    'ب': ['بـ', 'ـبـ', 'ـب'], 'ت': ['تـ', 'ـتـ', 'ـت'], 'ث': ['ثـ', 'ـثـ', 'ـث'],
    'ج': ['جـ', 'ـجـ', 'ـج'], 'ح': ['حـ', 'ـحـ', 'ـح'], 'خ': ['خـ', 'ـخـ', 'ـخ'],
    'س': ['سـ', 'ـسـ', 'ـس'], 'ش': ['شـ', 'ـشـ', 'ـش'], 'ص': ['صـ', 'ـصـ', 'ـص'],
    'ض': ['ضـ', 'ـضـ', 'ـض'], 'ط': ['طـ', 'ـطـ', 'ـط'], 'ظ': ['ظـ', 'ـظـ', 'ـظ'],
    'ع': ['عـ', 'ـعـ', 'ـع'], 'غ': ['غـ', 'ـغـ', 'ـغ'], 'ف': ['فـ', 'ـفـ', 'ـف'],
    'ق': ['قـ', 'ـقـ', 'ـق'], 'ك': ['كـ', 'ـكـ', 'ـك'], 'ل': ['لـ', 'ـلـ', 'ـل'],
    'م': ['مـ', 'ـمـ', 'ـم'], 'ن': ['نـ', 'ـنـ', 'ـن'], 'ه': ['هـ', 'ـهـ', 'ـه'],
    'ي': ['يـ', 'ـيـ', 'ـي'],
  };

  @override
  Widget build(BuildContext context) {
    final x = arabicLetters[index];
    final f = forms[x.letter] ?? [x.letter, x.letter, x.letter];
    return _Page('الحروف العربية', [
      Text('${arNum(index + 1)} من ${arNum(28)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      App3DCard(
        onTap: () => VoiceService.arabicLetterSound(x.letter, fallbackText: x.sound),
        encouragement: '🔊 صوت الحرف',
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF7652FF), Color(0xFF536DFE)]),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(children: [
            Text(x.letter, style: const TextStyle(color: Colors.white, fontSize: 105, fontWeight: FontWeight.w900)),
            Text('صوت القراءة: ${x.sound}', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
      if (widget.kg2) ...[
        const SizedBox(height: 10),
        Row(
          children: [
            for (var j = 0; j < 3; j++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: j == 0 ? 0 : 5),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFF7652FF).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(15)),
                    child: Column(children: [
                      Text(f[j], style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w900)),
                      Text(['أولي', 'وسطي', 'آخري'][j], style: const TextStyle(fontWeight: FontWeight.w800)),
                    ]),
                  ),
                ),
              ),
          ],
        ),
      ],
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() => index--) : () => AppFeedback.show('💛 أنت في البداية'))),
        const SizedBox(width: 7),
        Expanded(child: _Btn('🔊 نطق', const Color(0xFF18A7E8), () => VoiceService.arabicLetterSound(x.letter, fallbackText: x.sound))),
        const SizedBox(width: 7),
        Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < 27 ? () => setState(() => index++) : () => AppFeedback.show('🏆 أكملت الحروف!'))),
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
      if (widget.kg2)
        Row(children: [
          Expanded(child: _Btn('الأعداد ١–٥٠', const Color(0xFF18A7E8), () => setState(() => places = false))),
          const SizedBox(width: 8),
          Expanded(child: _Btn('مراتب الأعداد', const Color(0xFF7652FF), () => setState(() => places = true))),
        ]),
      if (widget.kg2) const SizedBox(height: 14),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: max,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (_, i) => App3DCard(
          onTap: () => VoiceService.arabic(_numberName(i + 1)),
          encouragement: '🔊 ${arNum(i + 1)}',
          child: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF18A7E8), Color(0xFF42A5F5)]), borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(child: Text(arNum(i + 1), style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900))),
          ),
        ),
      ),
    ]);
  }
}

class _PlaceValuePage extends StatefulWidget {
  const _PlaceValuePage();
  @override State<_PlaceValuePage> createState() => _PlaceValuePageState();
}

class _PlaceValuePageState extends State<_PlaceValuePage> {
  int number = 24;
  @override
  Widget build(BuildContext context) {
    final tens = number ~/ 10;
    final ones = number % 10;
    return _Page('مراتب الأعداد', [
      const Text('درس تعليمي للقيمة المكانية وليس اختبارًا', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Text(arNum(number), textAlign: TextAlign.center, style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _Btn('العشرات: ${arNum(tens)}', const Color(0xFF7652FF), () => AppFeedback.show('💜 قيمة العشرات هي ${arNum(tens * 10)}'))),
        const SizedBox(width: 10),
        Expanded(child: _Btn('الآحاد: ${arNum(ones)}', const Color(0xFF16B878), () => AppFeedback.show('💚 قيمة الآحاد هي ${arNum(ones)}'))),
      ]),
      const SizedBox(height: 10),
      Slider(min: 10, max: 50, divisions: 40, value: number.toDouble(), label: arNum(number), onChanged: (v) => setState(() => number = v.round())),
    ]);
  }
}

class _WritingPage extends StatefulWidget {
  final bool kg2;
  const _WritingPage({required this.kg2});
  @override State<_WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<_WritingPage> {
  int tab = 0;
  int index = 0;
  Color ink = const Color(0xFF7652FF);

  @override
  Widget build(BuildContext context) {
    final letters = tab == 0;
    final max = letters ? 28 : (widget.kg2 ? 50 : 10);
    final guide = letters ? arabicLetters[index].letter : arNum(index + 1);
    return _Page('الكتابة', [
      Row(children: [
        Expanded(child: _Btn('الحروف', const Color(0xFF7652FF), () => setState(() { tab = 0; index = 0; }))),
        const SizedBox(width: 8),
        Expanded(child: _Btn('الأرقام', const Color(0xFF18A7E8), () => setState(() { tab = 1; index = 0; }))),
      ]),
      const SizedBox(height: 12),
      Text('اكتب: $guide', textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      _DrawingBoard(color: ink, onColorChanged: (c) => setState(() => ink = c)),
      if (widget.kg2 && letters)
        const Padding(padding: EdgeInsets.all(8), child: Text('دمج: د + و • ن + ا • د + ي • ب + ا • م + ا • ل + ا', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800))),
      if (widget.kg2 && !letters)
        const Padding(padding: EdgeInsets.all(8), child: Text('القيمة المكانية: العشرات أولًا ثم الآحاد', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800))),
      Row(children: [
        Expanded(child: _Btn('السابق', const Color(0xFFE94F9B), index > 0 ? () => setState(() => index--) : () => AppFeedback.show('💛 البداية'))),
        const SizedBox(width: 8),
        Expanded(child: _Btn('🔊 اسمع', const Color(0xFF7652FF), () => letters ? VoiceService.arabicLetterSound(arabicLetters[index].letter, fallbackText: arabicLetters[index].sound) : VoiceService.arabic(_numberName(index + 1)))),
        const SizedBox(width: 8),
        Expanded(child: _Btn('التالي', const Color(0xFF16B878), index < max - 1 ? () => setState(() => index++) : () => AppFeedback.show('🏆 أحسنت!'))),
      ]),
    ]);
  }
}

class _DrawingBoard extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;
  const _DrawingBoard({required this.color, required this.onColorChanged});
  @override State<_DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<_DrawingBoard> {
  final List<List<Offset>> strokes = <List<Offset>>[];
  List<Offset> current = <Offset>[];

  void clear() => setState(() { strokes.clear(); current = <Offset>[]; });

  @override
  Widget build(BuildContext context) {
    const colors = [Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink];
    return Column(children: [
      Container(
        height: 290,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: widget.color, width: 3)),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (e) => setState(() => current = <Offset>[e.localPosition]),
          onPointerMove: (e) => setState(() => current = <Offset>[...current, e.localPosition]),
          onPointerUp: (_) { if (current.isNotEmpty) strokes.add(List<Offset>.of(current)); setState(() => current = <Offset>[]); },
          onPointerCancel: (_) => setState(() => current = <Offset>[]),
          child: CustomPaint(painter: _DrawingPainter(widget.color, strokes, current), child: const SizedBox.expand()),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          const Text('لون القلم: '),
          for (final color in colors)
            GestureDetector(onTap: () => widget.onColorChanged(color), child: Container(width: 32, height: 32, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
          TextButton.icon(onPressed: clear, icon: const Icon(Icons.delete_outline), label: const Text('مسح')),
        ]),
      ),
    ]);
  }
}

class _DrawingPainter extends CustomPainter {
  final Color color;
  final List<List<Offset>> strokes;
  final List<Offset> current;
  _DrawingPainter(this.color, this.strokes, this.current);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 11..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    void drawStroke(List<Offset> points) {
      for (var i = 1; i < points.length; i++) {
        canvas.drawLine(points[i - 1], points[i], paint);
      }
    }
    for (final for (final stroke in strokes) {
  drawStroke(stroke);
}
    drawStroke(current);
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}

class _ColorsPage extends StatelessWidget {
  const _ColorsPage();
  static const data = <String>['أحمر','أزرق','أصفر','أخضر','برتقالي','بنفسجي','وردي','تركوازي','بني','رمادي','أبيض','أسود','ذهبي','فضي'];
  static const colors = <Color>[Color(0xFFF44336),Color(0xFF2196F3),Color(0xFFFFC107),Color(0xFF4CAF50),Color(0xFFFF8A00),Color(0xFF8E5CF6),Color(0xFFE91E63),Color(0xFF00AFA5),Color(0xFF795548),Color(0xFF78909C),Color(0xFFF5F5F5),Color(0xFF303030),Color(0xFFFFB300),Color(0xFFB0BEC5)];

  @override
  Widget build(BuildContext context) {
    return _Page('الألوان', [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (_, i) => App3DCard(
          onTap: () => AppFeedback.show('🎨 ${data[i]}'),
          encouragement: '🎨 ${data[i]}',
          child: Container(
            decoration: BoxDecoration(color: colors[i], borderRadius: BorderRadius.circular(22)),
            child: Center(child: Text(data[i], style: TextStyle(color: i == 10 ? Colors.black : Colors.white, fontSize: 21, fontWeight: FontWeight.w900))),
          ),
        ),
      ),
    ]);
  }
}

class _ShapesPage extends StatelessWidget {
  final bool kg2;
  const _ShapesPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    final names = <String>['مربع','مثلث','دائرة','مستطيل','منحرف','شبه منحرف'];
    if (kg2) names.addAll(['خماسي','سداسي','ثماني','بيضاوي','معين','ديناري']);
    return _Page('الأشكال', [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: names.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemBuilder: (_, i) => App3DCard(
          onTap: () => VoiceService.arabic(names[i]),
          encouragement: '🔷 ${names[i]}',
          child: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFE94F9B), Color(0xFF7652FF)]), borderRadius: BorderRadius.all(Radius.circular(22))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(_shapeIcon(names[i]), color: Colors.white, size: 62),
              Text(names[i], style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
            ]),
          ),
        ),
      ),
    ]);
  }
}

IconData _shapeIcon(String name) {
  switch (name) {
    case 'دائرة': return Icons.circle;
    case 'مربع': return Icons.square;
    case 'مثلث': return Icons.change_history;
    case 'مستطيل': return Icons.rectangle;
    case 'معين': return Icons.diamond;
    case 'خماسي': return Icons.pentagon;
    case 'سداسي': return Icons.hexagon;
    default: return Icons.category_rounded;
  }
}

class _GamesPage extends StatelessWidget {
  final bool kg2;
  const _GamesPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    return _Page(kg2 ? 'القصص والألعاب' : 'الألعاب', [
      if (kg2) _Btn('📖 القصة الأولى\nالأرنب المجتهد', const Color(0xFF7652FF), () => AppFeedback.show('📖 قصة الأرنب المجتهد')),
      if (kg2) _Btn('📖 القصة الثانية\nرحلة الحروف', const Color(0xFF18A7E8), () => AppFeedback.show('📖 قصة رحلة الحروف')),
      _Btn('🔤 لعبة الحروف\nاختر الحرف الصحيح', const Color(0xFFE94F9B), () => AppFeedback.show('🎉 أحسنت!')),
      if (kg2) _Btn('🔗 لعبة دمج الحروف\nادمج حرفين', const Color(0xFFFF8A3D), () => AppFeedback.show('✨ دمج رائع!')),
      _Btn('🔢 لعبة الأرقام\nاختر الرقم الصحيح', const Color(0xFF16B878), () => AppFeedback.show('🎉 إجابة ممتازة!')),
      if (kg2) _Btn('🔟 لعبة العشرات\nتعلم قيمة العشرات', const Color(0xFF7652FF), () => AppFeedback.show('💜 ممتاز!')),
    ]);
  }
}

String _numberName(int n) {
  const names = ['', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة', 'عشرة'];
  return n <= 10 ? names[n] : n.toString();
}
