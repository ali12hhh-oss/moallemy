import 'package:flutter_test/flutter_test.dart';import 'package:daleel_child/main.dart';
void main(){testWidgets('Daleel Child starts', (tester) async {await tester.pumpWidget(const DaleelChildApp());expect(find.text('دليل الطفل'),findsWidgets);});}
