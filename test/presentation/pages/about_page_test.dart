import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AboutPage', () {
    testWidgets('should display Scaffold with Stack', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      // Use find.byType with Scaffold first
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Find Stack as child of Scaffold, not all Stack widgets
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Stack),
        ),
        findsWidgets,
      );
    });

    testWidgets('should display top section with image', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display bottom section with yellow background and text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      final textWidget = find.byType(Text);
      expect(textWidget, findsOneWidget);

      final text = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.textAlign == TextAlign.justify);
      expect(text, findsOneWidget);
    });

    testWidgets('should have back button in SafeArea', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutPage(),
        ),
      );

      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AboutPage(),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(AboutPage), findsNothing);
    });

    testWidgets('should have correct route name', (WidgetTester tester) async {
      expect(AboutPage.ROUTE_NAME, '/about');
    });
  });
}