import 'package:flutter/material.dart';

import '../../core/audio/voice_service.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../data/content.dart';
import '../../widgets/app_feedback.dart';

class KindergartenStageScreen extends StatelessWidget {
  final String stageId;
  const KindergartenStageScreen({super.key, required this.stageId});

  bool get advanced => stageId == 'kg2';

  @override
  Widget build(BuildContext context) {
    final title = advanced ? 'الروضة الثانية' : 'الروضة الأولى';
    final sections = <_Section>[
      const _Section('الحروف', 'تعلم الحروف العربية مع الصوت والاسم والكلمة', Icons.abc_rounded, Color(0xFF8E5CF6)),
      _Section('الأرقام', advanced ? 'الأرقام من ١ إلى ٥٠ مع النطق' : 'الأرقام من ١ إلى ١٠ مع النطق', Icons.pin_rounded, const Color(0xFF18A7E8)),
      const _Section('الكتابة', 'تدريب على كتابة الحروف والأرقام', Icons.draw_rounded, Color(0xFF16B878)),
      const _Section('الألوان', 'تعرف إلى الألوان من خلال أنشطة ممتعة', Icons.palette_rounded, Color(0xFFFF8A3D)),
      const _Section('الأشكال', 'تعلم الأشكال الأساسية مع النطق', Icons.category_rounded, Color(0xFFE94F9B)),
      const _Section('الألعاب', 'أنشطة تعليمية بسيطة وممتعة', Icons.sports_esports_rounded, Color(0xFFFFC107)),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            App3DCard(
              onTap: () => AppFeedback.show('🌟 $title — أنت بطل التعلم!'),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF18A7E8), Color(0xFFE94F9B)]),
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: Row(children: [
                  const Text('🌟', style: TextStyle(fontSize: 44)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('نتعلم خطوة بخطوة مع الصوت واللعب والكتابة', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            for (final section in sections) ...[
              App3DCard(
                onTap: () => _open(context, section.title),
                encouragement: '✨ ${section.title} ممتع!',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [section.color, section.color.withValues(alpha: .72)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(children: [
                    Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .22), borderRadius: BorderRadius.circular(18)), child: Icon(section.icon, color: Colors.white, size: 34)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(section.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
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
    final Widget page;
    switch (title) {
      case 'الحروف':
        page = const _LettersPage();
      case 'الأرقام':
        page = _NumbersPage(advanced: advanced);
      default:
        page = _ComingSoonPage(title: title);
    }
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _Section {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _Section(this.title, this.subtitle, this.icon, this.color);
}

class _LettersPage extends StatefulWidget {
  const _LettersPage();
  @override State<_LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<_LettersPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الحروف العربية')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('الحرف ${arNum(index + 1)} من ${arNum(arabicLetters.length)}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: (index + 1) / arabicLetters.length, minHeight: 8),
          const SizedBox(height: 16),
          App3DCard(
            onTap: () => VoiceService.arabicLetterSound(item.letter, fallbackText: item.sound),
            encouragement: '🔊 استمع إلى صوت الحرف',
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8E5CF6), Color(0xFF5C6BC0)]), borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Column(children: [
                Text(item.letter, style: const TextStyle(fontSize: 110, color: Colors.white, fontWeight: FontWeight.w900)),
                Text('صوت الحرف: ${item.sound}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          App3DCard(
            onTap: () => VoiceService.arabic(item.word),
            encouragement: '🗣️ استمع إلى الكلمة',
            child: ListTile(leading: Text(item.emoji, style: const TextStyle(fontSize: 38)), title: Text(item.word, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900)), trailing: const Icon(Icons.volume_up_rounded)),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _Button(text: 'السابق', color: const Color(0xFFE94F9B), onTap: index > 0 ? () => setState(() => index--) : null)),
            const SizedBox(width: 10),
            Expanded(child: _Button(text: 'التالي', color: const Color(0xFF16B878), onTap: index < arabicLetters.length - 1 ? () => setState(() => index++) : null)),
          ]),
        ]),
      ),
    );
  }
}

class _NumbersPage extends StatelessWidget {
  final bool advanced;
  const _NumbersPage({required this.advanced});
  @override
  Widget build(BuildContext context) {
    final max = advanced ? 50 : 10;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأرقام')),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: max,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (_, index) {
            final number = index + 1;
            return App3DCard(
              onTap: () => VoiceService.arabic(number.toString()),
              encouragement: '🔊 الرقم ${arNum(number)}',
              child: Container(
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF18A7E8), Color(0xFF42A5F5)]), borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(child: Text(arNum(number), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900))),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  const _Button({required this.text, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => App3DCard(
    onTap: onTap ?? () {},
    child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: onTap == null ? Colors.grey : color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)))),
  );
}

class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: App3DCard(onTap: () => AppFeedback.show('🌟 قريبًا يا بطل!'), child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.auto_awesome_rounded, size: 64), const SizedBox(height: 14), Text('$title — قريبًا', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900))])))),
    ),
  );
}
