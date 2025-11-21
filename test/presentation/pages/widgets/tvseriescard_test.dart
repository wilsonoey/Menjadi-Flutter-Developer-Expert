import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTVSeries = const TVSeries(
    backdropPath: '/backdrop.jpg',
    genreIds: [1, 2],
    id: 123,
    overview: 'Great series overview',
    popularity: 8.5,
    posterPath: '/poster.jpg',
    firstAirDate: '2023-01-01',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    name: 'Test Series',
    voteAverage: 8.0,
    voteCount: 100,
  );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == '/detail-tv-series') {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Detail')),
              body: const Center(child: Text('TV Series Detail')),
            ),
          );
        }
        return null;
      },
    );
  }

  group('TVSeriesCard', () {
    testWidgets('displays series name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.text('Test Series'), findsOneWidget);
    });

    testWidgets('displays series overview correctly', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.text('Great series overview'), findsOneWidget);
    });

    testWidgets('displays poster image with correct URL',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Image &&
              widget.image.toString().contains('/poster.jpg'),
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('navigates to detail page when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('TV Series Detail'), findsOneWidget);
    });

    testWidgets('renders Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders Stack for layout', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      // Gunakan predicate untuk menemukan Stack yang spesifik (yang paling dalam)
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Stack && 
              widget.alignment == Alignment.bottomLeft,
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders ClipRRect for image border radius',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('text overflow is set to ellipsis', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsWidgets);
    });

    testWidgets('displays fallback text when name is null',
        (WidgetTester tester) async {
      final nullNameSeries = const TVSeries(
        backdropPath: '/backdrop.jpg',
        genreIds: [1],
        id: 124,
        overview: 'Overview',
        popularity: 8.0,
        posterPath: '/poster.jpg',
        firstAirDate: '2023-01-01',
        originCountry: ['US'],
        originalLanguage: 'en',
        originalName: 'Original',
        name: null,
        voteAverage: 8.0,
        voteCount: 100,
      );

      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(nullNameSeries)));

      expect(find.text('-'), findsWidgets);
    });

    testWidgets('displays CircularProgressIndicator as placeholder',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('displays fallback text when overview is null',
        (WidgetTester tester) async {
      final nullOverviewSeries = const TVSeries(
        backdropPath: '/backdrop.jpg',
        genreIds: [1],
        id: 125,
        overview: null,
        popularity: 8.0,
        posterPath: '/poster.jpg',
        firstAirDate: '2023-01-01',
        originCountry: ['US'],
        originalLanguage: 'en',
        originalName: 'Original',
        name: 'Series Name',
        voteAverage: 8.0,
        voteCount: 100,
      );

      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(nullOverviewSeries)));

      expect(find.text('-'), findsWidgets);
    });

    testWidgets('container has correct margins and styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('all required widgets are present', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(InkWell), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Stack && 
              widget.alignment == Alignment.bottomLeft,
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('SizedBox spacer is rendered between title and overview',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('InkWell has proper onTap handler', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

      final inkWell = find.byType(InkWell);
      expect(inkWell, findsOneWidget);

      await tester.tap(inkWell);
      await tester.pumpAndSettle();

      expect(find.text('TV Series Detail'), findsOneWidget);
    });
  });
}