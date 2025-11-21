import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoaded(testMovieList)));
    when(mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(const PopularMoviesError('Error message')));
    when(mockPopularMoviesBloc.state)
        .thenReturn(const PopularMoviesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty widget when state is initial',
      (WidgetTester tester) async {
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesEmpty()));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesEmpty());

    final sizedBoxFinder = find.byType(SizedBox);

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(sizedBoxFinder, findsWidgets);
  });
}