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
            _MenuItem('الأرقام', '١ إلى ٥٠ + الآحاد والعشرات', Icons.pin_rounded),
            _MenuItem('الكتابة', 'حروف وأرقام + لوحة كتابة', Icons.draw_rounded),
            _MenuItem('الألوان', 'ألوان ورسوم قابلة للتلوين', Icons.palette_rounded),
            _MenuItem('الأشكال', 'مربع ومثلث ودائرة ومستطيل وخماسي وسداسي', Icons.category_rounded),
            _MenuItem('القصص والألعاب', 'ألعاب تعليمية فعلية', Icons.auto_stories_rounded),
          ]
        : const <_MenuItem>[
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
              _MenuCard(
                item.title,
                item.subtitle,
                item.icon,
                () => _open(context, item.title),
              ),
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
      case 'الأرقام':
        page = _NumbersPage(kg2: kg2);
      case 'الكتابة':
        page = _WritingPage(kg2: kg2);
      case 'الألوان':
        page = _ColorsPage(kg2: kg2);
      case 'الأشكال':
        page = _ShapesPage(kg2: kg2);
      default:
        page = _GamesPage(kg2: kg2);
    }
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _MenuItem(this.title, this.subtitle, this.icon);
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard(this.title, this.subtitle, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF7652FF), Color(0xFF18A7E8)],
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
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

  const _Btn(this.text, this.color, this.onTap, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: .72) : color,
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

String _ar(int number) => number.toString().replaceAllMapped(
      RegExp(r'\d'),
      (match) => '٠١٢٣٤٥٦٧٨٩'[int.parse(match.group(0)!)],
    );

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

  void speak() => VoiceService.arabic(_sounds[index]);

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
        Row(
          children: [
            Expanded(
              child: _Btn(
                'السابق',
                const Color(0xFFE94F9B),
                index > 0 ? () => setState(() => index--) : () {},
              ),
            ),
            Expanded(
              child: _Btn(
                'التالي',
                const Color(0xFF16B878),
                index < 27 ? () => setState(() => index++) : () {},
              ),
            ),
          ],
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

class _WritingPage extends StatefulWidget {
  final bool kg2;

  const _WritingPage({required this.kg2});

  @override
  State<_WritingPage> createState() => _WritingState();
}

class _WritingState extends State<_WritingPage> {
  int tab = 0;
  int index = 0;
  List<List<Offset>> strokes = [];

  String get text => tab == 0 ? _letters[index] : _ar(index + 1);
  int get max => tab == 0 ? 28 : (widget.kg2 ? 50 : 10);

  void clear() => setState(() => strokes = []);

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
                    strokes = [];
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
                    strokes = [];
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
              Expanded(
                child: _Btn(
                  '🔊 اسمع',
                  const Color(0xFF16B878),
                  () => VoiceService.arabic(text),
                ),
              ),
              Expanded(
                child: _Btn(
                  'التالي',
                  const Color(0xFF16B878),
                  index < max - 1
                      ? () => setState(() {
                            index++;
                            strokes = [];
                          })
                      : () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
  List<Offset> current = [];

  void add(Offset point) {
    setState(() => current = [...current, point]);
  }

  void finish() {
    if (current.isEmpty) return;
    widget.onChanged([...widget.strokes, current]);
    setState(() => current = []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFBDBDBD), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (details) => add(details.localPosition),
        onPanUpdate: (details) => add(details.localPosition),
        onPanEnd: (_) => finish(),
        child: CustomPaint(
          painter: _StrokePainter(
            [...widget.strokes, if (current.isNotEmpty) current],
            widget.color,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  _StrokePainter(this.strokes, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 4, paint);
      } else if (stroke.length > 1) {
        final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
        for (final point in stroke.skip(1)) {
          path.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}

class _ColorsPage extends StatefulWidget {
  final bool kg2;

  const _ColorsPage({required this.kg2});

  @override
  State<_ColorsPage> createState() => _ColorsState();
}

class _ColorsState extends State<_ColorsPage> {
  int drawing = 0;
  Color selected = const Color(0xFFF44336);

  final colors = const [
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFFFFC107),
    Color(0xFF4CAF50),
    Color(0xFFFF8A00),
    Color(0xFF8E5CF6),
    Color(0xFF00AFA5),
  ];

  final names = const [
    'أحمر',
    'أزرق',
    'أصفر',
    'أخضر',
    'برتقالي',
    'بنفسجي',
    'تركوازي',
  ];

  late final List<String> drawings = widget.kg2
      ? ['قطة']
      : ['قطة', 'سمكة', 'فراشة'];

  List<Color> fills = List<Color>.filled(6, Colors.white);

  void choose(int index) {
    setState(() => selected = colors[index]);
    VoiceService.arabic(names[index]);
  }

  @override
  Widget build(BuildContext context) {
    return _FixedPage(
      'الألوان والتلوين',
      Column(
        children: [
          Text(
            'اختر اللون: ${names[colors.indexOf(selected)]}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                colors.length,
                (index) => GestureDetector(
                  onTap: () => choose(index),
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected == colors[index]
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            'لوّن ${drawings[drawing]}',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          Expanded(
            child: _ColoringCanvas(
              type: drawing,
              fills: fills,
              selected: selected,
              onChanged: (value) => setState(() => fills = value),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _Btn(
                  '🗑 مسح',
                  const Color(0xFFE94F4F),
                  () => setState(
                    () => fills = List<Color>.filled(6, Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: _Btn(
                  'التالي',
                  const Color(0xFF16B878),
                  drawing < drawings.length - 1
                      ? () => setState(() {
                            drawing++;
                            fills = List<Color>.filled(6, Colors.white);
                          })
                      : () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColoringCanvas extends StatelessWidget {
  final int type;
  final List<Color> fills;
  final Color selected;
  final ValueChanged<List<Color>> onChanged;

  const _ColoringCanvas({
    required this.type,
    required this.fills,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final size = constraints.biggest;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final region = _AnimalGeometry(type).hit(details.localPosition, size);
            if (region != null) {
              final next = [...fills];
              next[region] = selected;
              onChanged(next);
            }
          },
          child: CustomPaint(
            painter: _ColoringPainter(type, fills),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _AnimalGeometry {
  final int type;

  _AnimalGeometry(this.type);

  int? hit(Offset point, Size size) {
    final x = size.width / 2;
    final y = size.height / 2;

    if (type == 0) {
      if (Rect.fromCenter(
        center: Offset(x, y - 35),
        width: 125,
        height: 100,
      ).contains(point)) return 0;
      final ear = Path()
        ..moveTo(x - 55, y - 75)
        ..lineTo(x - 35, y - 135)
        ..lineTo(x - 5, y - 85)
        ..close();
      if (ear.contains(point)) return 1;
      if (Rect.fromCenter(
        center: Offset(x, y + 55),
        width: 210,
        height: 120,
      ).contains(point)) return 2;
    } else if (type == 1) {
      if (Rect.fromCenter(
        center: Offset(x, y),
        width: 230,
        height: 125,
      ).contains(point)) return 0;
      if (Rect.fromCenter(
        center: Offset(x + 125, y - 5),
        width: 75,
        height: 65,
      ).contains(point)) return 1;
      if (Rect.fromCenter(
        center: Offset(x - 120, y),
        width: 65,
        height: 45,
      ).contains(point)) return 2;
    } else {
      if (Rect.fromCenter(
        center: Offset(x, y),
        width: 110,
        height: 180,
      ).contains(point)) return 0;
      if (Rect.fromCenter(
        center: Offset(x - 70, y - 45),
        width: 90,
        height: 110,
      ).contains(point)) return 1;
      if (Rect.fromCenter(
        center: Offset(x + 70, y - 45),
        width: 90,
        height: 110,
      ).contains(point)) return 2;
    }
    return null;
  }
}

class _ColoringPainter extends CustomPainter {
  final int type;
  final List<Color> fills;

  _ColoringPainter(this.type, this.fills);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.black87;
    final x = size.width / 2;
    final y = size.height / 2;

    if (type == 0) {
      fill.color = fills[2];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y + 55), width: 210, height: 120),
        fill,
      );
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 35), width: 125, height: 100),
        fill,
      );
      fill.color = fills[1];
      final ear = Path()
        ..moveTo(x - 55, y - 75)
        ..lineTo(x - 35, y - 135)
        ..lineTo(x - 5, y - 85)
        ..close();
      canvas.drawPath(ear, fill);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y + 55), width: 210, height: 120),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 35), width: 125, height: 100),
        outline,
      );
      canvas.drawPath(ear, outline);
    } else if (type == 1) {
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 230, height: 125),
        fill,
      );
      fill.color = fills[1];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 125, y - 5), width: 75, height: 65),
        fill,
      );
      fill.color = fills[2];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 120, y), width: 65, height: 45),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 230, height: 125),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 125, y - 5), width: 75, height: 65),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 120, y), width: 65, height: 45),
        outline,
      );
    } else {
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 110, height: 180),
        fill,
      );
      fill.color = fills[1];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 70, y - 45), width: 90, height: 110),
        fill,
      );
      fill.color = fills[2];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 70, y - 45), width: 90, height: 110),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 110, height: 180),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x - 70, y - 45), width: 90, height: 110),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 70, y - 45), width: 90, height: 110),
        outline,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ColoringPainter oldDelegate) => true;
}

class _ShapesPage extends StatelessWidget {
  final bool kg2;

  const _ShapesPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    final names = kg2
        ? const ['مربع', 'مثلث', 'دائرة', 'مستطيل', 'خماسي', 'سداسي']
        : const ['مربع', 'مثلث', 'دائرة', 'مستطيل'];
    return _Page(
      'الأشكال',
      [
        for (final name in names)
          _Btn(
            name,
            const Color(0xFF7652FF),
            () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => _ShapeDrawPage(name: name),
              ),
            ),
          ),
      ],
    );
  }
}

class _ShapeDrawPage extends StatefulWidget {
  final String name;

  const _ShapeDrawPage({required this.name});

  @override
  State<_ShapeDrawPage> createState() => _ShapeDrawState();
}

class _ShapeDrawState extends State<_ShapeDrawPage> {
  List<List<Offset>> strokes = [];

  void undo() {
    if (strokes.isNotEmpty) setState(() => strokes.removeLast());
  }

  void clear() => setState(() => strokes = []);

  @override
  Widget build(BuildContext context) {
    return _FixedPage(
      'رسم ${widget.name}',
      Column(
        children: [
          Text(
            'ارسم ${widget.name} داخل المساحة',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
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
        ],
      ),
    );
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
          const Color(0xFFE94F9B),
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
            MaterialPageRoute<void>(
              builder: (_) => _NumberGame(max: kg2 ? 50 : 20),
            ),
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
  final random = math.Random();
  int target = 0;
  int score = 0;
  List<String> options = [];

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

  void speak() => VoiceService.arabic(_sounds[target]);

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
        const Text('استمع ثم اختر الحرف الصحيح', textAlign: TextAlign.center),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), speak),
        Text('النقاط: ${_ar(score)}'),
        for (final value in options)
          _Btn(
            value,
            const Color(0xFF7652FF),
            () => answer(value),
          ),
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
  final random = math.Random();
  int target = 1;
  int score = 0;
  List<int> options = [];

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

  void speak() => VoiceService.arabic(_ar(target));

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
        const Text('استمع ثم اختر الرقم الصحيح', textAlign: TextAlign.center),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), speak),
        Text('النقاط: ${_ar(score)}'),
        for (final value in options)
          _Btn(
            _ar(value),
            const Color(0xFF16B878),
            () => answer(value),
          ),
      ],
    );
  }
