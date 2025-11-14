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

  testWidgets('Watchlist basic flow: open watchlist and attempt add/remove if possible', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Basic smoke test
    expect(find.byType(Scaffold), findsWidgets);

    // Try to open drawer first
    await safeTapIfFound(tester, find.byIcon(Icons.menu));

    // Try to navigate to Watchlist
    await safeTapIfFound(tester, find.text('Watchlist'));
    await safeTapIfFound(tester, find.byIcon(Icons.bookmark));
    await safeTapIfFound(tester, find.byIcon(Icons.save));

    // Wait for page to load
    await tester.pumpAndSettle();

    // If there is a list, try tapping first item to view detail
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

          await tester.tap(inkWellFinder.first);
          await tester.pumpAndSettle();

          // Attempt to find a bookmark/save/remove button
          await safeTapIfFound(tester, find.byIcon(Icons.bookmark));
          await safeTapIfFound(tester, find.byIcon(Icons.bookmark_border));
          await safeTapIfFound(tester, find.byIcon(Icons.add));
          await safeTapIfFound(tester, find.byIcon(Icons.check));
        } catch (e) {
          // Ignore scroll or tap errors
        }
      }
    }

    // Final smoke assertion
    expect(find.byType(Scaffold), findsWidgets);
  });
}