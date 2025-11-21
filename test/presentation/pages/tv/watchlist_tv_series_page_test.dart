import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';

import 'watchlist_tv_series_page_test.mocks.dart';

@GenerateMocks([WatchlistTvSeriesBloc])
void main() {
  late MockWatchlistTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<WatchlistTvSeriesBloc>(
        create: (_) => mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('Should display loading state', (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(WatchlistTvSeriesLoading()));
    when(mockBloc.state).thenReturn(WatchlistTvSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display TV series list when loaded', (WidgetTester tester) async {
    final tvSeries = [
      const TVSeries(
        id: 1,
        name: 'Test',
        posterPath: '/',
        backdropPath: '/',
        overview: 'Overview',
        voteAverage: 8.0,
        voteCount: 100,
        firstAirDate: '2024-01-01',
        originCountry: ['US'],
        originalLanguage: 'en',
        originalName: 'Test',
        genreIds: [1, 2],
        popularity: 1.0,
      )
    ];
    when(mockBloc.stream).thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded(tvSeries)));
    when(mockBloc.state).thenReturn(WatchlistTvSeriesLoaded(tvSeries));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Should display error message on error state', (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(const WatchlistTvSeriesError('Error')));
    when(mockBloc.state).thenReturn(const WatchlistTvSeriesError('Error'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));
    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Should display empty state', (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(WatchlistTvSeriesEmpty()));
    when(mockBloc.state).thenReturn(WatchlistTvSeriesEmpty());

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));
    expect(find.byType(SizedBox), findsOneWidget);
  });
}