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
        ? ['الحروف', 'الأرقام', 'الكتابة', 'الألوان', 'الأشكال', 'القصص والألعاب']
        : ['الحروف', 'الأرقام', 'الكتابة', 'الألوان', 'الأشكال', 'الألعاب'];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MenuCard(title: items[i], onTap: () => _open(context, items[i])),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'الحروف': page = _LettersPage(kg2: kg2); break;
      case 'الأرقام': page = _NumbersPage(kg2: kg2); break;
      case 'الكتابة': page = _WritingPage(kg2: kg2); break;
      case 'الألوان': page = _ColoringPage(kg2: kg2); break;
      case 'الأشكال': page = _ShapeDrawingPage(kg2: kg2); break;
      default: page = _GamesPage(kg2: kg2); break;
    }
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _MenuCard({required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          const Icon(Icons.school_rounded, size: 40),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
          const Icon(Icons.arrow_back_ios_new_rounded),
        ]),
      ),
    ),
  );
}

class _Page extends StatelessWidget {
  final String title;
  final Widget child;
  const _Page(this.title, this.child);
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(appBar: AppBar(title: Text(title)), body: SafeArea(child: Padding(padding: const EdgeInsets.all(10), child: child))),
  );
}

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override State<_LettersPage> createState() => _LettersState();
}
class _LettersState extends State<_LettersPage> {
  static const letters = ['ا','ب','ت','ث','ج','ح','خ','د','ذ','ر','ز','س','ش','ص','ض','ط','ظ','ع','غ','ف','ق','ك','ل','م','ن','ه','و','ي'];
  int index = 0;
  int form = 0;
  String get display => widget.kg2 ? const [
    'ا','بـ','تـ','ثـ','جـ','حـ','خـ','د','ذ','ر','ز','سـ','شـ','صـ','ضـ','طـ','ظـ','عـ','غـ','فـ','قـ','كـ','لـ','مـ','نـ','هـ','و','يـ'
  ][index] : letters[index];
  void speak() => VoiceService.arabic(letters[index]);
  @override Widget build(BuildContext context) => _Page('الحروف', Column(children: [
    Text('${index + 1} من ٢٨'),
    Expanded(child: Center(child: Text(display, style: const TextStyle(fontSize: 110, fontWeight: FontWeight.w900)))),
    ElevatedButton.icon(onPressed: speak, icon: const Icon(Icons.volume_up), label: const Text('نطق الحرف')),
    if (widget.kg2) Row(children: List.generate(3, (i) => Expanded(child: Padding(padding: const EdgeInsets.all(3), child: ElevatedButton(onPressed: () => setState(() => form = i), child: Text(['أولي','وسطي','آخري'][i])))))),
    Row(children: [
      Expanded(child: ElevatedButton(onPressed: index > 0 ? () => setState(() => index--) : null, child: const Text('السابق'))),
      const SizedBox(width: 8),
      Expanded(child: ElevatedButton(onPressed: index < 27 ? () => setState(() => index++) : null, child: const Text('التالي'))),
    ]),
    const SizedBox(height: 8),
  ]));
}

String _ar(int n) => n.toString().replaceAllMapped(RegExp(r'\d'), (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m.group(0)!)]);

class _NumbersPage extends StatelessWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});
  @override Widget build(BuildContext context) {
    final count = kg2 ? 50 : 10;
    return _Page('الأرقام', GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: count,
      itemBuilder: (_, i) => ElevatedButton(onPressed: () => VoiceService.arabic(_ar(i + 1)), child: Text(_ar(i + 1), style: const TextStyle(fontSize: 24))),
    ));
  }
}

class _WritingPage extends StatefulWidget {
  final bool kg2;
  const _WritingPage({required this.kg2});
  @override State<_WritingPage> createState() => _WritingState();
}
class _WritingState extends State<_WritingPage> {
  final List<List<Offset>> strokes = [];
  int tab = 0;
  int index = 0;
  String get target => tab == 0 ? _LettersState.letters[index] : _ar(index + 1);
  void clear() => setState(strokes.clear);
  void undo() { if (strokes.isNotEmpty) setState(() => strokes.removeLast()); }
  @override Widget build(BuildContext context) => _Page('الكتابة', Column(children: [
    Row(children: [Expanded(child: ElevatedButton(onPressed: () => setState(() {tab=0; index=0; strokes.clear();}), child: const Text('الحروف'))), Expanded(child: ElevatedButton(onPressed: () => setState(() {tab=1; index=0; strokes.clear();}), child: const Text('الأرقام')))]),
    Text(target, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
    Expanded(child: Container(decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: BorderRadius.circular(14)), child: GestureDetector(
      onPanStart: (d) => setState(() => strokes.add([d.localPosition])),
      onPanUpdate: (d) => setState(() => strokes.last.add(d.localPosition)),
      onPanEnd: (_) => setState(() {}),
      child: CustomPaint(painter: _StrokePainter(strokes), child: const SizedBox.expand()),
    ))),
    Row(children: [Expanded(child: ElevatedButton(onPressed: undo, child: const Text('تراجع'))), Expanded(child: ElevatedButton(onPressed: clear, child: const Text('مسح')))]),
    Row(children: [Expanded(child: ElevatedButton(onPressed: index > 0 ? () => setState(() => index--) : null, child: const Text('السابق'))), Expanded(child: ElevatedButton(onPressed: () => setState(() => index++), child: const Text('التالي')))]),
  ]));
}
class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _StrokePainter(this.strokes);
  @override void paint(Canvas c, Size s) { final p = Paint()..color = Colors.black..strokeWidth = 5..strokeCap = StrokeCap.round; for (final stroke in strokes) for (var i=1;i<stroke.length;i++) c.drawLine(stroke[i-1], stroke[i], p); }
  @override bool shouldRepaint(covariant _StrokePainter old) => true;
}

class _ColoringPage extends StatefulWidget {
  final bool kg2;
  const _ColoringPage({required this.kg2});
  @override State<_ColoringPage> createState() => _ColoringState();
}
class _ColoringState extends State<_ColoringPage> {
  final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.purple, Colors.brown, Colors.black];
  final names = ['أحمر','أزرق','أخضر','أصفر','برتقالي','بنفسجي','بني','أسود'];
  Color selected = Colors.red;
  int picture = 0;
  final drawings = const ['قطة','سمكة','فراشة','تفاحة','أرنب','أسد'];
  final List<List<Offset>> strokes = [];
  void speakColor(int i) => VoiceService.arabic(names[i]);
  @override Widget build(BuildContext context) => _Page('الألوان والرسم', Column(children: [
    Text(drawings[picture], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
    Expanded(child: GestureDetector(onPanStart: (d) => setState(() => strokes.add([d.localPosition])), onPanUpdate: (d) => setState(() => strokes.last.add(d.localPosition)), child: CustomPaint(painter: _ColorPainter(strokes, selected), child: const SizedBox.expand()))),
    SizedBox(height: 62, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: colors.length, itemBuilder: (_, i) => GestureDetector(onTap: () {setState(() => selected = colors[i]); speakColor(i);}, child: Container(width: 52, height: 52, margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle))))),
    Row(children: [Expanded(child: ElevatedButton(onPressed: () => setState(() {if (strokes.isNotEmpty) strokes.removeLast();}), child: const Text('تراجع'))), Expanded(child: ElevatedButton(onPressed: () => setState(strokes.clear), child: const Text('مسح'))), Expanded(child: ElevatedButton(onPressed: picture > 0 ? () => setState(() {picture--; strokes.clear();}) : null, child: const Text('السابق'))), Expanded(child: ElevatedButton(onPressed: picture < drawings.length-1 ? () => setState(() {picture++; strokes.clear();}) : null, child: const Text('التالي')))]),
  ]));
}
class _ColorPainter extends CustomPainter { final List<List<Offset>> strokes; final Color color; _ColorPainter(this.strokes,this.color); @override void paint(Canvas c,Size s){final p=Paint()..color=color..strokeWidth=10..strokeCap=StrokeCap.round; for(final st in strokes)for(var i=1;i<st.length;i++)c.drawLine(st[i-1],st[i],p);} @override bool shouldRepaint(covariant _ColorPainter old)=>true; }

class _ShapeDrawingPage extends StatefulWidget { final bool kg2; const _ShapeDrawingPage({required this.kg2}); @override State<_ShapeDrawingPage> createState()=>_ShapeState(); }
class _ShapeState extends State<_ShapeDrawingPage> {
  final shapes = const ['مربع','مثلث','دائرة','مستطيل','خماسي','سداسي']; int index=0; final strokes=<List<Offset>>[];
  @override Widget build(BuildContext context)=>_Page('رسم الأشكال',Column(children:[Text(shapes[index],style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),Expanded(child:GestureDetector(onPanStart:(d)=>setState(()=>strokes.add([d.localPosition])),onPanUpdate:(d)=>setState(()=>strokes.last.add(d.localPosition)),child:CustomPaint(painter:_StrokePainter(strokes),child:const SizedBox.expand()))),Row(children:[Expanded(child:ElevatedButton(onPressed:()=>setState(strokes.clear),child:const Text('مسح'))),Expanded(child:ElevatedButton(onPressed:()=>setState((){if(strokes.isNotEmpty)strokes.removeLast();}),child:const Text('تراجع')))]),Row(children:[Expanded(child:ElevatedButton(onPressed:index>0?()=>setState(()=>index--):null,child:const Text('السابق'))),Expanded(child:ElevatedButton(onPressed:index<shapes.length-1?()=>setState(()=>index++):null,child:const Text('التالي')))])]));
}

class _GamesPage extends StatefulWidget { final bool kg2; const _GamesPage({required this.kg2}); @override State<_GamesPage> createState()=>_GamesState(); }
class _GamesState extends State<_GamesPage> {
  int letter=0, number=1; final letters=_LettersState.letters;
  void speakLetter()=>VoiceService.arabic(letters[letter]); void speakNumber()=>VoiceService.arabic(_ar(number));
  @override Widget build(BuildContext context)=>_Page('الألعاب',Column(children:[const Text('لعبة الحروف',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text('اختر الحرف الصحيح',style:const TextStyle(fontSize:20)),Text(letters[letter],style:const TextStyle(fontSize:50,fontWeight:FontWeight.w900)),ElevatedButton.icon(onPressed:speakLetter,icon:const Icon(Icons.volume_up),label:const Text('نطق السؤال')),Wrap(children:List.generate(3,(i){final v=(letter+i)%letters.length;return Padding(padding:const EdgeInsets.all(4),child:ElevatedButton(onPressed:()=>setState(()=>letter=(letter+1)%letters.length),child:Text(letters[v],style:const TextStyle(fontSize:22))));})),const Divider(),const Text('لعبة الأرقام',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900)),Text('أين الرقم ${_ar(number)}؟'),ElevatedButton.icon(onPressed:speakNumber,icon:const Icon(Icons.volume_up),label:const Text('نطق السؤال')),Wrap(children:List.generate(3,(i){final v=((number+i-1)%10)+1;return Padding(padding:const EdgeInsets.all(4),child:ElevatedButton(onPressed:()=>setState(()=>number=number==50?1:number+1),child:Text(_ar(v),style:const TextStyle(fontSize:22))));}))]));
}
