import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/content.dart';
import '../../data/content_v11.dart';
import '../../core/localization/arabic_numbers.dart';
import '../../core/audio/voice_service.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});
  @override State<GamesScreen> createState() => _GamesScreenState();
}
class _GamesScreenState extends State<GamesScreen> {
  final r=Random(); int mode=0, score=0;
  late ArabicLetter target; List<ArabicLetter> options=[];
  List<ArabicWordV11> match=[]; int numberTarget=0; List<int> numberOptions=[];
  @override void initState(){super.initState();nextHunter();nextMatch();nextNumber();}
  void nextHunter(){target=arabicLetters[r.nextInt(arabicLetters.length)];final s=<ArabicLetter>{target};while(s.length<4){s.add(arabicLetters[r.nextInt(arabicLetters.length)]);}options=s.toList()..shuffle();}
  void nextMatch(){final shuffled=[...arabicWordsV11]..shuffle(r);match=shuffled.take(4).toList();}
  void nextNumber(){numberTarget=1+r.nextInt(20);final s=<int>{numberTarget};while(s.length<4){s.add(1+r.nextInt(20));}numberOptions=s.toList()..shuffle();}
  @override Widget build(BuildContext c){return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('الألعاب التعليمية')),body:Column(children:[
    Padding(padding:const EdgeInsets.all(10),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
      ChoiceChip(label:const Text('🎯 صائد الحروف'),selected:mode==0,onSelected:(_){setState(()=>mode=0);}),
      const SizedBox(width:6),ChoiceChip(label:const Text('🧩 طابق الصورة'),selected:mode==1,onSelected:(_){setState(()=>mode=1);}),
      const SizedBox(width:6),ChoiceChip(label:const Text('🔢 عدّاء الأعداد'),selected:mode==2,onSelected:(_){setState(()=>mode=2);}),
    ])),
    Expanded(child:mode==0?_hunter(c):mode==1?_match(c):_numbers(c)),
  ])));}
  Widget _hunter(BuildContext c){return ListView(padding:const EdgeInsets.all(18),children:[Text('النجوم: ${arNum(score)} ⭐',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:22),Text(target.emoji,style:const TextStyle(fontSize:80)),Text('اسمع الصوت وابحث عن الحرف المناسب لكلمة ${target.word}',textAlign:TextAlign.center,style:const TextStyle(fontSize:22)),const SizedBox(height:12),FilledButton.icon(onPressed:()=>VoiceService.arabic(target.sound),icon:const Icon(Icons.volume_up),label:const Text('استمع إلى صوت الحرف')),const SizedBox(height:20),for(final x in options)Padding(padding:const EdgeInsets.only(bottom:9),child:SizedBox(width:double.infinity,child:FilledButton.tonal(onPressed:(){final ok=x.letter==target.letter;if(ok)score++;ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(ok?'أحسنت! 🎉':'حاول مرة أخرى 💪')));setState(nextHunter);},child:Text(x.letter,style:const TextStyle(fontSize:30)))))]);}
  Widget _match(BuildContext c){return GridView.builder(padding:const EdgeInsets.all(18),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10),itemCount:match.length,itemBuilder:(_,i){final x=match[i];return Card(child:InkWell(onTap:(){setState(()=>score++);ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text('وجدت ${x.word} ${x.emoji}')));nextMatch();setState((){});},child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(x.emoji,style:const TextStyle(fontSize:52)),Text(x.word,style:const TextStyle(fontSize:23,fontWeight:FontWeight.bold)),Text('يبدأ بالحرف ${x.letter}')])));});}
  Widget _numbers(BuildContext c){return ListView(padding:const EdgeInsets.symmetric(vertical:40),children:[Text('اختر العدد المطلوب',textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)),const SizedBox(height:12),Text(arNum(numberTarget),textAlign:TextAlign.center,style:const TextStyle(fontSize:70,fontWeight:FontWeight.w900)),const SizedBox(height:18),for(final n in numberOptions)Padding(padding:const EdgeInsets.symmetric(horizontal:30,vertical:4),child:SizedBox(width:double.infinity,child:FilledButton.tonal(onPressed:(){final ok=n==numberTarget;if(ok)score++;ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text(ok?'إجابة صحيحة ⭐':'حاول مرة أخرى')));setState(nextNumber);},child:Text(arNum(n),style:const TextStyle(fontSize:26)))))]);}
}
