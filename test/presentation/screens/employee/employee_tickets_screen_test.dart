import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emosense_mobile/presentation/screens/employee/employee_tickets_screen/employee_tickets_screen.dart';
import 'package:emosense_mobile/core/core.dart';

void main() {
  group('EmployeeTicketsScreen', () {
    testWidgets('should display tickets screen with tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [CustomSpacing()]),
          home: const EmployeeTicketsScreen(),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Check if the screen title is displayed
      expect(find.text('Customer Interactions'), findsOneWidget);
      expect(
        find.text('Manage customer tickets • Support dashboard'),
        findsOneWidget,
      );

      // Check if tabs are displayed
      expect(find.text('My Tickets'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);

      // Check if the new ticket button is displayed
      expect(find.text('New Ticket'), findsOneWidget);

      // Check if filter chips are displayed
      expect(find.text('All (12)'), findsOneWidget);
      expect(find.text('Open (8)'), findsOneWidget);
      expect(find.text('In Progress (3)'), findsOneWidget);
      expect(find.text('Resolved (1)'), findsOneWidget);
    });

    testWidgets('should switch between tabs correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [CustomSpacing()]),
          home: const EmployeeTicketsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on My Tickets tab
      expect(find.text('My Support Tickets'), findsOneWidget);

      // Tap on Analytics tab
      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();

      // Should show analytics content
      expect(find.text('Ticket Analytics'), findsOneWidget);
      expect(find.text('Total Tickets'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
      expect(find.text('Avg Time'), findsOneWidget);
    });

    testWidgets('should display ticket cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [CustomSpacing()]),
          home: const EmployeeTicketsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Check if sample tickets are displayed
      expect(find.text('TK-001'), findsOneWidget);
      expect(find.text('Product Quality Issue'), findsOneWidget);
      expect(find.text('Sarah Johnson'), findsOneWidget);

      expect(find.text('TK-002'), findsOneWidget);
      expect(find.text('Shipping Delay Inquiry'), findsOneWidget);
      expect(find.text('Mike Davis'), findsOneWidget);
    });

    testWidgets('should filter tickets correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [CustomSpacing()]),
          home: const EmployeeTicketsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially shows all tickets
      expect(find.text('TK-001'), findsOneWidget);
      expect(find.text('TK-002'), findsOneWidget);
      expect(find.text('TK-003'), findsOneWidget);

      // Tap on Open filter
      await tester.tap(find.text('Open (8)'));
      await tester.pumpAndSettle();

      // Should only show open tickets
      expect(find.text('TK-001'), findsOneWidget);
      expect(find.text('TK-002'), findsNothing);
      expect(find.text('TK-003'), findsNothing);

      // Tap on Resolved filter
      await tester.tap(find.text('Resolved (1)'));
      await tester.pumpAndSettle();

      // Should only show resolved tickets
      expect(find.text('TK-001'), findsNothing);
      expect(find.text('TK-002'), findsNothing);
      expect(find.text('TK-003'), findsOneWidget);
    });

    testWidgets('should open create ticket dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [CustomSpacing()]),
          home: const EmployeeTicketsScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on New Ticket button
      await tester.tap(find.text('New Ticket'));
      await tester.pumpAndSettle();

      // Should show create ticket dialog
      expect(find.text('Create New Ticket'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Create Ticket'), findsOneWidget);
    });
  });
}
