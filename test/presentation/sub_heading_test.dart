import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';

void main() {
  group('SubHeading Widget', () {
    testWidgets('should render SubHeading with correct title', (WidgetTester tester) async {
      const testTitle = 'Test Title';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubHeading(
              title: testTitle,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.text('See More'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('should call onTap callback when InkWell is tapped', (WidgetTester tester) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubHeading(
              title: 'Test',
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(onTapCalled, isTrue);
    });

    testWidgets('should have correct layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubHeading(
              title: 'Layout Test',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Padding), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });
  });
}