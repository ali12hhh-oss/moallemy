import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/audio/voice_service.dart';

class KindergartenStageScreenV4 extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreenV4({super.key, required this.stageId});

  bool get kg2 => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> items = kg2
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

    final List<Widget> children = <Widget>[];
    for (final _MenuItem item in items) {
      children.add(_MenuCard(
        item.title,
        item.subtitle,
        item.icon,
        () => _open(context, item.title),
      ));
      children.add(const SizedBox(height: 12));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: children,
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    late final Widget page;
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
            children: <Widget>[
              Icon(icon, color: Colors.white, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
            padding: const EdgeInsets.all(12),
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
        color: selected ? color.withValues(alpha: 0.72) : color,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
    (Match match) => '٠١٢٣٤٥٦٧٨٩'[int.parse(match.group(0)!)],
  );
}

const List<String> _letters = <String>[
  'ا', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
  'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'ه', 'و', 'ي',
];

const List<String> _sounds = <String>[
  'أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص',
  'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هـ', 'و', 'ي',
];

const List<List<String>> _forms = <List<String>>[
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
    final String shown = widget.kg2 ? _forms[index][form] : _letters[index];
    final List<Widget> children = <Widget>[
      Text('${_ar(index + 1)} من ٢٨', textAlign: TextAlign.center),
      Text(
        shown,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 105, fontWeight: FontWeight.w900),
      ),
      Text('صوت القراءة: ${_sounds[index]}', textAlign: TextAlign.center),
      _Btn('🔊 نطق الحرف', const Color(0xFF18A7E8), speak),
    ];

    if (widget.kg2) {
      children.add(
        Row(
          children: List<Widget>.generate(
            3,
            (int i) => Expanded(
              child: _Btn(
                <String>['أولي', 'وسطي', 'آخري'][i],
                const Color(0xFF7652FF),
                () => setState(() => form = i),
                selected: form == i,
              ),
            ),
          ),
        ),
      );
    }

    children.add(
      Row(
        children: <Widget>[
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
    );

    return _Page('الحروف العربية', children);
  }
}

class _NumbersPage extends StatelessWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    final int count = kg2 ? 50 : 10;
    return _Page(
      'الأرقام',
      <Widget>[
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: count,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (BuildContext _, int index) {
            final String value = _ar(index + 1);
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
  Color ink = Colors.black;

  @override
  Widget build(BuildContext context) {
    final String text = tab == 0 ? _letters[index] : _ar(index + 1);
    final int max = tab == 0 ? 28 : (widget.kg2 ? 50 : 10);

    return _FixedPage(
      'الكتابة',
      Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _Btn(
                  'الحروف',
                  const Color(0xFF7652FF),
                  () => setState(() {
                    tab = 0;
                    index = 0;
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
                  }),
                  selected: tab == 1,
                ),
              ),
            ],
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w900),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: CustomPaint(
                painter: _BoardPainter(ink),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(child: _Btn('↩ تراجع', const Color(0xFF7652FF), () {})),
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
                  index < max - 1 ? () => setState(() => index++) : () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  final Color color;
  _BoardPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.color != color;
  }
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

  static const List<Color> colors = <Color>[
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFFFFC107),
    Color(0xFF4CAF50),
    Color(0xFFFF8A00),
    Color(0xFF8E5CF6),
    Color(0xFF00AFA5),
  ];

  static const List<String> names = <String>[
    'أحمر', 'أزرق', 'أصفر', 'أخضر', 'برتقالي', 'بنفسجي', 'تركوازي',
  ];

  late final List<String> drawings = widget.kg2
      ? <String>['قطة']
      : <String>['قطة', 'سمكة', 'فراشة'];

  List<Color> fills = List<Color>.filled(6, Colors.white);

  @override
  Widget build(BuildContext context) {
    final int colorIndex = colors.indexOf(selected);
    return _Page(
      'الألوان والتلوين',
      <Widget>[
        Text(
          'اختر اللون: ${names[colorIndex]}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: List<Widget>.generate(
            colors.length,
            (int i) => GestureDetector(
              onTap: () {
                setState(() => selected = colors[i]);
                VoiceService.arabic(names[i]);
              },
              child: Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == colors[i]
                        ? Colors.black
                        : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text('لوّن ${drawings[drawing]}', textAlign: TextAlign.center),
        CustomPaint(
          painter: _AnimalPainter(drawing, fills),
          child: const SizedBox(height: 330, width: double.infinity),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _Btn(
                '↩ مسح',
                const Color(0xFF7652FF),
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
                    ? () => setState(() => drawing++)
                    : () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimalPainter extends CustomPainter {
  final int type;
  final List<Color> fills;
  _AnimalPainter(this.type, this.fills);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fill = Paint()..style = PaintingStyle.fill;
    final Paint outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = Colors.black87;
    final double x = size.width / 2;
    final double y = size.height / 2;

    if (type == 0) {
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y + 35), width: 210, height: 125),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 50), width: 135, height: 110),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y + 35), width: 210, height: 125),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y - 50), width: 135, height: 110),
        outline,
      );
    } else if (type == 1) {
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 250, height: 130),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 135, y - 5), width: 75, height: 65),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 250, height: 130),
        outline,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x + 135, y - 5), width: 75, height: 65),
        outline,
      );
    } else {
      fill.color = fills[0];
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 120, height: 190),
        fill,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 120, height: 190),
        outline,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter oldDelegate) => true;
}

class _ShapesPage extends StatelessWidget {
  final bool kg2;
  const _ShapesPage({required this.kg2});

  @override
  Widget build(BuildContext context) {
    final List<String> names = kg2
        ? <String>['مربع', 'مثلث', 'دائرة', 'مستطيل', 'خماسي', 'سداسي']
        : <String>['مربع', 'مثلث', 'دائرة', 'مستطيل'];

    return _Page(
      'الأشكال',
      names.map((String name) {
        return _Btn(
          name,
          const Color(0xFF7652FF),
          () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => _Page(
                'رسم $name',
                <Widget>[
                  _Btn('تراجع', const Color(0xFF7652FF), () {}),
                  const SizedBox(height: 20),
                  const SizedBox(height: 300),
                  const Text('ارسم الشكل داخل المساحة البيضاء'),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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
      <Widget>[
        _Btn(
          '🔤 لعبة الحروف',
          const Color(0xFFE94F9B),
          () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const _LetterGame()),
          ),
        ),
        const SizedBox(height: 10),
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
  final math.Random random = math.Random();
  int target = 0;
  int score = 0;
  List<String> options = <String>[];

  @override
  void initState() {
    super.initState();
    _newRound();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  void _newRound() {
    final Set<String> values = <String>{_letters[target]};
    while (values.length < 4) {
      values.add(_letters[random.nextInt(_letters.length)]);
    }
    options = values.toList()..shuffle(random);
  }

  void _speak() => VoiceService.arabic(_sounds[target]);

  void _answer(String value) {
    if (value != _letters[target]) {
      VoiceService.arabic('حاول مرة أخرى');
      return;
    }
    setState(() {
      score++;
      target = random.nextInt(_letters.length);
      _newRound();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  Widget build(BuildContext context) {
    return _Page(
      'لعبة الحروف',
      <Widget>[
        const Text('استمع ثم اختر الحرف الصحيح', textAlign: TextAlign.center),
        const SizedBox(height: 10),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), _speak),
        Text('النقاط: ${_ar(score)}'),
        ...options.map(
          (String value) => _Btn(
            value,
            const Color(0xFF7652FF),
            () => _answer(value),
          ),
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
  final math.Random random = math.Random();
  int target = 1;
  int score = 0;
  List<int> options = <int>[];

  @override
  void initState() {
    super.initState();
    _newRound();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  void _newRound() {
    final Set<int> values = <int>{target};
    while (values.length < 4) {
      values.add(random.nextInt(widget.max) + 1);
    }
    options = values.toList()..shuffle(random);
  }

  void _speak() => VoiceService.arabic(_ar(target));

  void _answer(int value) {
    if (value != target) {
      VoiceService.arabic('حاول مرة أخرى');
      return;
    }
    setState(() {
      score++;
      target = random.nextInt(widget.max) + 1;
      _newRound();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _speak());
  }

  @override
  Widget build(BuildContext context) {
    return _Page(
      'لعبة الأرقام',
      <Widget>[
        const Text('استمع ثم اختر الرقم الصحيح', textAlign: TextAlign.center),
        const SizedBox(height: 10),
        _Btn('🔊 نطق السؤال', const Color(0xFF18A7E8), _speak),
        Text('النقاط: ${_ar(score)}'),
        ...options.map(
          (int value) => _Btn(
            _ar(value),
            const Color(0xFF16B878),
            () => _answer(value),
          ),
        ),
      ],
    );
  }
}
