import 'package:flutter_test/flutter_test.dart';

import 'package:hear_o/main.dart';

void main() {
  testWidgets('Home overlay shows start button', (WidgetTester tester) async {
    await tester.pumpWidget(const HearOApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Start Adventure'), findsOneWidget);
  });
}
