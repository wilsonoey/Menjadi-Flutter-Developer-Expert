import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';

import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMoviesBloc])
void main() {
  late MockWatchlistMoviesBloc mockWatchlistMoviesBloc;

  setUp(() {
    mockWatchlistMoviesBloc = MockWatchlistMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<WatchlistMoviesBloc>(
        create: (_) => mockWatchlistMoviesBloc,
        child: body,
      ),
    );
  }

  group('WatchlistMoviesPage', () {
    testWidgets('displays loading state', (WidgetTester tester) async {
      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoading()));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesLoading());

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays loaded movies', (WidgetTester tester) async {
      final movies = [
        const Movie(
          adult: false,
          backdropPath: '/path',
          genreIds: [1, 2],
          id: 1,
          originalTitle: 'Movie 1',
          overview: 'Overview',
          popularity: 8.0,
          posterPath: '/poster',
          releaseDate: '2021-01-01',
          title: 'Movie 1',
          video: false,
          voteAverage: 8.0,
          voteCount: 100,
        ),
      ];

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded(movies)));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded(movies));

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays error message', (WidgetTester tester) async {
      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(const WatchlistMoviesError('Error message')));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(const WatchlistMoviesError('Error message'));

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('displays empty state', (WidgetTester tester) async {
      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesEmpty()));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesEmpty());

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesEmpty()));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesEmpty());

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays multiple movies in list', (WidgetTester tester) async {
      final movies = [
        const Movie(
          adult: false,
          backdropPath: '/path1',
          genreIds: [1],
          id: 1,
          originalTitle: 'Movie 1',
          overview: 'Overview 1',
          popularity: 8.0,
          posterPath: '/poster1',
          releaseDate: '2021-01-01',
          title: 'Movie 1',
          video: false,
          voteAverage: 8.0,
          voteCount: 100,
        ),
        const Movie(
          adult: false,
          backdropPath: '/path2',
          genreIds: [2],
          id: 2,
          originalTitle: 'Movie 2',
          overview: 'Overview 2',
          popularity: 7.5,
          posterPath: '/poster2',
          releaseDate: '2021-02-01',
          title: 'Movie 2',
          video: false,
          voteAverage: 7.5,
          voteCount: 80,
        ),
      ];

      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesLoaded(movies)));
      when(mockWatchlistMoviesBloc.state)
          .thenReturn(WatchlistMoviesLoaded(movies));

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsWidgets);
    });

    testWidgets('should fetch watchlist movies on initState', (WidgetTester tester) async {
      when(mockWatchlistMoviesBloc.stream)
          .thenAnswer((_) => Stream.value(WatchlistMoviesEmpty()));
      when(mockWatchlistMoviesBloc.state).thenReturn(WatchlistMoviesEmpty());

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      verify(mockWatchlistMoviesBloc.add(FetchWatchlistMovies())).called(1);
    });
  });
}