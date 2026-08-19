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
        ? const <_Section>[
            _Section('الحروف', 'أولي ووسطي وأخري مع النطق', Icons.abc_rounded,
                Color(0xFF7652FF)),
            _Section('الأرقام', '١ إلى ٥٠ ومراتب الأعداد', Icons.pin_rounded,
                Color(0xFF0097A7)),
            _Section('كتابة الحروف والأعداد', 'أشكال الحروف والدمج والكتابة',
                Icons.draw_rounded, Color(0xFF00A86B)),
            _Section('الألوان', 'تعلم اللون وارسم الحيوان المرتبط به',
                Icons.palette_rounded, Color(0xFFFF7A45)),
            _Section('الأشكال', 'أشكال أساسية ومتقدمة مع النطق',
                Icons.category_rounded, Color(0xFFE83E8C)),
            _Section('القصص والألعاب', 'قصص مسموعة وأربع ألعاب تعليمية',
                Icons.auto_stories_rounded, Color(0xFFFFB300)),
          ]
        : const <_Section>[
            _Section('الحروف', '٢٨ حرفًا عربيًا مع الصوت والاسم والكلمة',
                Icons.abc_rounded, Color(0xFF7652FF)),
            _Section('الأرقام', 'من ١ إلى ١٠ مع النطق', Icons.pin_rounded,
                Color(0xFF0097A7)),
            _Section('كتابة الحروف والأرقام', 'اكتب فعليًا على الشاشة واختر اللون',
                Icons.draw_rounded, Color(0xFF00A86B)),
            _Section('الألوان', 'تعلم اللون وارسم حيوانًا بنفس اللون',
                Icons.palette_rounded, Color(0xFFFF7A45)),
            _Section('الأشكال', 'مربع ومثلث ودائرة ومستطيل ومنحرف وشبه منحرف',
                Icons.category_rounded, Color(0xFFE83E8C)),
            _Section('الألعاب', 'لعبة فعلية للحروف ولعبة للأرقام',
                Icons.sports_esports_rounded, Color(0xFFFFB300)),
          ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(kg2 ? 'الروضة الثانية' : 'الروضة الأولى')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final s in sections) ...[
              App3DCard(
                onTap: () => _open(context, s.title),
                encouragement: '✨ ${s.title} ممتع!',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      s.color,
                      s.color.withValues(alpha: .7)
                    ]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .22),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(s.icon, color: Colors.white, size: 34),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.subtitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 13),
            ],
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'الحروف':
        page = _LettersPage(kg2: kg2);
        break;
      case 'الأرقام':
        page = _NumbersPage(kg2: kg2);
        break;
      case 'كتابة الحروف والأرقام':
        page = _WritingHubPage(kg2: kg2);
        break;
      case 'كتابة الحروف والأعداد':
        page = _WritingHubPage(kg2: kg2);
        break;
      case 'الألوان':
        page = _ColorsPage(kg2: kg2);
        break;
      case 'الأشكال':
        page = _ShapesPage(kg2: kg2);
        break;
      case 'الألعاب':
        page = const _GamesPage();
        break;
      default:
        page = const _StoriesGamesPage();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _Section {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  const _Section(this.title, this.subtitle, this.icon, this.color);
}

class _Page extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Page({required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: children,
          ),
        ),
      );
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MenuCard(this.title, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: App3DCard(
          onTap: onTap,
          encouragement: '✨ $title',
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 42),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)
              ],
            ),
          ),
        ),
      );
}

class _Button extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;
  const _Button(this.text, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: onTap ?? () {},
        encouragement: onTap == null ? null : '✨ $text',
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: onTap == null ? Colors.grey : color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      );
}

void _push(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));

class _LettersPage extends StatefulWidget {
  final bool kg2;
  const _LettersPage({required this.kg2});
  @override
  State<_LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<_LettersPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[index];
    final forms = _forms[item.letter] ?? [item.letter, item.letter, item.letter];
    return _Page(
      title: widget.kg2 ? 'الحروف وأشكالها' : 'الحروف العربية',
      children: [
        Text(
          'الحرف ${arNum(index + 1)} من ${arNum(28)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 12),
        widget.kg2 ? _FormsCard(item, forms) : _LetterCard(item),
        const SizedBox(height: 12),
        App3DCard(
          onTap: () => VoiceService.arabic(item.word),
          encouragement: '🗣️ اسمع الكلمة وكررها',
          child: ListTile(
            leading: Text(item.emoji, style: const TextStyle(fontSize: 38)),
            title: Text(
              item.word,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            subtitle: Text('كلمة تبدأ بحرف ${item.letter}'),
            trailing: const Icon(Icons.volume_up_rounded),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _Button(
                'السابق',
                const Color(0xFFE83E8C),
                index > 0 ? () => setState(() => index--) : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Button(
                '🔊 نطق الحرف',
                const Color(0xFF7652FF),
                () => VoiceService.arabicLetterSound(item.letter,
                    fallbackText: item.sound),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Button(
                'التالي',
                const Color(0xFF00A86B),
                index < 27 ? () => setState(() => index++) : null,
              ),
            )
          ],
        )
      ],
    );
  }
}

class _LetterCard extends StatelessWidget {
  final ArabicLetter item;
  const _LetterCard(this.item);
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: () => VoiceService.arabicLetterSound(item.letter,
            fallbackText: item.sound),
        encouragement: '🔊 هذا صوت الحرف عند القراءة',
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF7652FF), Color(0xFF536DFE)]),
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            children: [
              Text(
                item.letter,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 105,
                    fontWeight: FontWeight.w900),
              ),
              Text(
                'صوت القراءة: ${item.sound}',
                style: const TextStyle(
                    color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => VoiceService.arabic(item.letter),
                icon: const Icon(Icons.badge_outlined, color: Colors.white),
                label: const Text('اسم الحرف',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
}

class _FormsCard extends StatelessWidget {
  final ArabicLetter item;
  final List<String> forms;
  const _FormsCard(this.item, this.forms);
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: () => VoiceService.arabicLetterSound(item.letter,
            fallbackText: item.sound),
        encouragement: '🔊 استمع للحرف وشاهد أشكاله',
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                item.letter,
                style:
                    const TextStyle(fontSize: 72, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  3,
                  (i) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7652FF).withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            forms[i],
                            style: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            ['أولي', 'وسطي', 'أخري'][i],
                            style: const TextStyle(
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

const Map<String, List<String>> _forms = {
  'أ': ['أ', 'أ', 'أ'],
  'ب': ['بـ', 'ـبـ', 'ـب'],
  'ت': ['تـ', 'ـتـ', 'ـت'],
  'ث': ['ثـ', 'ـثـ', 'ـث'],
  'ج': ['جـ', 'ـجـ', 'ـج'],
  'ح': ['حـ', 'ـحـ', 'ـح'],
  'خ': ['خـ', 'ـخـ', 'ـخ'],
  'د': ['د', 'د', 'د'],
  'ذ': ['ذ', 'ذ', 'ذ'],
  'ر': ['ر', 'ر', 'ر'],
  'ز': ['ز', 'ز', 'ز'],
  'س': ['سـ', 'ـسـ', 'ـس'],
  'ش': ['شـ', 'ـشـ', 'ـش'],
  'ص': ['صـ', 'ـصـ', 'ـص'],
  'ض': ['ضـ', 'ـضـ', 'ـض'],
  'ط': ['طـ', 'ـطـ', 'ـط'],
  'ظ': ['ظـ', 'ـظـ', 'ـظ'],
  'ع': ['عـ', 'ـعـ', 'ـع'],
  'غ': ['غـ', 'ـغـ', 'ـغ'],
  'ف': ['فـ', 'ـفـ', 'ـف'],
  'ق': ['قـ', 'ـقـ', 'ـق'],
  'ك': ['كـ', 'ـكـ', 'ـك'],
  'ل': ['لـ', 'ـلـ', 'ـل'],
  'م': ['مـ', 'ـمـ', 'ـم'],
  'ن': ['نـ', 'ـنـ', 'ـن'],
  'ه': ['هـ', 'ـهـ', 'ـه'],
  'و': ['و', 'و', 'و'],
  'ي': ['يـ', 'ـيـ', 'ـي']
};

class _NumbersPage extends StatelessWidget {
  final bool kg2;
  const _NumbersPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _Page(
        title: 'الأرقام',
        children: [
          if (!kg2)
            const _NumberGrid(10, 'الأرقام من ١ إلى ١٠')
          else ...[
            _MenuCard(
              'الأعداد من ١ إلى ٥٠',
              Icons.pin_rounded,
              const Color(0xFF0097A7),
              () => _push(context, const _NumberGrid(50, 'الأعداد من ١ إلى ٥٠')),
            ),
            _MenuCard(
              'مراتب الأعداد: الآحاد والعشرات',
              Icons.account_tree_rounded,
              const Color(0xFF7652FF),
              () => _push(context, const _PlaceValuePage()),
            )
          ]
        ],
      );
}

class _NumberGrid extends StatelessWidget {
  final int max;
  final String title;
  const _NumberGrid(this.max, this.title);
  @override
  Widget build(BuildContext context) => _Page(
        title: title,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: max,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, i) {
              final n = i + 1;
              return App3DCard(
                onTap: () => VoiceService.arabic(_numberName(n)),
                encouragement: '🔊 ${arNum(n)}',
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF0097A7),
                      Color(0xFF26C6DA)
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      arNum(n),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      );
}

String _numberName(int n) {
  const a = [
    '',
    'واحد',
    'اثنان',
    'ثلاثة',
    'أربعة',
    'خمسة',
    'ستة',
    'سبعة',
    'ثمانية',
    'تسعة',
    'عشرة'
  ];
  if (n <= 10) return a[n];
  if (n < 20) {
    return n == 11
        ? 'أحد عشر'
        : n == 12
            ? 'اثنا عشر'
            : '${a[n - 10]} عشر';
  }
  const t = ['', '', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون'];
  final ten = n ~/ 10, one = n % 10;
  return one == 0 ? t[ten] : '${a[one]} و${t[ten]}';
}

class _PlaceValuePage extends StatefulWidget {
  const _PlaceValuePage();
  @override
  State<_PlaceValuePage> createState() => _PlaceValuePageState();
}

class _PlaceValuePageState extends State<_PlaceValuePage> {
  int number = 24;
  String selected = 'العشرات';
  @override
  Widget build(BuildContext context) {
    final tens = number ~/ 10, ones = number % 10;
    return _Page(
      title: 'مراتب الأعداد',
      children: [
        const Text(
          'درس تعليمي وليس اختبارًا: نحدد قيمة الرقم داخل العدد.',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 12),
        App3DCard(
          onTap: () => VoiceService.arabic(_numberName(number)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Center(
              child: Text(
                arNum(number),
                style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PlaceCard(
                'العشرات',
                tens,
                selected == 'العشرات',
                () => setState(() => selected = 'العشرات'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PlaceCard(
                'الآحاد',
                ones,
                selected == 'الآحاد',
                () => setState(() => selected = 'الآحاد'),
              ),
            ),
          ],
        ),
        Text(
          'الرقم المختار يقع في: $selected',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Slider(
          min: 10,
          max: 50,
          divisions: 40,
          value: number.toDouble(),
          label: arNum(number),
          onChanged: (v) => setState(() => number = v.round()),
        )
      ],
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String title;
  final int value;
  final bool active;
  final VoidCallback onTap;
  const _PlaceCard(this.title, this.value, this.active, this.onTap);
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: onTap,
        encouragement: '🌟 تعلم $title',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF7652FF).withValues(alpha: .15) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                arNum(value),
                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
              )
            ],
          ),
        ),
      );
}

class _WritingHubPage extends StatelessWidget {
  final bool kg2;
  const _WritingHubPage({required this.kg2});
  @override
  Widget build(BuildContext context) => _Page(
        title: 'الكتابة',
        children: [
          _MenuCard(
            kg2 ? 'الحروف: أولي ووسطي وأخري + دمج' : 'الحروف العربية: ٢٨ حرفًا',
            Icons.edit_rounded,
            const Color(0xFF00A86B),
            () => _push(context, _LetterWritingPage(kg2: kg2)),
          ),
          _MenuCard(
            kg2 ? 'الأرقام ١ إلى ٥٠ + القيمة المكانية' : 'الأرقام ١ إلى ١٠',
            Icons.numbers_rounded,
            const Color(0xFF0097A7),
            () => _push(context, _NumberWritingPage(kg2: kg2)),
          )
        ],
      );
}

class _LetterWritingPage extends StatefulWidget {
  final bool kg2;
  const _LetterWritingPage({required this.kg2});
  @override
  State<_LetterWritingPage> createState() => _LetterWritingPageState();
}

class _LetterWritingPageState extends State<_LetterWritingPage> {
  int index = 0;
  Color ink = const Color(0xFF3F51B5);
  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[index];
    final f = _forms[item.letter] ?? [item.letter, item.letter, item.letter];
    final guide = widget.kg2 ? f[index % 3] : item.letter;
    return _Page(
      title: 'اكتب على الشاشة',
      children: [
        Text(
          'اكتب: $guide',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        _WritingBoard(guide, ink, (c) => setState(() => ink = c)),
        if (widget.kg2) ...[
          const SizedBox(height: 10),
          _MergeLesson(index),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Button(
                'السابق',
                const Color(0xFFE83E8C),
                index > 0 ? () => setState(() => index--) : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Button(
                '🔊 اسمع',
                const Color(0xFF7652FF),
                () => VoiceService.arabicLetterSound(item.letter,
                    fallbackText: item.sound),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Button(
                'التالي',
                const Color(0xFF00A86B),
                index < 27 ? () => setState(() => index++) : null,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _MergeLesson extends StatelessWidget {
  final int index;
  const _MergeLesson(this.index);
  @override
  Widget build(BuildContext context) {
    const p = [
      ['د', 'ا'],
      ['د', 'و'],
      ['ن', 'ا'],
      ['د', 'ي'],
      ['ب', 'ا'],
      ['ب', 'و'],
      ['م', 'ا'],
      ['م', 'ي'],
      ['س', 'ا'],
      ['ل', 'ا'],
      ['ك', 'ا'],
      ['ف', 'ا'],
      ['ر', 'ا'],
      ['ش', 'ا'],
      ['ت', 'ا'],
      ['ج', 'ا'],
      ['ح', 'ا'],
      ['خ', 'ا'],
      ['ق', 'ا'],
      ['ع', 'ا']
    ];
    final x = p[index % p.length];
    final r = '${x[0]}${x[1]}';
    return App3DCard(
      onTap: () => VoiceService.arabic(r),
      encouragement: '🌟 ادمج الحرفين وانطقهما',
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text('تدريب دمج حرفين',
                style: TextStyle(fontWeight: FontWeight.w900)),
            Text(
              '${x[0]} + ${x[1]} = $r',
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}

class _NumberWritingPage extends StatefulWidget {
  final bool kg2;
  const _NumberWritingPage({required this.kg2});
  @override
  State<_NumberWritingPage> createState() => _NumberWritingPageState();
}

class _NumberWritingPageState extends State<_NumberWritingPage> {
  int index = 0;
  Color ink = const Color(0xFFE85D04);
  @override
  Widget build(BuildContext context) {
    final max = widget.kg2 ? 50 : 10;
    final n = index + 1;
    return _Page(
      title: 'كتابة الأرقام',
      children: [
        Text(
          'اكتب الرقم: ${arNum(n)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        _WritingBoard(arNum(n), ink, (c) => setState(() => ink = c)),
        if (widget.kg2) ...[
          const SizedBox(height: 10),
          _NumberPlaceHint(n),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Button(
                '🔊 اسمع',
                const Color(0xFF7652FF),
                () => VoiceService.arabic(_numberName(n)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Button(
                'التالي',
                const Color(0xFF00A86B),
                index < max - 1 ? () => setState(() => index++) : null,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _NumberPlaceHint extends StatelessWidget {
  final int number;
  const _NumberPlaceHint(this.number);
  @override
  Widget build(BuildContext context) => App3DCard(
        onTap: () => _push(context, const _PlaceValuePage()),
        encouragement: '🌟 تعلم القيمة المكانية',
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            number < 10
                ? 'هذا رقم آحاد.'
                : 'اضغط هنا لتتعلم الآحاد والعشرات داخل العدد.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
}

class _WritingBoard extends StatefulWidget {
  final String guide;
  final Color color;
  final ValueChanged<Color> onColor;
  const _WritingBoard(this.guide, this.color, this.onColor);
  @override
  State<_WritingBoard> createState() => _WritingBoardState();
}

class _WritingBoardState extends State<_WritingBoard> {
  final List<List<Offset>> strokes = [];
  List<Offset> current = [];

  void clear() => setState(() {
        strokes.clear();
      });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.color, width: 3),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 5),
                    color: Color(0x22000000))
              ],
            ),
            child: GestureDetector(
              onPanStart: (d) => setState(() => current = [d.localPosition]),
              onPanUpdate: (d) => setState(() {
                current = [...current, d.localPosition];
              }),
              onPanEnd: (_) {
                if (current.length > 1) {
                  strokes.add(List.of(current));
                }
                current = [];
                setState(() {});
              },
              child: CustomPaint(
                painter: _BoardPainter(widget.guide, widget.color, strokes, current),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('لون الكتابة: ',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              for (final c in [
                Colors.black,
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.pink
              ])
                GestureDetector(
                  onTap: () => widget.onColor(c),
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: widget.color == c ? Colors.white : Colors.transparent,
                          width: 3),
                    ),
                  ),
                )
            ],
          ),
          TextButton.icon(
            onPressed: clear,
            icon: const Icon(Icons.delete_outline),
            label: const Text('مسح الكتابة'),
          )
        ],
      );
}

class _BoardPainter extends CustomPainter {
  final String guide;
  final Color color;
  final List<List<Offset>> strokes, current;
  _BoardPainter(this.guide, this.color, this.strokes, this.current);
  @override
  void paint(Canvas c, Size s) {
    final tp = TextPainter(
      text: TextSpan(
        text: guide,
        style: TextStyle(
          fontSize: 180,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: .1),
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: s.width);
    tp.paint(c, Offset((s.width - tp.width) / 2, (s.height - tp.height) / 2));
    final p = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    void drawPath(List<Offset> x) {
      if (x.length < 2) return;
      final path = Path()..moveTo(x.first.dx, x.first.dy);
      for (final o in x.skip(1)) {
        path.lineTo(o.dx, o.dy);
      }
      c.drawPath(path, p);
    }
    for (final x in strokes) {
      drawPath(x);
    }
    drawPath(current);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter old) => true;
}

class _ColorsPage extends StatelessWidget {
  final bool kg2;
  const _ColorsPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    const data = [
      _ColorLesson('أبيض', Color(0xFFF5F5F5), 'حمامة', '🕊️'),
      _ColorLesson('أسود', Color(0xFF222222), 'غراب', '🐦'),
      _ColorLesson('أحمر', Color(0xFFE53935), 'تفاحة', '🍎'),
      _ColorLesson('أزرق', Color(0xFF1E88E5), 'سمكة', '🐟'),
      _ColorLesson('أخضر', Color(0xFF43A047), 'ضفدع', '🐸'),
      _ColorLesson('أصفر', Color(0xFFFDD835), 'نحلة', '🐝'),
      _ColorLesson('برتقالي', Color(0xFFFB8C00), 'برتقالة', '🍊'),
      _ColorLesson('بنفسجي', Color(0xFF8E24AA), 'فراشة', '🦋'),
      _ColorLesson('وردي', Color(0xFFD81B60), 'زهرة', '🌸'),
      _ColorLesson('بني', Color(0xFF795548), 'دب', '🐻'),
      _ColorLesson('رمادي', Color(0xFF757575), 'فيل', '🐘'),
      _ColorLesson('سماوي', Color(0xFF00ACC1), 'طائر', '🐦')
    ];
    return _Page(
      title: 'الألوان',
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .9,
          ),
          itemBuilder: (_, i) {
            final d = data[i];
            final light = d.color.computeLuminance() > .55;
            return App3DCard(
              onTap: () => _push(context, _ColorDrawPage(d)),
              encouragement: '🎨 هذا لون ${d.name}',
              child: Container(
                decoration: BoxDecoration(
                  color: d.color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(d.emoji, style: const TextStyle(fontSize: 44)),
                    Text(
                      d.name,
                      style: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '${d.animal} ${d.emoji}',
                      style: TextStyle(
                        color: light ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class _ColorLesson {
  final String name;
  final Color color;
  final String animal, emoji;
  const _ColorLesson(this.name, this.color, this.animal, this.emoji);
}

class _ColorDrawPage extends StatefulWidget {
  final _ColorLesson lesson;
  const _ColorDrawPage(this.lesson);
  @override
  State<_ColorDrawPage> createState() => _ColorDrawPageState();
}

class _ColorDrawPageState extends State<_ColorDrawPage> {
  final List<List<Offset>> strokes = [];
  List<Offset> current = [];

  @override
  Widget build(BuildContext context) => _Page(
        title: 'ارسم ${widget.lesson.animal}',
        children: [
          Text(
            '${widget.lesson.emoji} ${widget.lesson.animal} بلون ${widget.lesson.name}',
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Container(
            height: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: widget.lesson.color, width: 4),
            ),
            child: GestureDetector(
              onPanStart: (d) => setState(() => current = [d.localPosition]),
              onPanUpdate: (d) => setState(() {
                current = [...current, d.localPosition];
              }),
              onPanEnd: (_) {
                if (current.length > 1) {
                  strokes.add(List.of(current));
                }
                current = [];
                setState(() {});
              },
              child: CustomPaint(
                painter: _AnimalPainter(widget.lesson.emoji, widget.lesson.color,
                    strokes, current),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          _Button('🔊 انطق اللون', widget.lesson.color,
              () => VoiceService.arabic(widget.lesson.name)),
          TextButton.icon(
            onPressed: () => setState(() => strokes.clear()),
            icon: const Icon(Icons.delete_outline),
            label: const Text('مسح الرسم'),
          )
        ],
      );
}

class _AnimalPainter extends CustomPainter {
  final String emoji;
  final Color color;
  final List<List<Offset>> strokes, current;
  _AnimalPainter(this.emoji, this.color, this.strokes, this.current);
  @override
  void paint(Canvas c, Size s) {
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: 125, color: color)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset((s.width - tp.width) / 2, 45));
    final p = Paint()
      ..color = color
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    void drawPath(List<Offset> x) {
      if (x.length < 2) return;
      final path = Path()..moveTo(x.first.dx, x.first.dy);
      for (final o in x.skip(1)) {
        path.lineTo(o.dx, o.dy);
      }
      c.drawPath(path, p);
    }
    for (final x in strokes) {
      drawPath(x);
    }
    drawPath(current);
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter old) => true;
}

class _ShapesPage extends StatelessWidget {
  final bool kg2;
  const _ShapesPage({required this.kg2});
  @override
  Widget build(BuildContext context) {
    final names = kg2
        ? [
            'مربع',
            'مثلث',
            'دائرة',
            'مستطيل',
            'منحرف',
            'شبه منحرف',
            'خماسي',
            'سداسي',
            'ثماني',
            'بيضاوي'
          ]
        : ['مربع', 'مثلث', 'دائرة', 'مستطيل', 'منحرف', 'شبه منحرف'];
    return _Page(
      title: 'الأشكال',
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: names.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) => App3DCard(
            onTap: () => VoiceService.arabic(names[i]),
            encouragement: '🔷 ${names[i]}',
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: _ShapePainter(i),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Text(
                    names[i],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _ShapePainter extends CustomPainter {
  final int type;
  _ShapePainter(this.type);
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = Colors.primaries[type % Colors.primaries.length]
          .withValues(alpha: .82);
    final x = s.width / 2, y = s.height / 2;
    final w = s.width * .32, h = s.height * .32;
    final path = Path();
    if (type == 0) {
      c.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: w * 2, height: h * 2),
          p);
    } else if (type == 1) {
      path.moveTo(x, y - h);
      path.lineTo(x - w, y + h);
      path.lineTo(x + w, y + h);
      path.close();
      c.drawPath(path, p);
    } else if (type == 2) {
      c.drawCircle(Offset(x, y), w, p);
    } else if (type == 3) {
      c.drawRect(
          Rect.fromCenter(
              center: Offset(x, y), width: w * 2.1, height: h * 1.4),
          p);
    } else if (type == 4) {
      path.moveTo(x - w, y + h);
      path.lineTo(x + w, y + h);
      path.lineTo(x + w * .65, y - h);
      path.lineTo(x - w * .65, y - h);
      path.close();
      c.drawPath(path, p);
    } else if (type == 5) {
      path.moveTo(x - w, y + h);
      path.lineTo(x + w, y + h);
      path.lineTo(x + w * .7, y - h);
      path.lineTo(x - w * .7, y - h);
      path.close();
      c.drawPath(path, p);
    } else {
      final points = [
        Offset(x, y - h),
        Offset(x + w * .7, y - h * .35),
        Offset(x + w * .7, y + h * .45),
        Offset(x + w * .25, y + h),
        Offset(x - w * .25, y + h),
        Offset(x - w * .7, y + h * .45),
        Offset(x - w * .7, y - h * .35)
      ];
      for (final q in points) {
        if (path.getBounds().isEmpty) {
          path.moveTo(q.dx, q.dy);
        } else {
          path.lineTo(q.dx, q.dy);
        }
      }
      path.close();
      c.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) => old.type != type;
}

class _GamesPage extends StatelessWidget {
  const _GamesPage();
  @override
  Widget build(BuildContext context) => _Page(
        title: 'الألعاب',
        children: [
          _MenuCard(
            'لعبة الحروف',
            Icons.abc_rounded,
            const Color(0xFF7652FF),
            () => _push(context, const _LetterGame()),
          ),
          _MenuCard(
            'لعبة الأرقام',
            Icons.numbers_rounded,
            const Color(0xFF0097A7),
            () => _push(context, const _NumberGame()),
          )
        ],
      );
}

class _LetterGame extends StatefulWidget {
  const _LetterGame();
  @override
  State<_LetterGame> createState() => _LetterGameState();
}

class _LetterGameState extends State<_LetterGame> {
  int i = 0;

  void answer(String v) {
    if (v == arabicLetters[i].letter) {
      AppFeedback.show('🌟 أحسنت! إجابة صحيحة');
      setState(() => i = (i + 1) % 28);
    } else {
      AppFeedback.show('💪 حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = arabicLetters[i];
    final options = [
      item.letter,
      arabicLetters[(i + 5) % 28].letter,
      arabicLetters[(i + 11) % 28].letter
    ]..shuffle();
    return _Page(
      title: 'لعبة الحروف',
      children: [
        const Text(
          'استمع ثم اختر الحرف الصحيح',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        _Button(
          '🔊 استمع',
          const Color(0xFF7652FF),
          () => VoiceService.arabicLetterSound(item.letter,
              fallbackText: item.sound),
        ),
        for (final o in options)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Button(o, const Color(0xFF0097A7), () => answer(o)),
          )
      ],
    );
  }
}

class _NumberGame extends StatefulWidget {
  const _NumberGame();
  @override
  State<_NumberGame> createState() => _NumberGameState();
}

class _NumberGameState extends State<_NumberGame> {
  int target = 1;

  void answer(int v) {
    if (v == target) {
      AppFeedback.show('🌟 بطل! الرقم صحيح');
      setState(() => target = target == 10 ? 1 : target + 1);
    } else {
      AppFeedback.show('💪 حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      target,
      target == 10 ? 1 : target + 1,
      target > 2 ? target - 2 : 8
    ]..shuffle();
    return _Page(
      title: 'لعبة الأرقام',
      children: [
        const Text(
          'استمع ثم اختر الرقم الصحيح',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        _Button(
          '🔊 استمع',
          const Color(0xFF0097A7),
          () => VoiceService.arabic(_numberName(target)),
        ),
        for (final n in options)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _Button(arNum(n), const Color(0xFF00A86B), () => answer(n)),
          )
      ],
    );
  }
}

class _StoriesGamesPage extends StatelessWidget {
  const _StoriesGamesPage();
  @override
  Widget build(BuildContext context) => _Page(
        title: 'القصص والألعاب',
        children: [
          _MenuCard(
            'قصتان تعليميتان مسموعتان',
            Icons.menu_book_rounded,
            const Color(0xFFE83E8C),
            () => _push(context, const _StoriesPage()),
          ),
          _MenuCard(
            'لعبة الحروف ودمج حرفين',
            Icons.extension_rounded,
            const Color(0xFF7652FF),
            () => _push(context, const _MergeGame()),
          ),
          _MenuCard(
            'لعبة الآحاد',
            Icons.looks_one_rounded,
            const Color(0xFF00A86B),
            () => _push(context, const _PlaceGame(false)),
          ),
          _MenuCard(
            'لعبة العشرات',
            Icons.looks_two_rounded,
            const Color(0xFF0097A7),
            () => _push(context, const _PlaceGame(true)),
          )
        ],
      );
}

class _MergeGame extends StatefulWidget {
  const _MergeGame();
  @override
  State<_MergeGame> createState() => _MergeGameState();
}

class _MergeGameState extends State<_MergeGame> {
  int i = 0;
  static const pairs = [
    ['د', 'ا'],
    ['د', 'و'],
    ['ن', 'ا'],
    ['د', 'ي'],
    ['ب', 'ا'],
    ['ب', 'و'],
    ['م', 'ا'],
    ['م', 'ي'],
    ['س', 'ا'],
    ['ل', 'ا'],
    ['ك', 'ا'],
    ['ف', 'ا'],
    ['ر', 'ا'],
    ['ش', 'ا'],
    ['ت', 'ا'],
    ['ج', 'ا'],
    ['ح', 'ا'],
    ['خ', 'ا'],
    ['ق', 'ا'],
    ['ع', 'ا']
  ];

  @override
  Widget build(BuildContext context) {
    final x = pairs[i];
    final r = '${x[0]}${x[1]}';
    return _Page(
      title: 'دمج حرفين',
      children: [
        App3DCard(
          onTap: () => VoiceService.arabic(r),
          encouragement: '🌟 ادمج الحرفين وانطقهما',
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '${x[0]} + ${x[1]}',
                  style: const TextStyle(
                      fontSize: 38, fontWeight: FontWeight.w900),
                ),
                Text(
                  r,
                  style: const TextStyle(
                      fontSize: 55, fontWeight: FontWeight.w900),
                ),
                _Button(
                  '🔊 اسمع',
                  const Color(0xFF7652FF),
                  () => VoiceService.arabic(r),
                ),
                _Button(
                  'النموذج التالي',
                  const Color(0xFF00A86B),
                  () => setState(() => i = (i + 1) % pairs.length),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _PlaceGame extends StatefulWidget {
  final bool tens;
  const _PlaceGame(this.tens);
  @override
  State<_PlaceGame> createState() => _PlaceGameState();
}

class _PlaceGameState extends State<_PlaceGame> {
  int number = 24;

  void answer(String v) {
    final correct = widget.tens ? 'العشرات' : 'الآحاد';
    if (v == correct) {
      AppFeedback.show('🌟 صحيح! أحسنت');
      setState(() => number = number >= 50 ? 10 : number + 1);
    } else {
      AppFeedback.show('💪 حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    final digit = widget.tens ? number ~/ 10 : number % 10;
    return _Page(
      title: widget.tens ? 'لعبة العشرات' : 'لعبة الآحاد',
      children: [
        Text(
          'العدد ${arNum(number)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w900),
        ),
        Text(
          'الرقم المطلوب: ${arNum(digit)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 14),
        _Button('الآحاد', const Color(0xFF7652FF), () => answer('الآحاد')),
        _Button('العشرات', const Color(0xFF0097A7), () => answer('العشرات'))
      ],
    );
  }
}

class _StoriesPage extends StatelessWidget {
  const _StoriesPage();
  @override
  Widget build(BuildContext context) {
    final list = stories.take(2).toList();
    return _Page(
      title: 'قصص تعليمية',
      children: [
        for (final s in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: App3DCard(
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: Text('${s['emoji'] ?? '📖'} ${s['title'] ?? ''}'),
                    content: SingleChildScrollView(
                      child: Text(
                        s['text'] ?? '',
                        style: const TextStyle(fontSize: 18, height: 1.7),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => VoiceService.arabic(s['text'] ?? ''),
                        child: const Text('🔊 استمع'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      )
                    ],
                  ),
                ),
              ),
              encouragement: '📖 افتح القصة واستمع',
              child: ListTile(
                leading: Text(
                  s['emoji'] ?? '📖',
                  style: const TextStyle(fontSize: 38),
                ),
                title: Text(
                  s['title'] ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900),
                ),
                subtitle: const Text('قراءة واستماع صوتي'),
              ),
            ),
          )
      ],
    );
  }
}
