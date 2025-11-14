import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/pages/splash_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
      routes: {
        HomeMoviePage.ROUTE_NAME: (context) => const Scaffold(
              body: Text('Home Page'),
            ),
      },
    );
  }
  
  testWidgets('SplashPage should navigate after delay', (WidgetTester tester) async {
    await tester.pumpWidget(
      _makeTestableWidget(const SplashPage()),
    );

    // Verify splash page displays
    expect(find.byType(SplashPage), findsOneWidget);

    // Wait for animation and navigation to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify navigation occurred
    expect(find.byType(SplashPage), findsNothing);
  });
}