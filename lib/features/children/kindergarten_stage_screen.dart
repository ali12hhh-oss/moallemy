import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../data/content.dart';
import '../../widgets/app_feedback.dart';

class KindergartenStageScreen extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreen({super.key, required this.stageId});

  bool get kg2 => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final sections = kg2
        ? <_Section>[
            const _Section('الحروف', 'أولي ووسطي وأخري مع النطق', Icons.abc_rounded, Color(0xFF7652FF)),
            const _Section('الأرقام', '١ إلى ٥٠ ومراتب الأعداد', Icons.pin_rounded, Color(0xFF0097A7)),
            const _Section('كتابة الحروف والأعداد', 'أشكال الحروف والدمج والكتابة', Icons.draw_rounded, Color(0xFF00A86B)),
            const _Section('الألوان', 'تعلم الألوان بطريقة جذابة', Icons.palette_rounded, Color(0xFFFF7A45)),
            const _Section('الأشكال', 'الأشكال الأساسية والمزيد', Icons.category_rounded, Color(0xFFE83E8C)),
            const _Section('القصص والألعاب', 'قصص مسموعة وأربع ألعاب تعليمية', Icons.auto_stories_rounded, Color(0xFFFFB300)),
          ]
        : <_Section>[
            const _Section('الحروف', '٢٨ حرفًا عربيًا مع الصوت والاسم والكلمة', Icons.abc_rounded, Color(0xFF7652FF)),
            const _Section('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded, Color(0xFF0097A7)),
            const _Section('كتابة الحروف والأرقام', 'اكتب على الشاشة واختر لونك', Icons.draw_rounded, Color(0xFF00A86B)),
            const _Section('الألوان', 'جميع الألوان مع أمثلة حيوانات وأشياء', Icons.palette_rounded, Color(0xFFFF7A45)),
            const _Section('الأشكال', 'مربع ومثلث ودائرة ومستطيل ومنحرف وشبه منحرف', Icons.category_rounded, Color(0xFFE83E8C)),
            const _Section('الألعاب', 'لعبة للحروف ولعبة للأرقام', Icons.sports_esports_rounded, Color(0xFFFFB300)),
          ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            for (final section in sections) ...<Widget>[
              App3DCard(
                onTap: () => _open(context, section.title),
                encouragement: '✨ ${section.title} ممتع!',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[section.color, section.color.withValues(alpha: .72)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(children: <Widget>[
                    Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .22), borderRadius: BorderRadius.circular(18)), child: Icon(section.icon, color: Colors.white, size: 34)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Text(section.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(section.subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ])),
                    const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    late final Widget page;
    switch (title) {
      case 'الحروف': page = _LettersPage(kg2: kg2); break;
      case 'الأرقام': page = _NumbersPage(kg2: kg2); break;
      case 'كتابة الحروف والأرقام': page = _WritingHubPage(kg2: kg2); break;
      case 'الألوان': page = _ColorsPage(kg2: kg2); break;
      case 'الأشكال': page = _ShapesPage(kg2: kg2); break;
      case 'الألعاب': page = const _GamesPage(kg2: false); break;
      default: page = const _StoriesGamesPage();
    }
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _Section {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Section(this.title, this.subtitle, this.icon, this.color);
}

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override State<_LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<_LettersPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[index];
    final forms = _forms(item.letter);
    return _PageScaffold(
      title: widget.kg2 ? 'الحروف وأشكالها' : 'الحروف العربية',
      children: <Widget>[
        Text('الحرف ${arNum(index + 1)} من ${arNum(28)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 12),
        if (widget.kg2) _FormsCard(item: item, forms: forms) else _LetterCard(item: item),
        const SizedBox(height: 12),
        App3DCard(
          onTap: () => VoiceService.arabic(item.word),
          encouragement: '🗣️ اسمع الكلمة وكررها',
          child: ListTile(leading: Text(item.emoji, style: const TextStyle(fontSize: 38)), title: Text(item.word, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)), subtitle: Text('كلمة تبدأ بحرف ${item.letter}'), trailing: const Icon(Icons.volume_up_rounded)),
        ),
        const SizedBox(height: 14),
        Row(children: <Widget>[
          Expanded(child: _ActionButton(text: 'السابق', color: const Color(0xFFE83E8C), onTap: index > 0 ? () => setState(() => index--) : null)),
          const SizedBox(width: 10),
          Expanded(child: _ActionButton(text: 'التالي', color: const Color(0xFF00A86B), onTap: index < 27 ? () => setState(() => index++) : null)),
        ]),
      ],
    );
  }
}

class _LetterCard extends StatelessWidget {
  final ArabicLetter item;
  const _LetterCard({required this.item});
  @override
  Widget build(BuildContext context) => App3DCard(
    onTap: () => VoiceService.arabicLetterSound(item.letter, fallbackText: item.sound),
    encouragement: '🔊 هذا صوت الحرف عند القراءة',
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: <Color>[Color(0xFF7652FF), Color(0xFF536DFE)]), borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Column(children: <Widget>[
        Text(item.letter, style: const TextStyle(color: Colors.white, fontSize: 105, fontWeight: FontWeight.w900)),
        Text('صوت الحرف: ${item.sound}', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        OutlinedButton.icon(onPressed: () => VoiceService.arabic(item.letter), icon: const Icon(Icons.badge_outlined, color: Colors.white), label: const Text('اسم الحرف', style: TextStyle(color: Colors.white))),
      ]),
    ),
  );
}

class _FormsCard extends StatelessWidget {
  final ArabicLetter item;
  final List<String> forms;
  const _FormsCard({required this.item, required this.forms});
  @override
  Widget build(BuildContext context) => App3DCard(
    onTap: () => VoiceService.arabicLetterSound(item.letter, fallbackText: item.sound),
    encouragement: '🔊 استمع للحرف وشاهد أشكاله',
    child: Padding(padding: const EdgeInsets.all(16), child: Column(children: <Widget>[
      Text(item.letter, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900)),
      Row(children: List<Widget>.generate(3, (i) => Expanded(child: Container(margin: EdgeInsets.only(left: i == 0 ? 0 : 5), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: const Color(0xFF7652FF).withValues(alpha: .12), borderRadius: BorderRadius.circular(16)), child: Column(children: <Widget>[Text(forms[i], style: const TextStyle(fontSize: 39, fontWeight: FontWeight.w900)), Text(<String>['أولي', 'وسطي', 'أخري'][i])]))))),
    ])),
  );
}

List<String> _forms(String letter) {
  const connected = <String>{'ب','ت','ث','ج','ح','خ','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','ي'};
  if (!connected.contains(letter)) return <String>[letter, letter, letter];
  return <String>['$letterـ', 'ـ$letterـ', 'ـ$letter'];
}

class _NumbersPage extends StatelessWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    if (!kg2) return const _NumberGrid(max: 10, title: 'الأرقام من ١ إلى ١٠');
    return _PageScaffold(title: 'الأرقام', children: <Widget>[
      _MenuCard(title: 'الأعداد من ١ إلى ٥٠', icon: Icons.pin_rounded, color: const Color(0xFF0097A7), onTap: () => _push(context, const _NumberGrid(max: 50, title: 'الأعداد من ١ إلى ٥٠'))),
      _MenuCard(title: 'مراتب الأعداد', icon: Icons.account_tree_rounded, color: const Color(0xFF7652FF), onTap: () => _push(context, const _PlaceValuePage())),
    ]);
  }
}

class _NumberGrid extends StatelessWidget {
  final int max;
  final String title;
  const _NumberGrid({required this.max, required this.title});
  @override
  Widget build(BuildContext context) => _PageScaffold(
    title: title,
    children: <Widget>[
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: max, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10), itemBuilder: (_, i) {
        final n = i + 1;
        return App3DCard(onTap: () => VoiceService.arabic(arNum(n)), encouragement: '🔊 ${arNum(n)}', child: Container(decoration: const BoxDecoration(color: Color(0xFF0097A7), borderRadius: BorderRadius.all(Radius.circular(20))), child: Center(child: Text(arNum(n), style: const TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.w900)))));
      }),
    ],
  );
}

class _PlaceValuePage extends StatefulWidget {
  const _PlaceValuePage();
  @override State<_PlaceValuePage> createState() => _PlaceValuePageState();
}
class _PlaceValuePageState extends State<_PlaceValuePage> {
  int number = 24;
  String selected = 'العشرات';
  @override
  Widget build(BuildContext context) {
    final tens = number ~/ 10;
    final ones = number % 10;
    return _PageScaffold(title: 'مراتب الأعداد', children: <Widget>[
      const Text('درس تعليمي: نحدد قيمة الرقم في العدد، وليس اختبارًا.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
      const SizedBox(height: 14),
      App3DCard(onTap: () => VoiceService.arabic(arNum(number)), child: Padding(padding: const EdgeInsets.all(20), child: Center(child: Text(arNum(number), style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900))))),
      const SizedBox(height: 14),
      Row(children: <Widget>[
        Expanded(child: _PlaceCard(title: 'العشرات', value: tens, active: selected == 'العشرات', onTap: () => setState(() => selected = 'العشرات'))),
        const SizedBox(width: 10),
        Expanded(child: _PlaceCard(title: 'الآحاد', value: ones, active: selected == 'الآحاد', onTap: () => setState(() => selected = 'الآحاد'))),
      ]),
      const SizedBox(height: 12),
      Text('أنت تتعلم الآن: $selected', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
      Slider(value: number.toDouble(), min: 10, max: 50, divisions: 40, label: arNum(number), onChanged: (v) => setState(() => number = v.round())),
    ]);
  }
}

class _PlaceCard extends StatelessWidget {
  final String title;
  final int value;
  final bool active;
  final VoidCallback onTap;
  const _PlaceCard({required this.title, required this.value, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => App3DCard(onTap: onTap, encouragement: '🌟 هذه مرتبة $title', child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: active ? const Color(0xFF7652FF).withValues(alpha: .16) : Colors.transparent, borderRadius: BorderRadius.circular(18)), child: Column(children: <Widget>[Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(arNum(value), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900))])));
}

class _WritingHubPage extends StatelessWidget {
  final bool kg2;
  const _WritingHubPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _PageScaffold(title: 'كتابة الحروف والأرقام', children: <Widget>[
    _MenuCard(title: kg2 ? 'الحروف: أولي ووسطي وأخري + دمج' : 'جميع الحروف العربية', icon: Icons.edit_rounded, color: const Color(0xFF00A86B), onTap: () => _push(context, _LetterWritingPage(kg2: kg2))),
    _MenuCard(title: kg2 ? 'الأرقام من ١ إلى ٥٠' : 'الأرقام من ١ إلى ١٠', icon: Icons.numbers_rounded, color: const Color(0xFF0097A7), onTap: () => _push(context, _NumberWritingPage(kg2: kg2))),
  ]);
}

class _LetterWritingPage extends StatefulWidget {
  final bool kg2;
  const _LetterWritingPage({required this.kg2});
  @override State<_LetterWritingPage> createState() => _LetterWritingPageState();
}
class _LetterWritingPageState extends State<_LetterWritingPage> {
  int index = 0;
  Color ink = const Color(0xFF3F51B5);
  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[index];
    final forms = _forms(item.letter);
    final guide = widget.kg2 ? forms[index % 3] : item.letter;
    return _PageScaffold(title: 'الكتابة على الشاشة', children: <Widget>[
      Text('اكتب: $guide', textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _WritingBoard(guide: guide, color: ink, onColorChanged: (c) => setState(() => ink = c)),
      const SizedBox(height: 12),
      if (widget.kg2) _MergeCard(index: index),
      const SizedBox(height: 12),
      Row(children: <Widget>[
        Expanded(child: _ActionButton(text: 'السابق', color: const Color(0xFFE83E8C), onTap: index > 0 ? () => setState(() => index--) : null)),
        const SizedBox(width: 8),
        Expanded(child: _ActionButton(text: 'اسمع', color: const Color(0xFF7652FF), onTap: () => VoiceService.arabicLetterSound(item.letter, fallbackText: item.sound))),
        const SizedBox(width: 8),
        Expanded(child: _ActionButton(text: 'التالي', color: const Color(0xFF00A86B), onTap: index < 27 ? () => setState(() => index++) : null)),
      ]),
    ]);
  }
}

class _MergeCard extends StatelessWidget {
  final int index;
  const _MergeCard({required this.index});
  @override
  Widget build(BuildContext context) {
    const pairs = <List<String>>[['د','ا'],['د','و'],['ن','ا'],['د','ي'],['ب','ا'],['ب','و'],['م','ا'],['م','ي'],['س','ا'],['ل','ا'],['ك','ا'],['ف','ا'],['ر','ا'],['ش','ا'],['ت','ا'],['ج','ا'],['ح','ا'],['خ','ا'],['ق','ا'],['ع','ا']];
    final p = pairs[index % pairs.length];
    final result = p.join();
    return App3DCard(onTap: () => VoiceService.arabic(result), encouragement: '🌟 ممتاز! ادمج الحرفين', child: Padding(padding: const EdgeInsets.all(16), child: Column(children: <Widget>[const Text('دمج حرفين', style: TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text('${p[0]} + ${p[1]} = $result', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900))])));
  }
}

class _NumberWritingPage extends StatefulWidget {
  final bool kg2;
  const _NumberWritingPage({required this.kg2});
  @override State<_NumberWritingPage> createState() => _NumberWritingPageState();
}
class _NumberWritingPageState extends State<_NumberWritingPage> {
  int index = 0;
  Color ink = const Color(0xFFE85D04);
  @override
  Widget build(BuildContext context) {
    final max = widget.kg2 ? 50 : 10;
    final number = index + 1;
    return _PageScaffold(title: 'كتابة الأرقام', children: <Widget>[
      Text('اكتب الرقم: ${arNum(number)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _WritingBoard(guide: arNum(number), color: ink, onColorChanged: (c) => setState(() => ink = c)),
      const SizedBox(height: 12),
      if (widget.kg2) const _NumberValueHint(),
      const SizedBox(height: 12),
      Row(children: <Widget>[
        Expanded(child: _ActionButton(text: 'مسح وابدأ', color: const Color(0xFFE83E8C), onTap: () => AppFeedback.show('✏️ اكتب باللون الذي اخترته'))),
        const SizedBox(width: 8),
        Expanded(child: _ActionButton(text: 'اسمع الرقم', color: const Color(0xFF7652FF), onTap: () => VoiceService.arabic(arNum(number)))),
        const SizedBox(width: 8),
        Expanded(child: _ActionButton(text: 'التالي', color: const Color(0xFF00A86B), onTap: index < max - 1 ? () => setState(() => index++) : null)),
      ]),
    ]);
  }
}

class _NumberValueHint extends StatelessWidget {
  const _NumberValueHint();
  @override
  Widget build(BuildContext context) => App3DCard(onTap: () => _push(context, const _PlaceValuePage()), encouragement: '🌟 تعلم القيمة المكانية', child: const Padding(padding: EdgeInsets.all(14), child: Text('تستطيع الانتقال إلى درس الآحاد والعشرات لمعرفة قيمة الرقم داخل العدد.', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700))));
}

class _WritingBoard extends StatefulWidget {
  final String guide;
  final Color color;
  final ValueChanged<Color> onColorChanged;
  const _WritingBoard({required this.guide, required this.color, required this.onColorChanged});
  @override State<_WritingBoard> createState() => _WritingBoardState();
}
class _WritingBoardState extends State<_WritingBoard> {
  final List<List<Offset>> strokes = <List<Offset>>[];
  List<Offset> current = <Offset>[];
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 280,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: widget.color, width: 3), boxShadow: const <BoxShadow>[BoxShadow(blurRadius: 10, offset: Offset(0, 5), color: Color(0x22000000))]),
        child: GestureDetector(
          onPanStart: (d) => setState(() => current = <Offset>[d.localPosition]),
          onPanUpdate: (d) => setState(() => current = <Offset>[...current, d.localPosition]),
          onPanEnd: (_) { if (current.length > 1) strokes.add(current); setState(() => current = <Offset>[]); },
          child: CustomPaint(painter: _BoardPainter(guide: widget.guide, color: widget.color, strokes: strokes, current: current), child: const SizedBox.expand()),
        ),
      ),
      const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Text('لون الكتابة: ', style: TextStyle(fontWeight: FontWeight.w900)),
        for (final color in <Color>[Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.pink])
          GestureDetector(onTap: () => widget.onColorChanged(color), child: Container(width: 30, height: 30, margin: const EdgeInsets.symmetric(horizontal: 3), decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: widget.color == color ? Colors.white : Colors.transparent, width: 3)))),
      ]),
    ]);
  }
}
class _BoardPainter extends CustomPainter {
  final String guide;
  final Color color;
  final List<List<Offset>> strokes;
  final List<Offset> current;
  const _BoardPainter({required this.guide, required this.color, required this.strokes, required this.current});
  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(text: TextSpan(text: guide, style: TextStyle(fontSize: 190, fontWeight: FontWeight.w900, color: color.withValues(alpha: .13))), textDirection: TextDirection.rtl)..layout(maxWidth: size.width);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
    final p = Paint()..color = color..strokeWidth = 8..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    void draw(List<Offset> points) { if (points.length < 2) return; final path = Path()..moveTo(points.first.dx, points.first.dy); for (final point in points.skip(1)) { path.lineTo(point.dx, point.dy); } canvas.drawPath(path, p); }
    for (final stroke in strokes) { draw(stroke); }
    draw(current);
  }
  @override bool shouldRepaint(covariant _BoardPainter old) => true;
}

class _ColorsPage extends StatelessWidget {
  final bool kg2;
  const _ColorsPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    const items = <_ColorItem>[
      _ColorItem('أبيض', Color(0xFFF5F5F5), 'حمامة بيضاء', '🕊️'), _ColorItem('أسود', Color(0xFF222222), 'غراب أسود', '🐦'),
      _ColorItem('أحمر', Color(0xFFE53935), 'تفاحة حمراء', '🍎'), _ColorItem('أزرق', Color(0xFF1E88E5), 'سمكة زرقاء', '🐟'),
      _ColorItem('أخضر', Color(0xFF43A047), 'ضفدع أخضر', '🐸'), _ColorItem('أصفر', Color(0xFFFDD835), 'نحلة صفراء', '🐝'),
      _ColorItem('برتقالي', Color(0xFFFB8C00), 'برتقالة برتقالية', '🍊'), _ColorItem('بنفسجي', Color(0xFF8E24AA), 'فراشة بنفسجية', '🦋'),
      _ColorItem('وردي', Color(0xFFD81B60), 'زهرة وردية', '🌸'), _ColorItem('بني', Color(0xFF795548), 'دب بني', '🐻'),
      _ColorItem('رمادي', Color(0xFF757575), 'فيل رمادي', '🐘'), _ColorItem('سماوي', Color(0xFF00ACC1), 'طائر سماوي', '🐦'),
    ];
    return _PageScaffold(title: 'الألوان', children: <Widget>[
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: items.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .92), itemBuilder: (_, i) {
        final item = items[i]; final light = item.color.computeLuminance() > .55;
        return App3DCard(onTap: () => VoiceService.arabic(item.name), encouragement: '🎨 ${item.name}', child: Container(decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(22)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text(item.emoji, style: const TextStyle(fontSize: 42)), const SizedBox(height: 6), Text(item.name, style: TextStyle(color: light ? Colors.black87 : Colors.white, fontSize: 20, fontWeight: FontWeight.w900)), Text(item.example, style: TextStyle(color: light ? Colors.black87 : Colors.white, fontWeight: FontWeight.w700))])));
      }),
      const SizedBox(height: 12),
      Text(kg2 ? '🌟 تعرّف على اللون ثم اسمع اسمه' : '🌟 تعرّف على اللون واسمه ومثاله', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
    ]);
  }
}
class _ColorItem {
  final String name, example, emoji; final Color color;
  const _ColorItem(this.name, this.color, this.example, this.emoji);
}

class _ShapesPage extends StatelessWidget {
  final bool kg2;
  const _ShapesPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    final names = kg2 ? <String>['مربع','مثلث','دائرة','مستطيل','منحرف','شبه منحرف','خماسي','سداسي','ثماني','بيضاوي'] : <String>['مربع','مثلث','دائرة','مستطيل','منحرف','شبه منحرف'];
    final icons = <IconData>[Icons.crop_square_rounded, Icons.change_history_rounded, Icons.circle_outlined, Icons.rectangle_outlined, Icons.hexagon_outlined, Icons.pentagon_outlined, Icons.pentagon_rounded, Icons.hexagon_rounded, Icons.stop_rounded, Icons.egg_alt_outlined];
    return _PageScaffold(title: 'الأشكال', children: <Widget>[
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: names.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12), itemBuilder: (_, i) { final c = Colors.primaries[i % Colors.primaries.length]; return App3DCard(onTap: () => VoiceService.arabic(names[i]), encouragement: '🔷 ${names[i]}', child: Container(decoration: BoxDecoration(color: c.withValues(alpha: .14), borderRadius: BorderRadius.circular(22)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(icons[i], color: c, size: 62), const SizedBox(height: 8), Text(names[i], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))]))); }),
    ]);
  }
}

class _GamesPage extends StatelessWidget {
  final bool kg2;
  const _GamesPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _PageScaffold(title: 'الألعاب', children: <Widget>[
    _MenuCard(title: 'لعبة الحروف', icon: Icons.abc_rounded, color: const Color(0xFF7652FF), onTap: () => _push(context, const _LetterGame())),
    _MenuCard(title: 'لعبة الأرقام', icon: Icons.numbers_rounded, color: const Color(0xFF0097A7), onTap: () => _push(context, const _NumberGame())),
  ]);
}

class _StoriesGamesPage extends StatelessWidget {
  const _StoriesGamesPage();
  @override
  Widget build(BuildContext context) => _PageScaffold(title: 'القصص والألعاب', children: <Widget>[
    _MenuCard(title: 'قصتان تعليميتان', icon: Icons.menu_book_rounded, color: const Color(0xFFE83E8C), onTap: () => _push(context, const _StoriesPage())),
    _MenuCard(title: 'ألعاب الحروف ودمج حرفين', icon: Icons.extension_rounded, color: const Color(0xFF7652FF), onTap: () => _push(context, const _MergeGame())),
    _MenuCard(title: 'لعبة الآحاد', icon: Icons.looks_one_rounded, color: const Color(0xFF00A86B), onTap: () => _push(context, const _PlaceGame(tens: false))),
    _MenuCard(title: 'لعبة العشرات', icon: Icons.looks_two_rounded, color: const Color(0xFF0097A7), onTap: () => _push(context, const _PlaceGame(tens: true))),
  ]);
}

class _LetterGame extends StatefulWidget { const _LetterGame(); @override State<_LetterGame> createState() => _LetterGameState(); }
class _LetterGameState extends State<_LetterGame> {
  int index = 0;
  void answer(String value) { if (value == arabicLetters[index].letter) { AppFeedback.show('🌟 أحسنت! إجابة صحيحة'); setState(() => index = (index + 1) % 28); } else { AppFeedback.show('💪 حاول مرة أخرى! لا ننتقل قبل النجاح'); } }
  @override Widget build(BuildContext context) { final item = arabicLetters[index]; final options = <String>[item.letter, arabicLetters[(index + 1) % 28].letter, arabicLetters[(index + 7) % 28].letter]..shuffle(); return _PageScaffold(title: 'لعبة الحروف', children: <Widget>[const Text('اسمع ثم اختر الحرف الصحيح', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12), _ActionButton(text: '🔊 استمع', color: const Color(0xFF7652FF), onTap: () => VoiceService.arabicLetterSound(item.letter, fallbackText: item.sound)), for (final option in options) Padding(padding: const EdgeInsets.only(top: 10), child: _ActionButton(text: option, color: const Color(0xFF0097A7), onTap: () => answer(option))) ]); }
}

class _NumberGame extends StatefulWidget { const _NumberGame(); @override State<_NumberGame> createState() => _NumberGameState(); }
class _NumberGameState extends State<_NumberGame> {
  int target = 1;
  void answer(int value) { if (value == target) { AppFeedback.show('🌟 بطل! الرقم صحيح'); setState(() => target = target == 10 ? 1 : target + 1); } else { AppFeedback.show('💪 أعد المحاولة حتى تنجح'); } }
  @override Widget build(BuildContext context) { final options = <int>[target, target == 10 ? 1 : target + 1, target > 2 ? target - 2 : 8]..shuffle(); return _PageScaffold(title: 'لعبة الأرقام', children: <Widget>[const Text('استمع ثم اختر الرقم الصحيح', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12), _ActionButton(text: '🔊 استمع', color: const Color(0xFF0097A7), onTap: () => VoiceService.arabic(arNum(target))), for (final n in options) Padding(padding: const EdgeInsets.only(top: 10), child: _ActionButton(text: arNum(n), color: const Color(0xFF00A86B), onTap: () => answer(n))) ]); }
}

class _MergeGame extends StatefulWidget { const _MergeGame(); @override State<_MergeGame> createState() => _MergeGameState(); }
class _MergeGameState extends State<_MergeGame> {
  int index = 0;
  static const pairs = <List<String>>[['د','ا'],['د','و'],['ن','ا'],['د','ي'],['ب','ا'],['ب','و'],['م','ا'],['م','ي'],['س','ا'],['ل','ا'],['ك','ا'],['ف','ا'],['ر','ا'],['ش','ا'],['ت','ا'],['ج','ا'],['ح','ا'],['خ','ا'],['ق','ا'],['ع','ا']];
  @override Widget build(BuildContext context) { final p = pairs[index]; final result = p.join(); return _PageScaffold(title: 'دمج حرفين', children: <Widget>[App3DCard(onTap: () => VoiceService.arabic(result), encouragement: '🌟 ممتاز! استمع وكرر', child: Padding(padding: const EdgeInsets.all(24), child: Column(children: <Widget>[Text('${p[0]} + ${p[1]}', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text(result, style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w900)), const SizedBox(height: 12), _ActionButton(text: 'التالي', color: const Color(0xFF00A86B), onTap: () => setState(() => index = (index + 1) % pairs.length))])))]); }
}

class _PlaceGame extends StatefulWidget { final bool tens; const _PlaceGame({required this.tens}); @override State<_PlaceGame> createState() => _PlaceGameState(); }
class _PlaceGameState extends State<_PlaceGame> {
  int number = 24;
  void answer(String value) { final correct = widget.tens ? 'العشرات' : 'الآحاد'; if (value == correct) { AppFeedback.show('🌟 صحيح! أحسنت'); setState(() => number = number == 50 ? 10 : number + 1); } else { AppFeedback.show('💪 حاول مرة أخرى'); } }
  @override Widget build(BuildContext context) { final digit = widget.tens ? number ~/ 10 : number % 10; return _PageScaffold(title: widget.tens ? 'لعبة العشرات' : 'لعبة الآحاد', children: <Widget>[const Text('حدد قيمة الرقم المطلوب', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), Text(arNum(number), textAlign: TextAlign.center, style: const TextStyle(fontSize: 65, fontWeight: FontWeight.w900)), Text('الرقم المطلوب: ${arNum(digit)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 14), _ActionButton(text: 'الآحاد', color: const Color(0xFF7652FF), onTap: () => answer('الآحاد')), const SizedBox(height: 10), _ActionButton(text: 'العشرات', color: const Color(0xFF0097A7), onTap: () => answer('العشرات'))]); }
}

class _StoriesPage extends StatelessWidget {
  const _StoriesPage();
  @override Widget build(BuildContext context) { final data = stories.take(2).toList(); return _PageScaffold(title: 'قصص تعليمية', children: data.map((story) => Padding(padding: const EdgeInsets.only(bottom: 12), child: App3DCard(onTap: () => _show(context, story), encouragement: '📖 اقرأ واستمع', child: ListTile(leading: Text(story['emoji'] ?? '📖', style: const TextStyle(fontSize: 38)), title: Text(story['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)), subtitle: const Text('قصة تعليمية مع صوت'))))).toList()); }
  void _show(BuildContext context, Map<String, String> story) { final title = story['title'] ?? ''; final text = story['text'] ?? ''; showDialog<void>(context: context, builder: (_) => Directionality(textDirection: TextDirection.rtl, child: AlertDialog(title: Text('${story['emoji'] ?? '📖'} $title'), content: Text(text, style: const TextStyle(fontSize: 18, height: 1.7)), actions: <Widget>[TextButton(onPressed: () => VoiceService.arabic(text), child: const Text('استمع للقصة')), TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))]))); }
}

class _PageScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _PageScaffold({required this.title, required this.children});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(16), children: children)));
}
class _MenuCard extends StatelessWidget {
  final String title; final IconData icon; final Color color; final VoidCallback onTap;
  const _MenuCard({required this.title, required this.icon, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: App3DCard(onTap: onTap, encouragement: '✨ $title', child: Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)), child: Row(children: <Widget>[Icon(icon, color: Colors.white, size: 42), const SizedBox(width: 14), Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))), const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)]))));
}
class _ActionButton extends StatelessWidget {
  final String text; final Color color; final VoidCallback? onTap;
  const _ActionButton({required this.text, required this.color, required this.onTap});
  @override Widget build(BuildContext context) => App3DCard(onTap: onTap ?? () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: onTap == null ? Colors.grey : color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900))));
}
void _push(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
