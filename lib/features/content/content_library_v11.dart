import 'package:flutter/material.dart';
import '../../data/content_v11.dart';

class ContentLibraryV11 extends StatelessWidget {
  const ContentLibraryV11({super.key});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحتوى التعليمي'),
          bottom: const TabBar(tabs: [
            Tab(text: 'الكلمات'), Tab(text: 'القصص'), Tab(text: 'المنهج'),
          ]),
        ),
        body: TabBarView(children: [
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: v11ArabicWords.length,
            itemBuilder: (_, i) {
              final w = v11ArabicWords[i];
              return Card(child: ListTile(
                leading: Text(w.emoji, style: const TextStyle(fontSize: 30)),
                title: Text(w.word),
                subtitle: Text('${w.letter} • ${w.syllables} • ${w.category}'),
              ));
            },
          ),
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: v11Stories.length,
            itemBuilder: (_, i) {
              final s = v11Stories[i];
              return Card(child: ExpansionTile(
                leading: Text(s.emoji, style: const TextStyle(fontSize: 30)),
                title: Text(s.title),
                subtitle: Text('عدد الأسئلة: ${s.questions.length}'),
                children: [
                  Padding(padding: const EdgeInsets.all(16), child: Text(s.text, style: const TextStyle(fontSize: 18, height: 1.7))),
                  for (final q in s.questions) ListTile(leading: const Icon(Icons.help_outline), title: Text(q)),
                ],
              ));
            },
          ),
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: v11Stages.length,
            itemBuilder: (_, i) {
              final s = v11Stages[i];
              return Card(child: ExpansionTile(
                title: Text(s.title),
                subtitle: Text('الحد الأعلى للأعداد: ${s.maxNumber}'),
                children: [for (final u in s.units) ListTile(leading: const Icon(Icons.menu_book), title: Text(u))],
              ));
            },
          ),
        ]),
      ),
    ),
  );
}
