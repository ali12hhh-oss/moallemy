import 'package:flutter_test/flutter_test.dart';
import 'package:daleel_child/app/app.dart';

void main() {
  testWidgets('معلمي starts', (tester) async {
    await tester.pumpWidget(const DaleelChildApp());
    await tester.pumpAndSettle();
    expect(find.text('🌈 معلمي'), findsOneWidget);
  });
}
