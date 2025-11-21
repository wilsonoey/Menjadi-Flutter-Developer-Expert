import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_series_page.dart';

import 'search_tv_series_page_test.mocks.dart';

@GenerateMocks([TvSeriesSearchBloc])
void main() {
  late MockTvSeriesSearchBloc mockTvSeriesSearchBloc;

  setUp(() {
    mockTvSeriesSearchBloc = MockTvSeriesSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TvSeriesSearchBloc>(
        create: (_) => mockTvSeriesSearchBloc,
        child: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockTvSeriesSearchBloc.stream)
        .thenAnswer((_) => Stream.value(TvSeriesSearchLoading()));
    when(mockTvSeriesSearchBloc.state).thenReturn(TvSeriesSearchLoading());

    await tester.pumpWidget(makeTestableWidget(const SearchTVSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display list view when data is loaded',
      (WidgetTester tester) async {
    final tvSeriesList = [
      const TVSeries(
        backdropPath: '/path',
        genreIds: [],
        id: 1,
        name: 'Test Series',
        originCountry: [],
        originalLanguage: 'en',
        originalName: 'Test Series',
        overview: 'Overview',
        popularity: 1.0,
        posterPath: '/path',
        firstAirDate: '2021-01-01',
        voteAverage: 8.0,
        voteCount: 100,
      ),
    ];

    when(mockTvSeriesSearchBloc.stream).thenAnswer(
        (_) => Stream.value(TvSeriesSearchLoaded(tvSeriesList)));
    when(mockTvSeriesSearchBloc.state)
        .thenReturn(TvSeriesSearchLoaded(tvSeriesList));

    await tester.pumpWidget(makeTestableWidget(const SearchTVSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display empty container when state is empty',
      (WidgetTester tester) async {
    when(mockTvSeriesSearchBloc.stream)
        .thenAnswer((_) => Stream.value(TvSeriesSearchEmpty()));
    when(mockTvSeriesSearchBloc.state).thenReturn(TvSeriesSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const SearchTVSeriesPage()));

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('Should trigger search event when user submits query',
      (WidgetTester tester) async {
    when(mockTvSeriesSearchBloc.stream)
        .thenAnswer((_) => Stream.value(TvSeriesSearchEmpty()));
    when(mockTvSeriesSearchBloc.state).thenReturn(TvSeriesSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const SearchTVSeriesPage()));

    await tester.enterText(find.byType(TextField), 'test');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    verify(mockTvSeriesSearchBloc.add(any)).called(greaterThanOrEqualTo(1));
  });
}