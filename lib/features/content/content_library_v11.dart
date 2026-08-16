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
            itemCount: arabicWordsV11.length,
            itemBuilder: (_, i) {
              final w = arabicWordsV11[i];
              return Card(child: ListTile(
                leading: Text(w.emoji, style: const TextStyle(fontSize: 30)),
                title: Text(w.word),
                subtitle: Text('${w.letter} • ${w.phoneme} • ${w.category}'),
              ));
            },
          ),
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: storiesV11.length,
            itemBuilder: (_, i) {
              final s = storiesV11[i];
              return Card(child: ExpansionTile(
                leading: Text(s.emoji, style: const TextStyle(fontSize: 30)),
                title: Text(s.title),
                subtitle: Text('${s.stage} • الكلمات: ${s.words.length}'),
                children: [Padding(padding: const EdgeInsets.all(16), child: Text(s.text, style: const TextStyle(fontSize: 18, height: 1.7))), for (final q in s.words) ListTile(leading: const Icon(Icons.label_outline), title: Text(q))],
              ));
            },
          ),
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: stageNumberTargetsV11.length,
            itemBuilder: (_, i) {
              final entry = stageNumberTargetsV11.entries.elementAt(i);
              return Card(child: ListTile(leading: const Icon(Icons.numbers), title: Text(entry.key), subtitle: Text('الحد الأعلى للأعداد: ${entry.value}')));
            },
          ),
        ]),
      ),
    ),
  );
}
