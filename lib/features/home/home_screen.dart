import 'package:flutter/material.dart';
import '../../core/learning/adaptive_learning_engine_v9.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../widgets/animated_mascot.dart';
import '../../widgets/menu_card.dart';
import '../../data/curriculum_v8.dart';
import '../../data/content_v11.dart';
import '../arabic/arabic_learning_screen.dart';
import '../arabic/arabic_grammar_screen_v12.dart';
import '../children/children_screen.dart';
import '../curriculum/curriculum_screen.dart';
import '../english/english_home_screen.dart';
import '../english/english_phonics_rules_screen_v12.dart';
import '../games/games_screen.dart';
import '../games/games_screen_v11.dart';
import '../letters/letters_screen.dart';
import '../numbers/numbers_screen_v6.dart';
import '../math/multiplication_screen_v13.dart';
import '../parent/parent_dashboard_v8.dart';
import '../parents/parents_screen.dart';
import '../quiz/quiz_screen.dart';
import '../sentence/sentence_screen.dart';
import '../settings/settings_screen.dart';
import '../shop/shop_screen.dart';
import '../stories/stories_screen.dart';
import '../word_bank/expanded_word_bank_screen.dart';
import '../word_bank/word_bank_screen.dart';
import '../writing/writing_screen.dart';
import '../learning/learning_plan_screen_v9.dart';
import '../math/math_curriculum_screen_v14.dart';
import '../math/math_curriculum_screen_v15.dart';
import '../arabic/arabic_curriculum_screen_v16.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double mastery = 0;
  List<LearningRecommendationV9> recommendations = const [];
  final stage = curriculumV8.first;

  @override
  void initState() { super.initState(); _loadLearning(); }

  Future<void> _loadLearning() async {
    final m = await AdaptiveLearningEngineV9.stageMastery(stage);
    final r = await AdaptiveLearningEngineV9.recommendations(stage, <String>{});
    if (mounted) setState(() { mastery = m; recommendations = r; });
  }

  void open(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext c) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('🌈 معلمي', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(tooltip: 'الإعدادات', onPressed: () => open(c, const SettingsScreen()), icon: const Icon(Icons.settings_rounded))],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLearning,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _hero(c),
            const SizedBox(height: 14),
            _smartMission(c),
            const SizedBox(height: 14),
            _sectionTitle('منهجك اليوم', 'تعلم خطوة صغيرة كل يوم'),
            MenuCard(title:'اللغة العربية — المنهج الكامل',subtitle:'الصوتيات والقراءة والقواعد والكتابة',emoji:'📚',image:'assets/images/letters.png',onTap:()=>open(c,ArabicCurriculumScreenV16(grade:3))),
            MenuCard(title:'الرياضيات — المنهج الكامل',subtitle:'مهارات حقيقية وتدريبات وألعاب',emoji:'🧮',image:'assets/images/numbers_v6.png',onTap:()=>open(c,MathCurriculumScreenV15(grade:3))),
            MenuCard(title:'رياضيات ومهارات الحساب',subtitle:'جمع وطرح وقيمة مكانية وأنماط ومسائل',emoji:'🔢',image:'assets/images/numbers_v6.png',onTap:()=>open(c,MathCurriculumScreenV14(grade:3))),
            MenuCard(title:'المنهج الدراسي',subtitle:'خطة تعلم مرتبة حسب العمر والصف',emoji:'🎓',image:'assets/images/curriculum.png',onTap:()=>open(c,const CurriculumScreen())),
            MenuCard(title:'خطة التعلم الذكية',subtitle:'تتكيف مع إجابات الطفل ومهاراته',emoji:'🧠',image:'assets/images/mascot.png',onTap:()=>open(c,LearningPlanScreenV9(stage:stage,completedUnits:const <String>{}))),
            const SizedBox(height:4),
            _sectionTitle('تعلم واكتشف', 'العربية والرياضيات والإنجليزية'),
            Card(child:ListTile(leading:const Text('📚',style:TextStyle(fontSize:32)),title:Text('محتوى المرحلة ١١',style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('أكثر من ${arNum(arabicWordsV11.length)} كلمة عربية • ${arNum(englishWordsV11.length)} كلمة English • ${arNum(storiesV11.length)} قصص موسعة • ${arNum(gamesV11.length)} ألعاب'),)),
            MenuCard(title:'الحروف العربية',subtitle:'صوت الحرف أولاً ثم اسم الحرف والكلمة والصورة',emoji:'🔤',image:'assets/images/letters.png',onTap:()=>open(c,const LettersScreen())),
            MenuCard(title:'خطة اللغة العربية',subtitle:'الحروف والحركات والقراءة والكتابة',emoji:'📚',image:'assets/images/phonics.png',onTap:()=>open(c,const ArabicLearningScreen())),
            MenuCard(title:'قواعد القراءة العربية',subtitle:'حروف الجر والـ التعريف واللام الشمسية والقمرية',emoji:'📝',image:'assets/images/phonics.png',onTap:()=>open(c,const ArabicGrammarScreenV12())),
            MenuCard(title:'جدول الضرب',subtitle:'الصف الأول اختياري ١–٢ • الثاني ١–٥ • الثالث ١–١٠',emoji:'✖️',image:'assets/images/numbers_v6.png',onTap:()=>open(c,const MultiplicationScreenV13())),
            MenuCard(title:'الأرقام ٠–١٠٠',subtitle:'الأعداد العربية والعد والأنشطة',emoji:'🔢',image:'assets/images/numbers_v6.png',onTap:()=>open(c,const NumbersScreenV6())),
            MenuCard(title:'اللغة الإنجليزية',subtitle:'حروف وأصوات وكلمات وألوان وأرقام',emoji:'🇬🇧',image:'assets/images/english.png',onTap:()=>open(c,const EnglishHomeScreen())),
            MenuCard(title:'English Phonics',subtitle:'sh و ch و th وغيرها: الصوت ثم القراءة والكلمة',emoji:'🔊',image:'assets/images/english.png',onTap:()=>open(c,const EnglishPhonicsRulesScreenV12())),
            MenuCard(title:'الكلمات والصور — الموسوعة الموسعة',subtitle:'كلمات مرتبة مع الصوت والصورة والإيموجي',emoji:'📚',image:'assets/images/words_v6.png',onTap:()=>open(c,const ExpandedWordBankScreen())),
            MenuCard(title:'القراءة والفهم',subtitle:'جمل قصيرة مع نطق ومتابعة القراءة',emoji:'📖',image:'assets/images/stories.png',onTap:()=>open(c,const SentenceScreen())),
            MenuCard(title:'الكتابة والرسم',subtitle:'تتبع الحرف وارسمه بإصبعك',emoji:'✏️',image:'assets/images/writing.png',onTap:()=>open(c,const WritingScreen())),
            const SizedBox(height:4),
            _sectionTitle('العب واربح', 'التعلم يصبح أجمل مع اللعب'),
            MenuCard(title:'الألعاب التعليمية',subtitle:'ألعاب تفاعلية مرتبطة بالمهارات',emoji:'🎮',image:'assets/images/games.png',onTap:()=>open(c,const GamesScreenV11())),
            MenuCard(title:'القصص',subtitle:'قصص تعليمية وترفيهية مع قراءة صوتية',emoji:'📖',image:'assets/images/stories.png',onTap:()=>open(c,const StoriesScreen())),
            MenuCard(title:'الاختبارات',subtitle:'اختبارات قصيرة ونتائج ونجوم',emoji:'🏆',image:'assets/images/games.png',onTap:()=>open(c,const QuizScreen())),
            MenuCard(title:'متجر النجوم',subtitle:'استبدل النجوم بجوائز تشجيعية',emoji:'⭐',image:'assets/images/shop.png',onTap:()=>open(c,const ShopScreen())),
            const SizedBox(height:4),
            _sectionTitle('متابعة الأسرة', 'تقدم الطفل في مكان واحد'),
            MenuCard(title:'لوحة الوالدين',subtitle:'المهارات والاختبارات والوقت والإنجازات',emoji:'👨‍👩‍👧',image:'assets/images/parents.png',onTap:()=>open(c,const ParentDashboardV8())),
            MenuCard(title:'ملفات الأطفال',subtitle:'ملف مستقل لكل طفل',emoji:'👧',image:'assets/images/parent.png',onTap:()=>open(c,const ChildrenScreen())),
            MenuCard(title:'إدارة الوالدين',subtitle:'إعدادات المتابعة والحماية',emoji:'🔒',image:'assets/images/parent.png',onTap:()=>open(c,const ParentsScreen())),
            MenuCard(title:'موسوعة الكلمات',subtitle:'كلمات إضافية مصنفة',emoji:'📚',image:'assets/images/letters.png',onTap:()=>open(c,const WordBankScreen())),
          ],
        ),
      ),
    ),
  );

  Widget _hero(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin:Alignment.topRight,end:Alignment.bottomLeft,colors:[Theme.of(context).colorScheme.primaryContainer,Theme.of(context).colorScheme.secondaryContainer])),
      padding: const EdgeInsets.all(20),
      child: Row(children:[
        const AnimatedMascot(asset:'assets/images/mascot.png',size:88),
        const SizedBox(width:14),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('👋 أهلاً يا بطل!',style:TextStyle(fontSize:26,fontWeight:FontWeight.w800)),
          const SizedBox(height:6),
          const Text('تعلم كل يوم خطوة جديدة واستمتع بالرحلة.',style:TextStyle(fontSize:16)),
          const SizedBox(height:12),
          Text('إتقان المرحلة: ${arNum((mastery*100).round())}٪',style:const TextStyle(fontWeight:FontWeight.bold)),
          const SizedBox(height:6),
          ClipRRect(borderRadius:BorderRadius.circular(20),child:LinearProgressIndicator(minHeight:9,value:mastery)),
        ])),
      ]),
    ),
  );

  Widget _smartMission(BuildContext context) {
    final rec = recommendations.isEmpty ? null : recommendations.first;
    return Card(child:Padding(padding:const EdgeInsets.all(18),child:Row(children:[
      CircleAvatar(radius:27,child:Text(rec?.icon ?? '🌟',style:const TextStyle(fontSize:24))),const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('مهمتك الذكية',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
        Text(rec?.title ?? 'ابدأ درساً جديداً',style:const TextStyle(fontSize:16)),
        Text(rec?.reason ?? 'سنختار لك نشاطاً مناسباً لمستواك.'),
      ])),
    ])));
  }

  Widget _sectionTitle(String title,String subtitle)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800)),Text(subtitle)]));
}
