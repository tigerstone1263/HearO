import 'package:flutter_test/flutter_test.dart';

import 'package:hear_o/main.dart';

void main() {
  testWidgets('Home overlay shows start button', (WidgetTester tester) async {
    await tester.pumpWidget(const HearOApp());
    expect(find.text('Start Adventure'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();

    expect(find.text('Start Adventure'), findsOneWidget);
    expect(find.text('Slot 01 · Midnight Run'), findsOneWidget);
  });
}
