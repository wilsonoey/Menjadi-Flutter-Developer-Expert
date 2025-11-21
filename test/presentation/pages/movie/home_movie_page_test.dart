import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_movie_page_test.mocks.dart';

@GenerateMocks([
  NowPlayingMoviesBloc,
  PopularMoviesBloc,
  TopRatedMoviesBloc,
])
void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();

    // Stub initial state
    when(mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesEmpty());
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesEmpty());
    when(mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesEmpty());

    // Stub stream behavior with proper state emissions
    when(mockNowPlayingMoviesBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([NowPlayingMoviesEmpty()]));
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([PopularMoviesEmpty()]));
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([TopRatedMoviesEmpty()]));

    // Stub close method
    when(mockNowPlayingMoviesBloc.close()).thenAnswer((_) async {});
    when(mockPopularMoviesBloc.close()).thenAnswer((_) async {});
    when(mockTopRatedMoviesBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    mockNowPlayingMoviesBloc.close();
    mockPopularMoviesBloc.close();
    mockTopRatedMoviesBloc.close();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NowPlayingMoviesBloc>(
            create: (_) => mockNowPlayingMoviesBloc,
          ),
          BlocProvider<PopularMoviesBloc>(
            create: (_) => mockPopularMoviesBloc,
          ),
          BlocProvider<TopRatedMoviesBloc>(
            create: (_) => mockTopRatedMoviesBloc,
          ),
        ],
        child: body,
      ),
    );
  }

  group('HomeMoviePage', () {
    testWidgets('displays AppBar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Ditonton'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays drawer with correct menu items',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TV Series'), findsOneWidget);
      expect(find.text('Watchlist'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('Now Playing section displays loading state',
        (WidgetTester tester) async {
      when(mockNowPlayingMoviesBloc.state)
          .thenReturn(NowPlayingMoviesLoading());
      when(mockNowPlayingMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([NowPlayingMoviesLoading()]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Now Playing section displays loaded state',
        (WidgetTester tester) async {
      final movies = [
        const Movie(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 1,
          title: 'Movie 1',
          overview: 'Overview 1',
          popularity: 1.0,
          posterPath: '/poster1.jpg',
          voteAverage: 8.0,
          voteCount: 100,
          adult: false,
          video: false,
          originalTitle: 'Movie 1',
          releaseDate: '2024-01-01',
        ),
      ];

      when(mockNowPlayingMoviesBloc.state)
          .thenReturn(NowPlayingMoviesLoaded(movies));
      when(mockNowPlayingMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([NowPlayingMoviesLoaded(movies)]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Now Playing section displays error state',
        (WidgetTester tester) async {
      when(mockNowPlayingMoviesBloc.state)
          .thenReturn(const NowPlayingMoviesError('Error message'));
      when(mockNowPlayingMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([const NowPlayingMoviesError('Error message')]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('Popular section displays loading state',
        (WidgetTester tester) async {
      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesLoading());
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([PopularMoviesLoading()]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Popular section displays loaded state',
        (WidgetTester tester) async {
      final movies = [
        const Movie(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 2,
          title: 'Popular Movie',
          overview: 'Popular overview',
          popularity: 2.0,
          posterPath: '/poster2.jpg',
          releaseDate: '2024-02-01',
          adult: false,
          originalTitle: 'Popular Movie',
          video: false,
          voteAverage: 7.5,
          voteCount: 200,
        ),
      ];

      when(mockPopularMoviesBloc.state)
          .thenReturn(PopularMoviesLoaded(movies));
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([PopularMoviesLoaded(movies)]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Popular'), findsOneWidget);
    });

    testWidgets('Popular section displays error state',
        (WidgetTester tester) async {
      when(mockPopularMoviesBloc.state)
          .thenReturn(const PopularMoviesError('Popular error'));
      when(mockPopularMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([const PopularMoviesError('Popular error')]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Popular error'), findsOneWidget);
    });

    testWidgets('Top Rated section displays Loading state',
        (WidgetTester tester) async {
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMoviesLoading());
      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([TopRatedMoviesLoading()]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Top Rated section displays loaded state',
        (WidgetTester tester) async {
      final movies = [
        const Movie(
          backdropPath: '/path.jpg',
          genreIds: [1, 2],
          id: 3,
          title: 'Top Rated Movie',
          overview: 'Top rated overview',
          popularity: 3.0,
          posterPath: '/poster3.jpg',
          releaseDate: '2024-03-01',
          adult: false,
          video: false,
          originalTitle: 'Top Rated Movie',
          voteAverage: 9.0,
          voteCount: 300,
        ),
      ];

      when(mockTopRatedMoviesBloc.state)
          .thenReturn(TopRatedMoviesLoaded(movies));
      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([TopRatedMoviesLoaded(movies)]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('Top Rated section displays error state',
        (WidgetTester tester) async {
      when(mockTopRatedMoviesBloc.state)
          .thenReturn(const TopRatedMoviesError('Top rated error'));
      when(mockTopRatedMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([const TopRatedMoviesError('Top rated error')]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.text('Top rated error'), findsOneWidget);
    });

    testWidgets('TVSeriesList renders horizontal ListView',
        (WidgetTester tester) async {
      final movies = [
        const Movie(
          backdropPath: '/path.jpg',
          genreIds: [1],
          id: 1,
          title: 'Movie 1',
          overview: 'Overview',
          popularity: 1.0,
          posterPath: '/poster1.jpg',
          releaseDate: '2024-01-01',
          adult: false,
          video: false,
          originalTitle: 'Movie 1',
          voteAverage: 8.0,
          voteCount: 100,
        ),
        const Movie(
          backdropPath: '/path2.jpg',
          genreIds: [2],
          id: 2,
          title: 'Movie 2',
          overview: 'Overview 2',
          popularity: 2.0,
          posterPath: '/poster2.jpg',
          releaseDate: '2024-02-01',
          adult: false,
          video: false,
          originalTitle: 'Movie 2',
          voteAverage: 7.5,
          voteCount: 200,
        ),
      ];

      when(mockNowPlayingMoviesBloc.state)
          .thenReturn(NowPlayingMoviesLoaded(movies));
      when(mockNowPlayingMoviesBloc.stream)
          .thenAnswer((_) => Stream.fromIterable([NowPlayingMoviesLoaded(movies)]));

      await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

      expect(find.byType(ListView), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
    });
  });
}