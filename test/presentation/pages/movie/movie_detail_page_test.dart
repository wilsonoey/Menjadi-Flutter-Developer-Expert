import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([
  MovieDetailBloc,
  MovieRecommendationsBloc,
  WatchlistMoviesBloc,
])
void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationsBloc mockMovieRecommendationsBloc;
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationsBloc = MockMovieRecommendationsBloc();
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(
            value: mockMovieRecommendationsBloc),
        BlocProvider<WatchlistMoviesBloc>.value(
            value: mockWatchlistMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Movie Detail Page', () {
    testWidgets(
        'should display loading indicator when movie detail state is loading',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream)
          .thenAnswer((_) => Stream.value(MovieDetailLoading()));
      when(mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsLoading()));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoading());

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoading()));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoading());

      final loadingFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(loadingFinder, findsOneWidget);
    });

    testWidgets(
        'should display error message when movie detail state is error',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream)
          .thenAnswer((_) => Stream.value(MovieDetailError('Error message')));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailError('Error message'));

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsError('Error')));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsError('Error'));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesError('Error')));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesError('Error'));

      final errorFinder = find.text('Error message');

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(errorFinder, findsOneWidget);
    });

    testWidgets(
        'should display movie detail when state is loaded',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      final titleFinder = find.text(testMovieDetail.title);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(titleFinder, findsOneWidget);
    });

    testWidgets(
        'should display add to watchlist button when movie is not in watchlist',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      final watchlistButtonFinder = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonFinder, findsOneWidget);
    });

    testWidgets(
        'should display check icon when movie is in watchlist',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([testMovie])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([testMovie]));

      final watchlistButtonFinder = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonFinder, findsOneWidget);
    });

    testWidgets(
        'should show snackbar when adding movie to watchlist succeeds',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer((_) => Stream.fromIterable([
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
        MovieWatchlistMessage('Added to Watchlist'),
      ]));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieWatchlistMessage('Added to Watchlist'));

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
        'should show dialog when watchlist message is not add/remove',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer((_) => Stream.fromIterable([
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
        const MovieWatchlistMessage('Custom message'),
      ]));
      when(mockMovieDetailBloc.state)
          .thenReturn(const MovieWatchlistMessage('Custom message'));

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
        'should display recommendations loading state',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsLoading()));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoading());

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets(
        'should display recommendations error state',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream)
          .thenAnswer((_) => Stream.value(MovieRecommendationsError('Error loading recommendations')));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsError('Error loading recommendations'));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.text('Error loading recommendations'), findsOneWidget);
    });

    testWidgets(
        'should display back button',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets(
        'should call add event when add watchlist button pressed',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);

      verify(mockMovieDetailBloc.add(any)).called(greaterThanOrEqualTo(1));
    });

    testWidgets(
        'should call remove event when remove watchlist button pressed',
        (WidgetTester tester) async {
      when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true)));
      when(mockMovieDetailBloc.state)
          .thenReturn(MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true));

      when(mockMovieRecommendationsBloc.stream).thenAnswer(
          (_) => Stream.value(MovieRecommendationsLoaded(testMovieList)));
      when(mockMovieRecommendationsBloc.state)
          .thenReturn(MovieRecommendationsLoaded(testMovieList));

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded([testMovie])));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded([testMovie]));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      final removeButton = find.byIcon(Icons.check);
      await tester.tap(removeButton);

      verify(mockMovieDetailBloc.add(any)).called(greaterThanOrEqualTo(1));
    });
  });
}