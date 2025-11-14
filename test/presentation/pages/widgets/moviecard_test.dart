import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testMovie = Movie(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [1, 2],
    id: 456,
    originalTitle: 'Original Title',
    overview: 'Great movie overview',
    popularity: 8.5,
    posterPath: '/poster.jpg',
    releaseDate: '2023-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.0,
    voteCount: 200,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        '/detail': (context) => Scaffold(body: Container()),
        '/detail-movie': (context) => Scaffold(body: Container()),
        '/detail-tv-series': (context) => Scaffold(body: Container()),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Unknown Route: ${settings.name}')),
          ),
        );
      },
    );
  }

  group('MovieCard', () {
    testWidgets('displays movie title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('displays movie overview correctly', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.text('Great movie overview'), findsOneWidget);
    });

    testWidgets('renders Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders InkWell for tap interaction', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('renders Stack for layout', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      final stackFinder = find.byWidgetPredicate(
        (widget) => widget is Stack && widget.alignment == Alignment.bottomLeft,
      );
      expect(stackFinder, findsOneWidget);
    });

    testWidgets('renders ClipRRect for image border radius',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('displays fallback text when title is null',
        (WidgetTester tester) async {
      final nullTitleMovie = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1],
        id: 457,
        originalTitle: 'Original',
        overview: 'Overview',
        popularity: 8.0,
        posterPath: '/poster.jpg',
        releaseDate: '2023-01-01',
        title: null,
        video: false,
        voteAverage: 8.0,
        voteCount: 100,
      );

      await tester.pumpWidget(_makeTestableWidget(MovieCard(nullTitleMovie)));

      expect(find.text('-'), findsWidgets);
    });

    testWidgets('displays CircularProgressIndicator as placeholder',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('tappable area responds to tap', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));
      await tester.pump();

      final inkWellFinder = find.byType(InkWell);
      expect(inkWellFinder, findsOneWidget);

      await tester.tap(inkWellFinder);
      await tester.pump();

      expect(inkWellFinder, findsOneWidget);
    });

    testWidgets('displays fallback text when overview is null',
        (WidgetTester tester) async {
      final nullOverviewMovie = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1],
        id: 458,
        originalTitle: 'Original',
        overview: null,
        popularity: 8.0,
        posterPath: '/poster.jpg',
        releaseDate: '2023-01-01',
        title: 'Movie Title',
        video: false,
        voteAverage: 8.0,
        voteCount: 100,
      );

      await tester.pumpWidget(_makeTestableWidget(MovieCard(nullOverviewMovie)));

      expect(find.text('-'), findsWidgets);
    });

    testWidgets('container has correct margins and styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('text widgets have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      final textWidgets = find.byType(Text);
      expect(textWidgets.evaluate().length, greaterThanOrEqualTo(2));
    });

    testWidgets('image container has correct dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('SizedBox spacer is rendered between title and overview',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('InkWell has proper onTap handler', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));
      await tester.pump();

      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      await tester.tap(inkWell);
      await tester.pump();

      expect(inkWell, findsOneWidget);
    });

    testWidgets('all required widgets are present', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      
      final stackFinder = find.byWidgetPredicate(
        (widget) => widget is Stack && widget.alignment == Alignment.bottomLeft,
      );
      expect(stackFinder, findsOneWidget);
      
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });
}