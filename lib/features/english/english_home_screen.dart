import 'package:flutter/material.dart';
import '../../data/content.dart';
import '../../data/content_v11.dart';
import '../../core/audio/voice_service.dart';
import 'english_phonics_rules_screen_v12.dart';

class EnglishHomeScreen extends StatelessWidget {
  const EnglishHomeScreen({super.key});
  void open(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('English Learning')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(color: Colors.blue.shade50, child: const Padding(padding: EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('English', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), Text('For Grade One and above')]))),
          ListTile(leading: const Text('🔤', style: TextStyle(fontSize: 35)), title: const Text('Phonics Letters'), subtitle: const Text('Letter sounds, not letter names'), onTap: () => open(c, const EnglishLettersScreen())),
          ListTile(leading: const Text('🧩', style: TextStyle(fontSize: 35)), title: const Text('Simple Words'), onTap: () => open(c, const EnglishWordsScreen())),
          ListTile(leading: const Text('🔤', style: TextStyle(fontSize: 35)), title: const Text('Phonics Rules'), subtitle: const Text('sh, ch, th, ph, oo, ee and more'), onTap: () => open(c, const EnglishPhonicsRulesScreenV12())),
          ListTile(leading: const Text('🎨', style: TextStyle(fontSize: 35)), title: const Text('Colors'), onTap: () => open(c, const EnglishColorsScreen())),
          ListTile(leading: const Text('🔢', style: TextStyle(fontSize: 35)), title: const Text('Numbers'), onTap: () => open(c, const EnglishNumbersScreen())),
        ],
      ),
    );
  }
}

class EnglishLettersScreen extends StatefulWidget {
  const EnglishLettersScreen({super.key});
  @override State<EnglishLettersScreen> createState() => _ELS();
}
class _ELS extends State<EnglishLettersScreen> {
  int i = 0;
  @override Widget build(BuildContext c) {
    final x = englishLetters[i];
    return Scaffold(
      appBar: AppBar(title: const Text('English Phonics')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          LinearProgressIndicator(value: (i + 1) / englishLetters.length),
          const SizedBox(height: 18),
          Text(x.letter, style: const TextStyle(fontSize: 110, fontWeight: FontWeight.bold)),
          Text('Sound: ${x.sound}', style: const TextStyle(fontSize: 25)),
          Text('${x.emoji}  ${x.word}', style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 14),
          FilledButton.icon(onPressed: () => VoiceService.englishLetterSound(x.letter, fallbackText: x.sound), icon: const Icon(Icons.volume_up), label: const Text('Play sound')),
          OutlinedButton.icon(onPressed: () => VoiceService.english(x.word), icon: const Icon(Icons.record_voice_over), label: const Text('Hear word')),
          const Spacer(),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: i == 0 ? null : () => setState(() => i--), child: const Text('Previous'))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton(onPressed: i == englishLetters.length - 1 ? null : () => setState(() => i++), child: const Text('Next'))),
          ]),
        ]),
      ),
    );
  }
}

class EnglishWordsScreen extends StatelessWidget {
  const EnglishWordsScreen({super.key});
  @override Widget build(BuildContext c) => Directionality(textDirection: TextDirection.ltr, child: Scaffold(appBar: AppBar(title: const Text('English Words')), body: GridView.builder(padding: const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.15), itemCount: englishWordsV11.length, itemBuilder: (_, i) { final w = englishWordsV11[i]; return Card(child: InkWell(onTap: () => VoiceService.english(w.word), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(w.emoji, style: const TextStyle(fontSize: 36)), Text(w.word, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), Text('sound: ${w.sound}'), const Icon(Icons.volume_up)]))); }));
}

class EnglishColorsScreen extends StatelessWidget {
  const EnglishColorsScreen({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Colors')), body: ListView(children: [for (final x in englishColors) ListTile(leading: Text(x['emoji']!, style: const TextStyle(fontSize: 30)), title: Text(x['name']!, style: const TextStyle(fontSize: 22)), subtitle: Text(x['ar']!), trailing: IconButton(onPressed: () => VoiceService.english(x['name']!), icon: const Icon(Icons.volume_up)))]));
}

class EnglishNumbersScreen extends StatelessWidget {
  const EnglishNumbersScreen({super.key});
  @override Widget build(BuildContext c) => Scaffold(appBar: AppBar(title: const Text('Numbers')), body: GridView.count(crossAxisCount: 4, padding: const EdgeInsets.all(12), children: [for (final n in englishNumbers) Card(child: InkWell(onTap: () => VoiceService.english(n), child: Center(child: Text(n, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))))])));
}
