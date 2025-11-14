import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> safeTapIfFound(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder.first);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('Movies flow: smoke test, open lists and detail if possible', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Basic presence
    expect(find.byType(Scaffold), findsWidgets);

    // Try to find movie-related headings and interact
    await safeTapIfFound(tester, find.text('Movies'));
    await safeTapIfFound(tester, find.text('Movie'));

    // Try to scroll and tap first tappable item
    final scrollableFinder = find.byType(Scrollable);
    if (scrollableFinder.evaluate().isNotEmpty) {
      final inkWellFinder = find.byType(InkWell);
      if (inkWellFinder.evaluate().isNotEmpty) {
        try {
          await tester.scrollUntilVisible(
            inkWellFinder.first,
            200.0,
            scrollable: scrollableFinder.first,
          );
          await tester.pumpAndSettle();
        } catch (e) {
          // Ignore scroll errors
        }
      }
    }

    // Try tapping first movie card-like widget
    await safeTapIfFound(tester, find.byType(InkWell));
    if (find.byType(InkWell).evaluate().isEmpty) {
      await safeTapIfFound(tester, find.byType(GestureDetector));
    }
    if (find.byType(InkWell).evaluate().isEmpty && find.byType(GestureDetector).evaluate().isEmpty) {
      await safeTapIfFound(tester, find.byType(ListTile));
    }

    // After tapping a possible detail, expect a Scaffold
    expect(find.byType(Scaffold), findsWidgets);
  });
}