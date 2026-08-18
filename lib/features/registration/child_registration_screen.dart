import 'package:flutter/material.dart';
import '../../core/storage/app_storage.dart';
import '../../models/child.dart';

class ChildRegistrationScreen extends StatefulWidget {
  const ChildRegistrationScreen({super.key});
  @override State<ChildRegistrationScreen> createState() => _ChildRegistrationScreenState();
}

class _ChildRegistrationScreenState extends State<ChildRegistrationScreen> {
  final name = TextEditingController();
  String stageId = 'kg1';
  bool saving = false;
  static const stages = [('kg1','الروضة الأولى'),('kg2','الروضة الثانية'),('prep','التمهيدي'),('g1','الصف الأول'),('g2','الصف الثاني'),('g3','الصف الثالث')];

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    Child? c;
    if (active != null) {
      for (final k in kids) {
        if (k.id == active) { c = k; break; }
      }
    }
    c ??= kids.isEmpty ? null : kids.first;
    if (c != null && mounted) {
      final child = c;
      setState(() {
        name.text = child.name;
        stageId = stages.firstWhere(
          (s) => s.$2 == child.stage,
          orElse: () => stages.first,
        ).$1;
      });
    }
  }
  Future<void> _save() async {
    final n = name.text.trim();
    if (n.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب اسم الطفل أولاً 🌟'))); return; }
    setState(() => saving = true);
    final kids = await AppStorage.getChildren();
    final active = await AppStorage.activeId();
    final selected = stages.firstWhere((s) => s.$1 == stageId).$2;
    final index = active == null ? -1 : kids.indexWhere((k) => k.id == active);
    if (index >= 0) {
      final old = kids[index];
      kids[index] = Child(id: old.id, name: n, age: _age(stageId), stage: selected, stars: old.stars, lessons: old.lessons, quizzes: old.quizzes, correct: old.correct, total: old.total, minutes: old.minutes, streak: old.streak, weakItems: old.weakItems);
      await AppStorage.setActive(old.id);
    } else {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      kids.add(Child(id: id, name: n, age: _age(stageId), stage: selected));
      await AppStorage.setActive(id);
    }
    await AppStorage.saveChildren(kids);
    if (!mounted) return;
    setState(() => saving = false);
    await showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('أحسنت يا بطل! 🎉'), content: Text('تم حفظ اسم $n في $selected 🌟\nسنحفظ تقدمك مع كل نشاط.'), actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('هيا نبدأ!'))]));
    if (mounted) Navigator.pop(context);
  }
  int _age(String id) => switch (id) { 'kg1' => 4, 'kg2' => 5, 'prep' => 6, 'g1' => 7, 'g2' => 8, _ => 9 };
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('تسجيل اسم البطل')), body: ListView(padding: const EdgeInsets.all(18), children: [
    const Text('اكتب اسمك يا بطل ⭐', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8), const Text('سيظهر اسمك ومرحلتك في الصفحة الرئيسية.'), const SizedBox(height: 22),
    TextField(controller: name, textInputAction: TextInputAction.done, decoration: const InputDecoration(labelText: 'اسم الطفل', prefixIcon: Icon(Icons.person_rounded), hintText: 'مثال: أحمد')),
    const SizedBox(height: 18), const Text('اختر مرحلتك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
    ...stages.map(
      (s) => Card(
        margin: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => stageId = s.$1),
          child: ListTile(
            leading: Icon(
              stageId == s.$1
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: stageId == s.$1
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            title: Text(s.$2),
          ),
        ),
      ),
    ),
    const SizedBox(height: 18), FilledButton.icon(onPressed: saving ? null : _save, icon: const Icon(Icons.save_rounded), label: Text(saving ? 'جارٍ الحفظ...' : 'حفظ والبدء 🚀')),
  ])));
  @override void dispose() { name.dispose(); super.dispose(); }
}
