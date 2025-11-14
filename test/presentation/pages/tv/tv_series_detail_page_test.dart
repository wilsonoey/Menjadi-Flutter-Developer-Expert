import 'package:ditonton/presentation/bloc/tv/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_recommendations/tv_series_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([
  TvSeriesDetailBloc,
  TvSeriesRecommendationsBloc,
  WatchlistTvSeriesBloc
])
void main() {
  late MockTvSeriesDetailBloc mockTvSeriesDetailBloc;
  late MockTvSeriesRecommendationsBloc mockTvSeriesRecommendationsBloc;
  late MockWatchlistTvSeriesBloc mockWatchlistTvSeriesBloc;

  setUp(() {
    mockTvSeriesDetailBloc = MockTvSeriesDetailBloc();
    mockTvSeriesRecommendationsBloc = MockTvSeriesRecommendationsBloc();
    mockWatchlistTvSeriesBloc = MockWatchlistTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvSeriesDetailBloc>.value(value: mockTvSeriesDetailBloc),
        BlocProvider<TvSeriesRecommendationsBloc>.value(
            value: mockTvSeriesRecommendationsBloc),
        BlocProvider<WatchlistTvSeriesBloc>.value(
            value: mockWatchlistTvSeriesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Tv Series Detail Page', () {
    testWidgets(
        'should display loading indicator when tv series detail state is loading',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesDetailLoading()));
      when(mockTvSeriesDetailBloc.state).thenReturn(TvSeriesDetailLoading());

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsLoading()));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoading());

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoading()));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoading());

      final loadingFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(loadingFinder, findsOneWidget);
    });

    testWidgets(
        'should display error message when tv series detail state is error',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesDetailError('Error message')));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailError('Error message'));

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsError('Error')));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsError('Error'));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesError('Error')));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesError('Error'));

      final errorFinder = find.text('Error message');

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(errorFinder, findsOneWidget);
    });

    testWidgets(
        'should display tv series detail when state is loaded',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      final titleFinder = find.text(testTVSeriesDetail.name);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(titleFinder, findsOneWidget);
    });

    testWidgets(
        'should display add to watchlist button when tv series is not in watchlist',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      final watchlistButtonFinder = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonFinder, findsOneWidget);
    });

    testWidgets(
        'should display check icon when tv series is in watchlist',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([testTVSeries])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([testTVSeries]));

      final watchlistButtonFinder = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonFinder, findsOneWidget);
    });

    testWidgets(
        'should show snackbar when adding tv series to watchlist succeeds',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer((_) => Stream.fromIterable([
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
        TvSeriesWatchlistMessage('Added to Watchlist'),
      ]));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesWatchlistMessage('Added to Watchlist'));

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state).thenReturn(WatchlistTvSeriesLoaded([]));
      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
        'should show dialog when watchlist message is not add/remove',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer((_) => Stream.fromIterable([
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
        const TvSeriesWatchlistMessage('Custom message'),
      ]));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(const TvSeriesWatchlistMessage('Custom message'));

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state).thenReturn(WatchlistTvSeriesLoaded([]));
      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
        'should display recommendations loading state',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsLoading()));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoading());

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'should display recommendations error state',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(TvSeriesRecommendationsError('Error loading recommendations')));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsError('Error loading recommendations'));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error loading recommendations'), findsOneWidget);
    });

    testWidgets(
        'should display back button',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets(
        'should call add event when add watchlist button pressed',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);

      verify(mockTvSeriesDetailBloc.add(any)).called(greaterThanOrEqualTo(1));
    });

    testWidgets(
        'should call remove event when remove watchlist button pressed',
        (WidgetTester tester) async {
      when(mockTvSeriesDetailBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true)));
      when(mockTvSeriesDetailBloc.state)
          .thenReturn(TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true));

      when(mockTvSeriesRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(TvSeriesRecommendationsLoaded(testTVSeriesList)));
      when(mockTvSeriesRecommendationsBloc.state)
          .thenReturn(TvSeriesRecommendationsLoaded(testTVSeriesList));

      when(mockWatchlistTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistTvSeriesLoaded([testTVSeries])));
      when(mockWatchlistTvSeriesBloc.state)
          .thenReturn(WatchlistTvSeriesLoaded([testTVSeries]));

      await tester.pumpWidget(makeTestableWidget(TVSeriesDetailPage(id: 1)));
      await tester.pump();

      final removeButton = find.byIcon(Icons.check);
      await tester.tap(removeButton);

      verify(mockTvSeriesDetailBloc.add(any)).called(greaterThanOrEqualTo(1));
    });
  });
}