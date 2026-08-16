import 'package:flutter/material.dart';
import '../../models/child.dart';
import '../../core/storage/app_storage.dart';
import '../../core/localization/arabic_numbers.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key});
  @override State<ChildrenScreen> createState() => _ChildrenScreenState();
}
class _ChildrenScreenState extends State<ChildrenScreen> {
  List<Child> kids=[];
  @override void initState(){super.initState();load();}
  Future<void> load() async { final x=await AppStorage.getChildren(); if(mounted)setState(()=>kids=x); }
  Future<void> add() async {
    final name=TextEditingController(); int age=6; bool saved=false;
    await showDialog<void>(context:context,builder:(dialogContext){
      return StatefulBuilder(builder:(context,setDialogState){
        return AlertDialog(
          title:const Text('إضافة طفل'),
          content:Column(mainAxisSize:MainAxisSize.min,children:[
            TextField(controller:name,decoration:const InputDecoration(labelText:'اسم الطفل')),
            const SizedBox(height:10),
            DropdownButton<int>(value:age,isExpanded:true,items:[4,5,6,7,8,9].map((x)=>DropdownMenuItem<int>(value:x,child:Text('${arNum(x)} سنوات'))).toList(),onChanged:(v){if(v!=null)setDialogState(()=>age=v);}),
          ]),
          actions:[
            TextButton(onPressed:()=>Navigator.pop(context),child:const Text('إلغاء')),
            FilledButton(onPressed:(){
              if(name.text.trim().isEmpty)return;
              final stage=age<=4?'الروضة الأولى':age==5?'الروضة الثانية':age==6?'التمهيدي':age==7?'الصف الأول':age==8?'الصف الثاني':'الصف الثالث';
              kids.add(Child(id:DateTime.now().microsecondsSinceEpoch.toString(),name:name.text.trim(),age:age,stage:stage));
              saved=true; Navigator.pop(context);
            },child:const Text('حفظ')),
          ],
        );
      });
    });
    if(saved){await AppStorage.saveChildren(kids);if(mounted)setState((){});}
  }
  @override Widget build(BuildContext context){
    final body=kids.isEmpty?const Center(child:Text('أضف أول ملف لطفلك للبدء.',style:TextStyle(fontSize:20))):ListView(padding:const EdgeInsets.all(16),children:[
      for(final k in kids) Card(child:ListTile(leading:const CircleAvatar(child:Text('👦')),title:Text(k.name),subtitle:Text('${arNum(k.age)} سنوات • ${k.stage} • ${arNum(k.stars)} نجمة'),trailing:const Icon(Icons.check_circle_outline),onTap:()async{await AppStorage.setActive(k.id);if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم اختيار الطفل الحالي')));}))
    ]);
    return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('ملفات الأطفال')),floatingActionButton:FloatingActionButton.extended(onPressed:add,label:const Text('إضافة طفل'),icon:const Icon(Icons.add)),body:body));
  }
}
