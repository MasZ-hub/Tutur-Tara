import 'package:flutter_test/flutter_test.dart';

import 'package:tutur_tara/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TuturTaraApp());

    // Verify the app title is displayed
    expect(find.text('Tutur-Tara'), findsOneWidget);
  });
}
