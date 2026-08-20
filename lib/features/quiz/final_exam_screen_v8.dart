import 'package:flutter/material.dart';
import '../../data/curriculum_v8.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/storage/progress_v8.dart';
import '../../core/audio/voice_service.dart';

class FinalExamScreenV8 extends StatefulWidget {
  final CurriculumStageV8 stage;
  const FinalExamScreenV8({super.key, required this.stage});
  @override State<FinalExamScreenV8> createState() => _FinalExamScreenV8State();
}

class _FinalExamScreenV8State extends State<FinalExamScreenV8> {
  late final List<_Question> questions;
  int index = 0, score = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    questions = widget.stage.id == 'prep' ? _prepQuestions() : _questions(widget.stage.id);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stage.id == 'prep') return _buildPrep();
    if (index >= questions.length) return _result();
    final q = questions[index];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: Text('اختبار ${widget.stage.title}')),
      body: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        _progress(), const SizedBox(height: 18),
        Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
          Text(q.emoji, style: const TextStyle(fontSize: 70)),
          Text(q.prompt, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (q.voiceText != null) IconButton(onPressed: () => VoiceService.arabic(q.voiceText!), icon: const Icon(Icons.volume_up)),
        ]))),
        const SizedBox(height: 18),
        ...q.options.map((option) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: FilledButton.tonal(onPressed: answered ? null : () => _answer(option == q.answer), child: Text(option, style: const TextStyle(fontSize: 21))))),
      ])),
    ));
  }

  Widget _progress() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text('السؤال ${arNum(index + 1)} من ${arNum(questions.length)}', style: const TextStyle(fontWeight: FontWeight.bold)),
    Text('النتيجة: ${arNum(score)} ⭐'),
  ]);

  void _answer(bool correct) {
    if (answered) return;
    setState(() { answered = true; if (correct) score++; });
    Future.delayed(const Duration(milliseconds: 650), () { if (!mounted) return; setState(() { index++; answered = false; }); });
  }

  Widget _buildPrep() {
    if (index >= questions.length) return _result();
    final q = questions[index];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: const Text('اختبار التمهيدي')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        _progress(), const SizedBox(height: 12),
        LinearProgressIndicator(value: (index + 1) / questions.length, minHeight: 9),
        const SizedBox(height: 16),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
          Text(q.prompt, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          if (q.voiceText != null) IconButton(onPressed: () => VoiceService.arabic(q.voiceText!), icon: const Icon(Icons.volume_up)),
        ]))),
        const SizedBox(height: 14), _prepBody(q),
      ]),
    ));
  }

  Widget _prepBody(_Question q) {
    switch (q.type) {
      case _QuestionType.write:
        return Column(children: [Text(q.target!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900)), const SizedBox(height: 8), _ExamDrawingBoard(onDone: _nextPrep)]);
      case _QuestionType.place:
        final number = q.number!; final tens = number ~/ 10; final ones = number % 10; final target = q.target == 'ones' ? ones : tens;
        return Column(children: [Text(arNum(number), textAlign: TextAlign.center, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900)), Text(q.target == 'ones' ? 'اضغط رقم الآحاد' : 'اضغط رقم العشرات', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 12), Row(mainAxisAlignment: MainAxisAlignment.center, children: [_DigitChoice(number ~/ 10, target, _nextPrep), const SizedBox(width: 18), _DigitChoice(number % 10, target, _nextPrep)])]);
      case _QuestionType.shape:
        return Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10, children: q.shapeOptions!.map((name) => _ShapeChoice(name: name, correct: name == q.answer, onTap: _nextPrep)).toList());
      case _QuestionType.color:
        return Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 12, children: q.colorOptions!.asMap().entries.map((e) => _ColorChoice(color: e.value, correct: e.key == q.colorAnswer, onTap: _nextPrep)).toList());
      case _QuestionType.normal:
        return const SizedBox.shrink();
    }
  }

  void _nextPrep({bool correct = true}) {
    if (answered) return;
    setState(() { answered = true; if (correct) score++; });
    Future.delayed(const Duration(milliseconds: 550), () { if (!mounted) return; setState(() { index++; answered = false; }); });
  }

  Widget _result() {
    final passed = score * 100 >= questions.length * 70;
    WidgetsBinding.instance.addPostFrameCallback((_) async { await ProgressV8.recordFinalExam(widget.stage.id, score, questions.length, passed); });
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: const Text('نتيجة الاختبار النهائي')),
      body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(passed ? '🎉' : '🌱', style: const TextStyle(fontSize: 90)),
        Text(passed ? 'أحسنت! اجتزت المرحلة' : 'أحسنت المحاولة! نراجع ثم نعيد الاختبار', textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12), Text('نتيجتك: ${arNum(score)} من ${arNum(questions.length)}', style: const TextStyle(fontSize: 23)),
        Text('النسبة: ${arNum((score / questions.length * 100).round())}٪', style: const TextStyle(fontSize: 23)),
        const SizedBox(height: 20), Text(passed ? '🏆 حصلت على ٥٠ نجمة و٥٠٠ نقطة تعليمية' : '🔄 راجع المهارات الضعيفة ثم حاول مرة أخرى', textAlign: TextAlign.center),
        const SizedBox(height: 20), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('العودة إلى المنهج')),
      ]))),
    ));
  }

  List<_Question> _prepQuestions() => [
    const _Question.write('اكتب الحرف المطلوب', 'ب', 'بَ'),
    const _Question.write('اكتب الحرفين المطلوبين', 'با', 'با'),
    const _Question.write('اكتب الحرف المطلوب', 'م', 'مَ'),
    const _Question.write('اكتب الحرفين المطلوبين', 'دو', 'دو'),
    const _Question.write('اكتب العدد المطلوب', '٧', null),
    const _Question.write('اكتب العدد المطلوب', '٢٤', null),
    const _Question.place('حدد الآحاد في العدد', 24, 'ones'),
    const _Question.place('حدد العشرات في العدد', 37, 'tens'),
    const _Question.shape('اختر شكل المثلث', 'مثلث', ['مربع','مثلث','دائرة','مستطيل']),
    const _Question.shape('اختر شكل المستطيل', 'مستطيل', ['دائرة','مثلث','مستطيل','مربع']),
    _Question.color('اختر اللون الأحمر', const [Color(0xFF2196F3),Color(0xFFF44336),Color(0xFF4CAF50),Color(0xFFFFC107)], 1),
    _Question.color('اختر اللون الأزرق', const [Color(0xFFFFC107),Color(0xFF4CAF50),Color(0xFF2196F3),Color(0xFFF44336)], 2),
  ];

  List<_Question> _questions(String id) {
    final common = <_Question>[
      const _Question('أي خيار يمثل الحرف ب؟', ['ب','ت','ث','ن'], 'ب', '🔤', 'بَ'),
      const _Question('ما الكلمة التي تبدأ بصوت مَ؟', ['موز','كتاب','قلم','باب'], 'موز', '🍌', 'موز'),
      const _Question('كم يساوي ٢ + ٣؟', ['٤','٥','٦','٧'], '٥', '➕', null),
      const _Question('اختر الكلمة المناسبة للصورة', ['شمس','قمر','كتاب','باب'], 'شمس', '☀️', null),
      const _Question('ما اسم الحرف الإنجليزي B؟', ['Bee','Dee','Kay','Em'], 'Bee', '🇬🇧', null),
    ];
    if (id == 'kg1') return common.sublist(0, 3);
    if (id == 'kg2') return [...common.sublist(0, 4), const _Question('اختر العدد الأكبر', ['٣','٥','٢','٤'], '٥', '🔢', null)];
    if (id == 'g1') return [...common, const _Question('كم يساوي ٧ - ٢؟', ['٣','٤','٥','٦'], '٥', '➖', null), const _Question('اختر صوت الحرف B في كلمة ball', ['buh','sss','mmm','tuh'], 'buh', '⚽', null)];
    if (id == 'g2') return [...common, const _Question('أي جملة صحيحة؟', ['الولد يقرأ.','يقرأ الولد؟','الولد قراءة.','قراءة الولد هو.'], 'الولد يقرأ.', '📖', null)];
    return [...common, const _Question('اختر الكلمة المقسمة إلى مقطعين', ['مَدْرَسَة','باب','قلم','نور'], 'مَدْرَسَة', '📚', null)];
  }
}

enum _QuestionType { normal, write, place, shape, color }
class _Question {
  final String prompt; final List<String> options; final String answer; final String emoji; final String? voiceText; final _QuestionType type; final String? target; final int? number; final List<String>? shapeOptions; final List<Color>? colorOptions; final int? colorAnswer;
  const _Question(this.prompt, this.options, this.answer, this.emoji, this.voiceText) : type = _QuestionType.normal, target = null, number = null, shapeOptions = null, colorOptions = null, colorAnswer = null;
  const _Question.write(this.prompt, this.target, this.voiceText) : options = const [], answer = '', emoji = '✍️', type = _QuestionType.write, number = null, shapeOptions = null, colorOptions = null, colorAnswer = null;
  const _Question.place(this.prompt, this.number, this.target) : options = const [], answer = '', emoji = '🔢', voiceText = null, type = _QuestionType.place, shapeOptions = null, colorOptions = null, colorAnswer = null;
  const _Question.shape(this.prompt, this.answer, this.shapeOptions) : options = const [], emoji = '🔷', voiceText = null, type = _QuestionType.shape, target = null, number = null, colorOptions = null, colorAnswer = null;
  const _Question.color(this.prompt, this.colorOptions, this.colorAnswer) : options = const [], answer = '', emoji = '🎨', voiceText = null, type = _QuestionType.color, target = null, number = null, shapeOptions = null;
}

class _ExamDrawingBoard extends StatefulWidget {
  final void Function({bool correct}) onDone;
  const _ExamDrawingBoard({required this.onDone});
  @override State<_ExamDrawingBoard> createState() => _ExamDrawingBoardState();
}
class _ExamDrawingBoardState extends State<_ExamDrawingBoard> {
  final List<List<Offset>> strokes = <List<Offset>>[]; List<Offset> current = <Offset>[];
  void clear() => setState(() { strokes.clear(); current = []; });
  void undo() { if (strokes.isNotEmpty) setState(() => strokes.removeLast()); }
  @override Widget build(BuildContext context) => Column(children: [
    Container(height: 300, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(width: 3)), child: Listener(behavior: HitTestBehavior.opaque, onPointerDown: (e) => setState(() => current = [e.localPosition]), onPointerMove: (e) => setState(() => current = [...current, e.localPosition]), onPointerUp: (_) { if (current.isNotEmpty) strokes.add(List<Offset>.of(current)); setState(() => current = []); }, child: CustomPaint(painter: _ExamPainter(strokes, current), child: const SizedBox.expand()))),
    const SizedBox(height: 8), Row(children: [Expanded(child: FilledButton.tonal(onPressed: undo, child: const Text('↩ تراجع'))), const SizedBox(width: 8), Expanded(child: FilledButton.tonal(onPressed: clear, child: const Text('🗑 مسح'))), const SizedBox(width: 8), Expanded(child: FilledButton(onPressed: strokes.isEmpty ? null : () => widget.onDone(correct: true), child: const Text('تم')))]),
  ]);
}
class _ExamPainter extends CustomPainter {
  final List<List<Offset>> strokes; final List<Offset> current; _ExamPainter(this.strokes, this.current);
  @override void paint(Canvas c, Size s) { final p=Paint()..color=Colors.black..strokeWidth=10..strokeCap=StrokeCap.round; void d(List<Offset> a){for(var i=1;i<a.length;i++)c.drawLine(a[i-1],a[i],p);} for(final x in strokes)d(x); d(current); }
  @override bool shouldRepaint(covariant _ExamPainter oldDelegate)=>true;
}
class _DigitChoice extends StatelessWidget {
  final int value, correct; final void Function({bool correct}) onTap;
  const _DigitChoice(this.value, this.correct, this.onTap);
  @override Widget build(BuildContext context) => SizedBox(width: 120, height: 90, child: FilledButton(onPressed: () => onTap(correct: value == correct), child: Text(arNum(value), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900))));
}
class _ShapeChoice extends StatelessWidget {
  final String name; final bool correct; final void Function({bool correct}) onTap;
  const _ShapeChoice({required this.name, required this.correct, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: () => onTap(correct: correct), child: Container(width: 130, height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(width: 3)), child: CustomPaint(painter: _ShapeOptionPainter(name), child: const SizedBox.expand())));
}
class _ShapeOptionPainter extends CustomPainter {
  final String name; _ShapeOptionPainter(this.name);
  @override void paint(Canvas c, Size s){final p=Paint()..color=Colors.deepPurple..style=PaintingStyle.fill;final o=Paint()..color=Colors.black87..style=PaintingStyle.stroke..strokeWidth=4;final center=Offset(s.width/2,s.height/2);if(name=='دائرة'){c.drawCircle(center,38,p);c.drawCircle(center,38,o);}else if(name=='مربع'){final r=Rect.fromCenter(center:center,width:70,height:70);c.drawRect(r,p);c.drawRect(r,o);}else if(name=='مستطيل'){final r=Rect.fromCenter(center:center,width:100,height:60);c.drawRect(r,p);c.drawRect(r,o);}else{final path=Path();final sides=name=='مثلث'?3:4;for(var i=0;i<sides;i++){final a=-1.5708+i*6.2832/sides;final pt=center+Offset(42*Math.cos(a),42*Math.sin(a));if(i==0)path.moveTo(pt.dx,pt.dy);else path.lineTo(pt.dx,pt.dy);}path.close();c.drawPath(path,p);c.drawPath(path,o);}}
  @override bool shouldRepaint(covariant _ShapeOptionPainter oldDelegate)=>oldDelegate.name!=name;
}
class _ColorChoice extends StatelessWidget {
  final Color color; final bool correct; final void Function({bool correct}) onTap;
  const _ColorChoice({required this.color, required this.correct, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: () => onTap(correct: correct), child: Container(width: 85, height: 85, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.black87, width: 3))));
}
