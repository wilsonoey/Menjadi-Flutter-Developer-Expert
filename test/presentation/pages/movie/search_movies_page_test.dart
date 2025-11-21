import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_movies_page_test.mocks.dart';

@GenerateMocks([MovieSearchBloc])
void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<MovieSearchBloc>(
        create: (_) => mockMovieSearchBloc,
        child: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockMovieSearchBloc.state).thenReturn(MovieSearchLoading());
    when(mockMovieSearchBloc.stream)
        .thenAnswer((_) => Stream.value(MovieSearchLoading()));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display list view when data is loaded',
      (WidgetTester tester) async {
    final movieList = [
      const Movie(
        backdropPath: '/path',
        genreIds: [],
        id: 1,
        title: 'Test Movie',
        adult: false,
        video: false,
        originalTitle: 'Test Movie',
        overview: 'Overview',
        popularity: 1.0,
        posterPath: '/path',
        releaseDate: '2021-01-01',
        voteAverage: 8.0,
        voteCount: 100,
      ),
    ];

    when(mockMovieSearchBloc.state)
        .thenReturn(MovieSearchLoaded(movieList));
    when(mockMovieSearchBloc.stream)
        .thenAnswer((_) => Stream.value(MovieSearchLoaded(movieList)));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display empty container when state is empty',
      (WidgetTester tester) async {
    when(mockMovieSearchBloc.state).thenReturn(MovieSearchEmpty());
    when(mockMovieSearchBloc.stream)
        .thenAnswer((_) => Stream.value(MovieSearchEmpty()));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));
    await tester.pump();

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('Should trigger search event when user submits query',
      (WidgetTester tester) async {
    when(mockMovieSearchBloc.state).thenReturn(MovieSearchEmpty());
    when(mockMovieSearchBloc.stream)
        .thenAnswer((_) => Stream.value(MovieSearchEmpty()));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'test');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockMovieSearchBloc.add(any)).called(greaterThanOrEqualTo(1));
  });
}