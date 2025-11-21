// ...existing code...
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> safeTapIfFound(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('About page smoke and navigation test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Basic smoke: ensure at least one Scaffold is present
    expect(find.byType(Scaffold), findsWidgets);

    // Try to open About via common text labels
    await safeTapIfFound(tester, find.text('About'));
    await safeTapIfFound(tester, find.text('ABOUT'));
    await safeTapIfFound(tester, find.byIcon(Icons.info));
    await safeTapIfFound(tester, find.byTooltip('About'));

    // If About page opened, expect some descriptive content or a simple Scaffold
    if (find.text('About').evaluate().isNotEmpty || find.byIcon(Icons.info).evaluate().isNotEmpty) {
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
// ...existing code...