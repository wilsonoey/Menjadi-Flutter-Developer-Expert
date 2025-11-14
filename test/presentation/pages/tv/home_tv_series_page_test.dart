import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_tv_series_page_test.mocks.dart';

@GenerateMocks([
  OnTheAirTvSeriesBloc,
  PopularTvSeriesBloc,
  TopRatedTvSeriesBloc,
])
void main() {
  late MockOnTheAirTvSeriesBloc mockOnTheAirTvSeriesBloc;
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUp(() {
    mockOnTheAirTvSeriesBloc = MockOnTheAirTvSeriesBloc();
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();

    // Stub initial state
    when(mockOnTheAirTvSeriesBloc.state)
        .thenReturn(OnTheAirTvSeriesEmpty());
    when(mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesEmpty());
    when(mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesEmpty());

    // Stub stream behavior
    when(mockOnTheAirTvSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(OnTheAirTvSeriesEmpty()));
    when(mockPopularTvSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvSeriesEmpty()));
    when(mockTopRatedTvSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvSeriesEmpty()));

    // Stub close method
    when(mockOnTheAirTvSeriesBloc.close()).thenAnswer((_) async {});
    when(mockPopularTvSeriesBloc.close()).thenAnswer((_) async {});
    when(mockTopRatedTvSeriesBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    mockOnTheAirTvSeriesBloc.close();
    mockPopularTvSeriesBloc.close();
    mockTopRatedTvSeriesBloc.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<OnTheAirTvSeriesBloc>(
            create: (_) => mockOnTheAirTvSeriesBloc,
          ),
          BlocProvider<PopularTvSeriesBloc>(
            create: (_) => mockPopularTvSeriesBloc,
          ),
          BlocProvider<TopRatedTvSeriesBloc>(
            create: (_) => mockTopRatedTvSeriesBloc,
          ),
        ],
        child: body,
      ),
    );
  }

  group('HomeTVSeriesPage', () {
    testWidgets('displays AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('TV Series'), findsWidgets);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays drawer with correct menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsWidgets);
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('On The Air section displays loading state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesLoading());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('On The Air section displays loaded state',
        (WidgetTester tester) async {
      final tvSeries = [
        TVSeries(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 1,
          name: 'TV Series 1',
          overview: 'Overview 1',
          popularity: 1.0,
          posterPath: '/poster1.jpg',
          voteAverage: 8.0,
          voteCount: 100,
          firstAirDate: '2024-01-01',
          originCountry: ["US"],
          originalLanguage: 'en',
          originalName: 'TV Series 1',
        ),
      ];

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesLoaded(tvSeries));
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('On The Air'), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('On The Air section displays error state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesError('Error message'));
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('Popular section displays loading state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesLoading());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Popular section displays loaded state',
        (WidgetTester tester) async {
      final tvSeries = [
        TVSeries(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 2,
          name: 'Popular TV Series',
          overview: 'Popular overview',
          popularity: 2.0,
          posterPath: '/poster2.jpg',
          firstAirDate: '2024-02-01',
          originCountry: ["US"],
          originalLanguage: 'en',
          originalName: 'Popular TV Series',
          voteAverage: 7.5,
          voteCount: 200,
        ),
      ];

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesLoaded(tvSeries));
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('Popular'), findsOneWidget);
    });

    testWidgets('Popular section displays error state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesError('Popular error'));
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('Popular error'), findsOneWidget);
    });

    testWidgets('Top Rated section displays Loading state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesLoading());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Top Rated section displays loaded state',
        (WidgetTester tester) async {
      final tvSeries = [
        TVSeries(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 3,
          name: 'Top Rated TV Series',
          overview: 'Top rated overview',
          popularity: 3.0,
          posterPath: '/poster3.jpg',
          firstAirDate: '2024-03-01',
          originCountry: ["US"],
          originalLanguage: 'en',
          originalName: 'Top Rated TV Series',
          voteAverage: 9.0,
          voteCount: 300,
        ),
      ];

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesLoaded(tvSeries));

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('Top Rated section displays error state',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesError('Top rated error'));

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.text('Top rated error'), findsOneWidget);
    });

    testWidgets('TVSeriesList renders horizontal ListView',
        (WidgetTester tester) async {
      final tvSeries = [
        TVSeries(
          backdropPath: '/path.jpg',
          genreIds: [1],
          id: 1,
          name: 'TV 1',
          overview: 'Overview',
          popularity: 1.0,
          posterPath: '/poster1.jpg',
          firstAirDate: '2024-01-01',
          originCountry: ["US"],
          originalLanguage: 'en',
          originalName: 'TV Series 1',
          voteAverage: 8.0,
          voteCount: 100,
        ),
        TVSeries(
          backdropPath: '/path2.jpg',
          genreIds: [2],
          id: 2,
          name: 'TV 2',
          overview: 'Overview 2',
          popularity: 2.0,
          posterPath: '/poster2.jpg',
          firstAirDate: '2024-02-01',
          originCountry: ["US"],
          originalLanguage: 'en',
          originalName: 'TV Series 2',
          voteAverage: 7.5,
          voteCount: 200,
        ),
      ];

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesLoaded(tvSeries));
      when(mockPopularTvSeriesBloc.state)
          .thenReturn(PopularTvSeriesEmpty());
      when(mockTopRatedTvSeriesBloc.state)
          .thenReturn(TopRatedTvSeriesEmpty());

      await tester.pumpWidget(_makeTestableWidget(HomeTVSeriesPage()));

      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
    });
  });
}