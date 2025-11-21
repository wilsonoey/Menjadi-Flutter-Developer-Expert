import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/on_the_air_tv_series_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_the_air_tv_series_page_test.mocks.dart';

@GenerateMocks([OnTheAirTvSeriesBloc])
void main() {
  late MockOnTheAirTvSeriesBloc mockOnTheAirTvSeriesBloc;

  setUp(() {
    mockOnTheAirTvSeriesBloc = MockOnTheAirTvSeriesBloc();
    when(mockOnTheAirTvSeriesBloc.state)
        .thenReturn(OnTheAirTvSeriesEmpty());
    when(mockOnTheAirTvSeriesBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(mockOnTheAirTvSeriesBloc.add(any))
        .thenAnswer((_) async {});
    when(mockOnTheAirTvSeriesBloc.close())
        .thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<OnTheAirTvSeriesBloc>.value(
        value: mockOnTheAirTvSeriesBloc,
        child: body,
      ),
    );
  }

  group('OnTheAirTVSeriesPage', () {
    testWidgets('displays AppBar with title', (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());

      await tester.pumpWidget(makeTestableWidget(const OnTheAirTVSeriesPage()));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('On The Air TV Series'), findsOneWidget);
    });

    testWidgets('displays loading indicator when state is loading',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesLoading());
      when(mockOnTheAirTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(OnTheAirTvSeriesLoading()));

      await tester.pumpWidget(makeTestableWidget(const OnTheAirTVSeriesPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays TV series list when state is loaded',
        (WidgetTester tester) async {
      final tVSeriesList = [
        const TVSeries(
          backdropPath: '/path1.jpg',
          genreIds: [1, 2],
          id: 1,
          overview: 'Overview 1',
          popularity: 8.5,
          posterPath: '/poster1.jpg',
          firstAirDate: '2023-01-01',
          originCountry: ['US'],
          originalLanguage: 'en',
          originalName: 'TV Series 1',
          name: 'TV Series 1',
          voteAverage: 8.0,
          voteCount: 100,
        ),
      ];

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesLoaded(tVSeriesList));
      when(mockOnTheAirTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(OnTheAirTvSeriesLoaded(tVSeriesList)));

      await tester.pumpWidget(makeTestableWidget(const OnTheAirTVSeriesPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TVSeriesCard), findsWidgets);
    });

    testWidgets('displays error message when state is error',
        (WidgetTester tester) async {
      const errorMessage = 'Failed to fetch data';

      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(const OnTheAirTvSeriesError(errorMessage));
      when(mockOnTheAirTvSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(
              const OnTheAirTvSeriesError(errorMessage)));

      await tester.pumpWidget(makeTestableWidget(const OnTheAirTVSeriesPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('displays SizedBox when state is empty',
        (WidgetTester tester) async {
      when(mockOnTheAirTvSeriesBloc.state)
          .thenReturn(OnTheAirTvSeriesEmpty());
      when(mockOnTheAirTvSeriesBloc.stream)
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(makeTestableWidget(const OnTheAirTVSeriesPage()));
      await tester.pump();

      expect(find.byType(SizedBox), findsWidgets);
    });

    test('route name is correct', () {
      expect(OnTheAirTVSeriesPage.ROUTE_NAME, '/on-the-air-tv-series');
    });
  });
}