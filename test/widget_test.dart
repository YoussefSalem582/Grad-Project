// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:emosense_mobile/main.dart';

void main() {
  testWidgets('Emosense app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EmosenseApp());

    // Verify that our app contains the main elements
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Teams'), findsOneWidget);
    expect(find.text('Live Monitor'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
