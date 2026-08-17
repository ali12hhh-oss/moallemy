import 'package:flutter/material.dart';import '../../data/content.dart';import '../../core/audio/voice_service.dart';import '../../core/localization/arabic_numbers.dart';
import 'arabic_grammar_screen_v12.dart';
class ArabicLearningScreen extends StatelessWidget{
 const ArabicLearningScreen({super.key});
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('خطة اللغة العربية')),body:ListView(padding:const EdgeInsets.all(16),children:[
  const Text('المراحل التعليمية',style:TextStyle(fontSize:25,fontWeight:FontWeight.bold)),const SizedBox(height:10),
  Card(child:ListTile(leading:const Text('📚',style:TextStyle(fontSize:30)),title:const Text('حروف الجر والـ التعريف'),subtitle:const Text('تعلم القواعد بأمثلة وتمارين مناسبة للعمر'),trailing:const Icon(Icons.arrow_back),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>const ArabicGrammarScreenV12())))),const SizedBox(height:10),
  ...lessons.map((l)=>Card(child:ListTile(leading:CircleAvatar(child:Text(l.icon)),title:Text(l.title),subtitle:Text('${l.stage} • ${l.description}'),trailing:Text(arNum(l.level)))),
  const SizedBox(height:12),const Text('الحركات',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold)),
  Card(child:Column(children:[
   ListTile(title:const Text('فَتْحَة َ'),trailing:IconButton(onPressed:()=>VoiceService.arabic('بَ'),icon:const Icon(Icons.volume_up))),
   ListTile(title:const Text('كَسْرَة ِ'),trailing:IconButton(onPressed:()=>VoiceService.arabic('بِ'),icon:const Icon(Icons.volume_up))),
   ListTile(title:const Text('ضَمَّة ُ'),trailing:IconButton(onPressed:()=>VoiceService.arabic('بُ'),icon:const Icon(Icons.volume_up))),
   ListTile(title:const Text('سُكون ْ'),trailing:IconButton(onPressed:()=>VoiceService.arabic('أبْ'),icon:const Icon(Icons.volume_up)))
  ]))
 ])));
}
