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
        ? const <_MenuItem>[
            _MenuItem('الحروف', 'أولي ووسطي وآخري + نطق', Icons.abc_rounded),
            _MenuItem('الأرقام', '١ إلى ٥٠ + النطق', Icons.pin_rounded),
            _MenuItem('الكتابة', 'حروف وأرقام + لوحة ثابتة', Icons.draw_rounded),
            _MenuItem('الألوان', 'ألوان ورسومات مطابقة قابلة للتلوين', Icons.palette_rounded),
            _MenuItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل وخماسي وسداسي', Icons.category_rounded),
            _MenuItem('القصص والألعاب', 'ألعاب حروف وأرقام مع النطق', Icons.auto_stories_rounded),
          ]
        : const <_MenuItem>[
            _MenuItem('الحروف', '٢٨ حرفًا عربيًا + صوت واسم', Icons.abc_rounded),
            _MenuItem('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded),
            _MenuItem('الكتابة', 'حروف وأرقام مع لوحة ثابتة', Icons.draw_rounded),
            _MenuItem('الألوان', 'ألوان ورسومات مطابقة قابلة للتلوين', Icons.palette_rounded),
            _MenuItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل', Icons.category_rounded),
            _MenuItem('الألعاب', 'ألعاب حروف وأرقام مع النطق', Icons.sports_esports_rounded),
          ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final item in items) ...[
              _MenuCard(item: item, onTap: () => _open(context, item.title)),
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
        page = _ColorsPage(kg2: kg2);
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

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _MenuItem(this.title, this.subtitle, this.icon);
}

class _MenuCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onTap;

  const _MenuCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7652FF), Color(0xFF18A7E8)],
            ),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: Colors.white, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      ),
    );
  }
}

class _FixedPage extends StatelessWidget {
  final String title;
  final Widget child;

  const _FixedPage(this.title, this.child);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final bool selected;

  const _Btn(
    this.text,
    this.color,
    this.onTap, {
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: selected ? color.withAlpha(190) : color,
        borderRadius: BorderRadius.circular(15),
        border: selected
            ? Border.all(color: Colors.white, width: 3)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _ar(int number) {
  return number.toString().replaceAllMapped(
        RegExp(r'\d'),
        (match) => '٠١٢٣٤٥٦٧٨٩'[int.parse(match.group(0)!)],
      );
}

const _letters = <String>[
  'ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
  'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي',
];

const _sounds = <String>[
  'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
  'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي',
];

const _forms = <List<String>>[
  ['ا', 'ـا', 'ـا'],
  ['بـ', 'ـبـ', 'ـب'],
  ['تـ', 'ـتـ', 'ـت'],
  ['ثـ', 'ـثـ', 'ـث'],
  ['جـ', 'ـجـ', 'ـج'],
  ['حـ', 'ـحـ', 'ـح'],
  ['خـ', 'ـخـ', 'ـخ'],
  ['د', 'ـد', 'ـد'],
  ['ذ', 'ـذ', 'ـذ'],
  ['ر', 'ـر', 'ـر'],
  ['ز', 'ـز', 'ـز'],
  ['سـ', 'ـسـ', 'ـس'],
  ['شـ', 'ـشـ', 'ـش'],
  ['صـ', 'ـصـ', 'ـص'],
  ['ضـ', 'ـضـ', 'ـض'],
  ['طـ', 'ـطـ', 'ـط'],
  ['ظـ', 'ـظـ', 'ـظ'],
  ['عـ', 'ـعـ', 'ـع'],
  ['غـ', 'ـغـ', 'ـغ'],
  ['فـ', 'ـفـ', 'ـف'],
  ['قـ', 'ـقـ', 'ـق'],
  ['كـ', 'ـكـ', 'ـك'],
  ['لـ', 'ـلـ', 'ـل'],
  ['مـ', 'ـمـ', 'ـم'],
  ['نـ', 'ـنـ', 'ـن'],
  ['هـ', 'ـهـ', 'ـه'],
  ['و', 'ـو', 'ـو'],
  ['يـ', 'ـيـ', 'ـي'],
];

class _LettersPage extends StatefulWidget {
  final bool kg2;

  const _LettersPage({required this.kg2});

  @override
  State<_LettersPage> createState() => _LettersState();
}

class _LettersState extends State<_LettersPage> {
  int index = 0;
  int form = 0;

  void speak() {
    VoiceService.arabic(_sounds[index]);
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.kg2 ? _forms[index][form] : _letters[index];
    return _Page(
      'الحروف العربية',
      [
        Text('${_ar(index + 1)} من ٢٨', textAlign: TextAlign.center),
        Text(
          letter,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 105, fontWeight: FontWeight.w900),
        ),
        Text('صوت القراءة: ${_sounds[index]}', textAlign: TextAlign.center),
        _Btn('🔊 نطق الحرف', const Color(0xFF18A7E8), speak),
        if (widget.kg2)
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: _Btn(
                  ['أولي', 'وسطي', 'آخري'][i],
                  const Color(0xFF7652FF),
                  () => setState(() => form = i),
                  selected: form == i,
                ),
              ),
            ),
          ),
        _NavigationButtons(
          canPrevious: index > 0,
          canNext: index < _letters.length - 1,
          onPrevious: () => setState(() => index--),
          onNext: () => setState(() => index++),
        ),
      ],
    );
  }
}

class _NumbersPage extends StatelessWidget {
  final bool kg2;

  const _NumbersPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    final count = kg2 ? 50 : 10;
    return _Page(
      'الأرقام',
      [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, index) {
            final value = _ar(index + 1);
            return _Btn(
              value,
              const Color(0xFF18A7E8),
              () => VoiceService.arabic(value),
            );
          },
        ),
      ],
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final bool canPrevious;
  final bool canNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _NavigationButtons({
    required this.canPrevious,
    required this.canNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Btn(
            'السابق',
            const Color(0xFFE94F9B),
            canPrevious ? onPrevious : () {},
          ),
        ),
        Expanded(
          child: _Btn(
            'التالي',
            const Color(0xFF16B878),
            canNext ? onNext : () {},
          ),
        ),
      ],
    );
  }
}

class _WritingPage extends StatefulWidget {
  final bool kg2;

  const _WritingPage({required this.kg2});

  @override
  State<_WritingPage> createState() => _WritingState();
}

class _WritingState extends State<_WritingPage> {
  int tab = 0;
  int index = 0;
  List<List<Offset>> strokes = <List<Offset>>[];

  String get text => tab == 0 ? _letters[index] : _ar(index + 1);
  int get max => tab == 0 ? _letters.length : (widget.kg2 ? 50 : 10);

  void clear() {
    setState(() => strokes = <List<Offset>>[]);
  }

  void undo() {
    if (strokes.isNotEmpty) {
      setState(() => strokes.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FixedPage(
      'الكتابة',
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Btn(
                  'الحروف',
                  const Color(0xFF7652FF),
                  () => setState(() {
                    tab = 0;
                    index = 0;
                    strokes = <List<Offset>>[];
                  }),
                  selected: tab == 0,
                ),
              ),
              Expanded(
                child: _Btn(
                  'الأرقام',
                  const Color(0xFF18A7E8),
                  () => setState(() {
                    tab = 1;
                    index = 0;
                    strokes = <List<Offset>>[];
                  }),
                  selected: tab == 1,
                ),
              ),
            ],
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900),
          ),
          Expanded(
            child: _DrawingBoard(
              strokes: strokes,
              color: Colors.black,
              onChanged: (value) => setState(() => strokes = value),
            ),
          ),
          Row(
            children: [
              Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), undo)),
              Expanded(child: _Btn('🗑 مسح', const Color(0xFFE94F4F), clear)),
            ],
          ),
          _NavigationButtons(
            canPrevious: index > 0,
            canNext: index < max - 1,
            onPrevious: () => setState(() {
              index--;
              strokes = <List<Offset>>[];
            }),
            onNext: () => setState(() {
              index++;
              strokes = <List<Offset>>[];
            }),
          ),
        ],
      ),
    );
  }
}

class _ColorsPage extends StatefulWidget {
  final bool kg2;

  const _ColorsPage({required this.kg2});

  @override
  State<_ColorsPage> createState() => _ColorsState();
}

class _ColorItem {
  final String name;
  final Color color;

  const _ColorItem(this.name, this.color);
}

const _colors = <_ColorItem>[
  _ColorItem('أحمر', Color(0xFFE53935)),
  _ColorItem('أزرق', Color(0xFF1E88E5)),
  _ColorItem('أصفر', Color(0xFFFDD835)),
  _ColorItem('أخضر', Color(0xFF43A047)),
  _ColorItem('برتقالي', Color(0xFFFB8C00)),
  _ColorItem('بنفسجي', Color(0xFF8E24AA)),
  _ColorItem('بني', Color(0xFF6D4C41)),
  _ColorItem('أسود', Color(0xFF212121)),
  _ColorItem('أبيض', Color(0xFFF5F5F5)),
  _ColorItem('وردي', Color(0xFFE91E63)),
];

class _ColorsState extends State<_ColorsPage> {
  int selectedColor = 0;
  int drawingIndex = 0;

  static const drawings = <String>[
    'سمكة',
    'نعجة',
    'قطة',
    'تفاحة',
    'شمس',
    'فراشة',
  ];

  void speakColor() {
    VoiceService.arabic(_colors[selectedColor].name);
  }

  @override
  Widget build(BuildContext context) {
    return _FixedPage(
      'الألوان',
      Column(
        children: [
          Text(
            'اختر لونًا ثم اضغط على الرسم للتلوين',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (_, index) {
                final item = _colors[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedColor = index);
                    VoiceService.arabic(item.name);
                  },
                  child: Container(
                    width: 72,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: index == selectedColor ? Colors.black : Colors.white,
                        width: index == selectedColor ? 4 : 2,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(3),
                        color: Colors.black54,
                        child: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _Btn('🔊 نطق اللون', const Color(0xFF18A7E8), speakColor),
          Expanded(
            child: _ColoringBoard(
              kind: drawings[drawingIndex],
              color: _colors[selectedColor].color,
            ),
          ),
          Text(
            drawings[drawingIndex],
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
          _NavigationButtons(
            canPrevious: drawingIndex > 0,
            canNext: drawingIndex < drawings.length - 1,
            onPrevious: () => setState(() => drawingIndex--),
            onNext: () => setState(() => drawingIndex++),
          ),
        ],
      ),
    );
  }
}

class _ColoringBoard extends StatelessWidget {
  final String kind;
  final Color color;

  const _ColoringBoard({required this.kind, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        VoiceService.arabic(kind);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black26, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomPaint(
          painter: _ColoringPainter(kind: kind, fillColor: color),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ColoringPainter extends CustomPainter {
  final String kind;
  final Color fillColor;

  const _ColoringPainter({required this.kind, required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    if (kind == 'سمكة') {
      final body = Rect.fromCenter(center: center, width: w * .48, height: h * .38);
      canvas.drawOval(body, fill);
      canvas.drawOval(body, outline);
      final tail = Path()
        ..moveTo(w * .26, h * .5)
        ..lineTo(w * .08, h * .34)
        ..lineTo(w * .08, h * .66)
        ..close();
      canvas.drawPath(tail, fill);
      canvas.drawPath(tail, outline);
      canvas.drawCircle(Offset(w * .62, h * .45), 6, Paint()..color = Colors.black);
    } else if (kind == 'نعجة') {
      final body = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * .48, h * .53), width: w * .55, height: h * .3),
        const Radius.circular(55),
      );
      canvas.drawRRect(body, fill);
      canvas.drawRRect(body, outline);
      canvas.drawCircle(Offset(w * .76, h * .5), h * .12, fill);
      canvas.drawCircle(Offset(w * .76, h * .5), h * .12, outline);
      canvas.drawCircle(Offset(w * .79, h * .47), 5, Paint()..color = Colors.black);
      for (final x in <double>[.3, .45, .58]) {
        canvas.drawLine(Offset(w * x, h * .68), Offset(w * x, h * .82), outline);
      }
    } else if (kind == 'قطة') {
      final head = Path()
        ..moveTo(w * .32, h * .42)
        ..lineTo(w * .28, h * .22)
        ..lineTo(w * .42, h * .31)
        ..quadraticBezierTo(w * .5, h * .26, w * .58, h * .31)
        ..lineTo(w * .72, h * .22)
        ..lineTo(w * .68, h * .42)
        ..quadraticBezierTo(w * .75, h * .72, w * .5, h * .76)
        ..quadraticBezierTo(w * .25, h * .72, w * .32, h * .42)
        ..close();
      canvas.drawPath(head, fill);
      canvas.drawPath(head, outline);
      canvas.drawCircle(Offset(w * .43, h * .46), 5, Paint()..color = Colors.black);
      canvas.drawCircle(Offset(w * .57, h * .46), 5, Paint()..color = Colors.black);
    } else if (kind == 'تفاحة') {
      final apple = Path()
        ..moveTo(w * .5, h * .3)
        ..cubicTo(w * .25, h * .18, w * .18, h * .48, w * .3, h * .67)
        ..cubicTo(w * .38, h * .82, w * .62, h * .82, w * .7, h * .67)
        ..cubicTo(w * .82, h * .48, w * .75, h * .18, w * .5, h * .3)
        ..close();
      canvas.drawPath(apple, fill);
      canvas.drawPath(apple, outline);
      canvas.drawLine(Offset(w * .5, h * .3), Offset(w * .54, h * .17), outline);
    } else if (kind == 'شمس') {
      canvas.drawCircle(center, math.min(w, h) * .22, fill);
      canvas.drawCircle(center, math.min(w, h) * .22, outline);
      for (var i = 0; i < 12; i++) {
        final angle = i * math.pi / 6;
        final a = Offset(
          center.dx + math.cos(angle) * math.min(w, h) * .28,
          center.dy + math.sin(angle) * math.min(w, h) * .28,
        );
        final b = Offset(
          center.dx + math.cos(angle) * math.min(w, h) * .4,
          center.dy + math.sin(angle) * math.min(w, h) * .4,
        );
        canvas.drawLine(a, b, outline);
      }
    } else {
      final left = Path()
        ..moveTo(center.dx, center.dy)
        ..cubicTo(w * .16, h * .22, w * .12, h * .62, center.dx, h * .76)
        ..close();
      final right = Path()
        ..moveTo(center.dx, center.dy)
        ..cubicTo(w * .84, h * .22, w * .88, h * .62, center.dx, h * .76)
        ..close();
      canvas.drawPath(left, fill);
      canvas.drawPath(right, fill);
      canvas.drawPath(left, outline);
      canvas.drawPath(right, outline);
      canvas.drawLine(Offset(center.dx, h * .2), Offset(center.dx, h * .8), outline);
    }
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.fillColor != fillColor;
  }
}

class _ShapesPage extends StatefulWidget {
  final bool kg2;

  const _ShapesPage({required this.kg2});

  @override
  State<_ShapesPage> createState() => _ShapesState();
}

class _ShapesState extends State<_ShapesPage> {
  int index = 0;

  List<String> get names => widget.kg2
      ? const ['مربع', 'مثلث', 'دائرة', 'مستطيل', 'خماسي', 'سداسي']
      : const ['مربع', 'مثلث', 'دائرة', 'مستطيل'];

  @override
  Widget build(BuildContext context) {
    final name = names[index];
    return _FixedPage(
      'الأشكال',
      Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => VoiceService.arabic(name),
              child: CustomPaint(
                painter: _ShapePainter(name),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Text(name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          _Btn('🔊 نطق الشكل', const Color(0xFF18A7E8), () => VoiceService.arabic(name)),
          _NavigationButtons(
            canPrevious: index > 0,
            canNext: index < names.length - 1,
            onPrevious: () => setState(() => index--),
            onNext: () => setState(() => index++),
          ),
        ],
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final String name;

  const _ShapePainter(this.name);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7652FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeJoin = StrokeJoin.round;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * .25;

    if (name == 'مربع') {
      canvas.drawRect(Rect.fromCenter(center: center, width: radius * 1.5, height: radius * 1.5), paint);
    } else if (name == 'مستطيل') {
      canvas.drawRect(Rect.fromCenter(center: center, width: radius * 2.1, height: radius * 1.2), paint);
    } else if (name == 'دائرة') {
      canvas.drawCircle(center, radius, paint);
    } else {
      final sides = name == 'خماسي' ? 5 : (name == 'سداسي' ? 6 : 3);
      final path = Path();
      for (var i = 0; i < sides; i++) {
        final angle = -math.pi / 2 + i * 2 * math.pi / sides;
        final point = Offset(
          center.dx + math.cos(angle) * radius,
          center.dy + math.sin(angle) * radius,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) => oldDelegate.name != name;
}

class _DrawingBoard extends StatefulWidget {
  final List<List<Offset>> strokes;
  final Color color;
  final ValueChanged<List<List<Offset>>> onChanged;

  const _DrawingBoard({
    required this.strokes,
    required this.color,
    required this.onChanged,
  });

  @override
  State<_DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<_DrawingBoard> {
  List<Offset> current = <Offset>[];

  void start(DragStartDetails details) {
    current = <Offset>[details.localPosition];
    setState(() {});
  }

  void update(DragUpdateDetails details) {
    current = <Offset>[...current, details.localPosition];
    setState(() {});
  }

  void end(DragEndDetails details) {
    if (current.isEmpty) {
      return;
    }
    final result = <List<Offset>>[...widget.strokes, List<Offset>.from(current)];
    current = <Offset>[];
    widget.onChanged(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final all = <List<Offset>>[...widget.strokes, if (current.isNotEmpty) current];
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: start,
          onPanUpdate: update,
          onPanEnd: end,
          child: CustomPaint(
            painter: _BoardPainter(strokes: all, color: widget.color),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  const _BoardPainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(Offset.zero & size, border);

    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 3, pen);
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, pen);
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.strokes != strokes || oldDelegate.color != color;
  }
}

class _GamesPage extends StatelessWidget {
  final bool kg2;

  const _GamesPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    return _Page(
      kg2 ? 'القصص والألعاب' : 'الألعاب',
      [
        _Btn(
          '🔤 لعبة الحروف',
          const Color(0xFF7652FF),
          () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const _LetterGame()),
          ),
        ),
        _Btn(
          '🔢 لعبة الأرقام',
          const Color(0xFF16B878),
          () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => _NumberGame(max: kg2 ? 50 : 20)),
          ),
        ),
      ],
    );
  }
}

class _LetterGame extends StatefulWidget {
  const _LetterGame();

  @override
  State<_LetterGame> createState() => _LetterGameState();
}

class _LetterGameState extends State<_LetterGame> {
  final math.Random random = math.Random();
  int target = 0;
  int score = 0;
  List<String> options = <String>[];

  @override
  void initState() {
    super.initState();
    newRound();
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
  }

  void newRound() {
    final choices = <String>{_letters[target]};
    while (choices.length < 4) {
      choices.add(_letters[random.nextInt(_letters.length)]);
    }
    options = choices.toList()..shuffle(random);
  }

  void speak() {
    VoiceService.arabic(_sounds[target]);
  }

  void answer(String value) {
    if (value != _letters[target]) {
      VoiceService.arabic('حاول مرة أخرى');
      return;
    }
    setState(() {
      score++;
      target = random.nextInt(_letters.length);
      newRound();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
  }

  @override
  Widget build(BuildContext context) {
    return _Page(
      'لعبة الحروف',
      [
        const Text('استمع إلى السؤال ثم اختر الحرف الصحيح', textAlign: TextAlign.center),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), speak),
        Text('النقاط: ${_ar(score)}'),
        Text(
          'السؤال: ${_ar(target + 1)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        for (final value in options)
          _Btn(value, const Color(0xFF7652FF), () => answer(value)),
      ],
    );
  }
}

class _NumberGame extends StatefulWidget {
  final int max;

  const _NumberGame({required this.max});

  @override
  State<_NumberGame> createState() => _NumberGameState();
}

class _NumberGameState extends State<_NumberGame> {
  final math.Random random = math.Random();
  int target = 1;
  int score = 0;
  List<int> options = <int>[];

  @override
  void initState() {
    super.initState();
    newRound();
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
  }

  void newRound() {
    final choices = <int>{target};
    while (choices.length < 4) {
      choices.add(random.nextInt(widget.max) + 1);
    }
    options = choices.toList()..shuffle(random);
  }

  void speak() {
    VoiceService.arabic(_ar(target));
  }

  void answer(int value) {
    if (value != target) {
      VoiceService.arabic('حاول مرة أخرى');
      return;
    }
    setState(() {
      score++;
      target = random.nextInt(widget.max) + 1;
      newRound();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
  }

  @override
  Widget build(BuildContext context) {
    return _Page(
      'لعبة الأرقام',
      [
        const Text('استمع إلى السؤال ثم اختر الرقم الصحيح', textAlign: TextAlign.center),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), speak),
        Text('النقاط: ${_ar(score)}'),
        Text(
          'السؤال: ${_ar(target)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        for (final value in options)
           _Btn(_ar(value), const Color(0xFF16B878), () => answer(value)),
      ],
    );
  }
