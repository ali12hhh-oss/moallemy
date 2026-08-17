import 'package:flutter/material.dart';
import '../../core/localization/arabic_numbers.dart';

class NumbersScreenV6 extends StatefulWidget{const NumbersScreenV6({super.key});@override State<NumbersScreenV6> createState()=>_N();}
class _N extends State<NumbersScreenV6>{String stage='الروضة الأولى';final stages=<String,int>{'الروضة الأولى':10,'الروضة الثانية':20,'التمهيدي':100,'الصف الأول':1000,'الصف الثاني':10000,'الصف الثالث':1000000};
 @override Widget build(BuildContext c){final max=stages[stage]!;final samples=max<=100?List<int>.generate(max,(i)=>i+1):[1,5,10,25,50,100,250,500,1000,2500,5000,10000,25000,50000,100000,250000,500000,750000,999999,1000000].where((n)=>n<=max).toList();return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('الأعداد حسب المرحلة')),body:Column(children:[
 Padding(padding:const EdgeInsets.all(10),child:DropdownButtonFormField<String>(value:stage,decoration:const InputDecoration(labelText:'المرحلة الدراسية'),items:stages.keys.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),onChanged:(x){if(x!=null)setState(()=>stage=x);})),
 Card(margin:const EdgeInsets.all(10),child:ListTile(title:const Text('الحد الأعلى لهذه المرحلة'),trailing:Text(arNum(max),style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)))),
 Expanded(child:GridView.builder(padding:const EdgeInsets.all(12),gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:8,mainAxisSpacing:8,childAspectRatio:1.05),itemCount:samples.length,itemBuilder:(_,i){final n=samples[i];return Card(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(arNum(n),style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold)),if(n==max)const Text('نهاية المرحلة',style:TextStyle(fontSize:12))]));}))
 ])));}}
