import 'package:flutter/material.dart';
import '../../data/content_v11.dart';

class _StageV11View {
  final String id;
  final String title;
  final int maxNumber;
  final List<String> units;
  const _StageV11View(this.id, this.title, this.maxNumber, this.units);
}

const _stages = <_StageV11View>[
  _StageV11View('kg1', 'الروضة الأولى', 10, ['الألوان الأساسية', 'الأشكال', 'المطابقة', 'الاستماع']),
  _StageV11View('kg2', 'الروضة الثانية', 20, ['الحروف', 'الصوت الأول', 'الكلمة والصورة', 'العد']),
  _StageV11View('prep', 'التمهيدي', 100, ['الحركات', 'المقاطع', 'التهجي', 'قراءة الكلمات']),
  _StageV11View('g1', 'الصف الأول', 1000, ['قراءة جمل', 'إملاء', 'كتابة', 'English phonics']),
  _StageV11View('g2', 'الصف الثاني', 10000, ['فهم النص', 'المفردات', 'التراكيب', 'English sentences']),
  _StageV11View('g3', 'الصف الثالث', 1000000, ['الفكرة الرئيسية', 'التعبير', 'القراءة المتقدمة', 'English reading']),
];

class ContentLibraryV11 extends StatelessWidget {
  const ContentLibraryV11({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المحتوى التعليمي'),
            bottom: const TabBar(tabs: [
              Tab(text: 'الكلمات'),
              Tab(text: 'القصص'),
              Tab(text: 'المنهج'),
            ]),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: arabicWordsV11.length,
                itemBuilder: (_, i) {
                  final w = arabicWordsV11[i];
                  return Card(
                    child: ListTile(
                      leading: Text(w.emoji, style: const TextStyle(fontSize: 30)),
                      title: Text(w.word),
                      subtitle: Text('${w.letter} • ${w.phoneme} • ${w.category}'),
                    ),
                  );
                },
              ),
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: storiesV11.length,
                itemBuilder: (_, i) {
                  final s = storiesV11[i];
                  return Card(
                    child: ExpansionTile(
                      leading: Text(s.emoji, style: const TextStyle(fontSize: 30)),
                      title: Text(s.title),
                      subtitle: Text('المرحلة: ${s.stage} • عدد الكلمات: ${s.words.length}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(s.text, style: const TextStyle(fontSize: 18, height: 1.7)),
                        ),
                        for (final word in s.words)
                          ListTile(leading: const Icon(Icons.menu_book), title: Text(word)),
                      ],
                    ),
                  );
                },
              ),
              ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _stages.length,
                itemBuilder: (_, i) {
                  final s = _stages[i];
                  return Card(
                    child: ExpansionTile(
                      title: Text(s.title),
                      subtitle: Text('الحد الأعلى للأعداد: ${s.maxNumber}'),
                      children: [
                        for (final u in s.units)
                          ListTile(leading: const Icon(Icons.menu_book), title: Text(u)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
