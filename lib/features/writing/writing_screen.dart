import 'package:flutter/material.dart';
class WritingScreen extends StatefulWidget{const WritingScreen({super.key});@override State<WritingScreen> createState()=>_S();}
class _S extends State<WritingScreen>{final points=<Offset>[];int index=0;final chars=['ا','ب','ت','م','ن','ي'];String get letter=>chars[index];
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('الكتابة والرسم'),actions:[IconButton(onPressed:()=>setState(points.clear),icon:const Icon(Icons.delete_outline))]),body:Column(children:[
  const SizedBox(height:8),const Text('تتبع الحرف ثم اكتبه بإصبعك',style:TextStyle(fontSize:20)),Text(letter,style:const TextStyle(fontSize:95,fontWeight:FontWeight.bold)),
  Expanded(child:GestureDetector(onPanStart:(d)=>setState(()=>points.add(d.localPosition)),onPanUpdate:(d)=>setState(()=>points.add(d.localPosition)),child:CustomPaint(painter:DrawingPainter(points),child:Container(color:Colors.white)))),
  Row(children:[Expanded(child:OutlinedButton(onPressed:()=>setState((){index=(index-1+chars.length)%chars.length;points.clear();}),child:const Text('الحرف السابق'))),Expanded(child:FilledButton(onPressed:()=>setState((){index=(index+1)%chars.length;points.clear();}),child:const Text('الحرف التالي')))])
 ]));}
}
class DrawingPainter extends CustomPainter{final List<Offset> p;DrawingPainter(this.p);@override void paint(Canvas c,Size s){final pen=Paint()..strokeWidth=7..strokeCap=StrokeCap.round;for(int i=1;i<p.length;i++)c.drawLine(p[i-1],p[i],pen);}@override bool shouldRepaint(covariant DrawingPainter old)=>true;}
