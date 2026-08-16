import 'package:flutter/material.dart';
import '../../core/storage/app_storage.dart';
import '../../core/localization/arabic_numbers.dart';

class ParentsScreen extends StatelessWidget {
  const ParentsScreen({super.key});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('لوحة الوالدين')),
      body: FutureBuilder(
        future: AppStorage.getChildren(),
        builder: (context, snapshot) {
          final kids = snapshot.data ?? const [];
          final k = kids.isEmpty ? null : kids.first;
          final acc = k?.accuracy ?? 0.0;
          return ListView(padding: const EdgeInsets.all(16), children: [
            Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(k?.name ?? 'لا يوجد طفل', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('الدروس المكتملة: ${arNum(k?.lessons ?? 0)}'),
              LinearProgressIndicator(value: ((k?.lessons ?? 0) / 20).clamp(0.0, 1.0)),
              const SizedBox(height: 14),
              Text('دقة الاختبارات: ${arNum((acc * 100).round())}٪'),
              LinearProgressIndicator(value: acc.clamp(0.0, 1.0)),
              const SizedBox(height: 14),
              Text('النجوم: ${arNum(k?.stars ?? 0)} ⭐'),
            ]))),
            ListTile(leading: const Icon(Icons.timer), title: const Text('وقت التعلم'), trailing: Text('${arNum(k?.minutes ?? 0)} دقيقة')),
            ListTile(leading: const Icon(Icons.local_fire_department), title: const Text('سلسلة التعلم'), trailing: Text('${arNum(k?.streak ?? 0)} أيام')),
            ListTile(leading: const Icon(Icons.warning_amber), title: const Text('مراجعة مقترحة'), subtitle: Text(k?.weakItems.isEmpty ?? true ? 'لا توجد نقاط ضعف مسجلة بعد.' : k!.weakItems.join(' • '))),
            const Card(child: ListTile(leading: Icon(Icons.cloud_done), title: Text('التخزين المحلي'), subtitle: Text('التقدم محفوظ على الجهاز ولا يحتاج إلى اتصال.'))),
          ]);
        },
      ),
    ),
  );
}
