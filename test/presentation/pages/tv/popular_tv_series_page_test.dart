import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';

import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'popular_tv_series_page_test.mocks.dart';

@GenerateMocks([PopularTvSeriesBloc])
void main() {
  late MockPopularTvSeriesBloc mockPopularTvSeriesBloc;

  setUp(() {
    mockPopularTvSeriesBloc = MockPopularTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockPopularTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockPopularTvSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvSeriesLoading()));
    when(mockPopularTvSeriesBloc.state).thenReturn(PopularTvSeriesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockPopularTvSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(PopularTvSeriesLoaded(testTVSeriesList)));
    when(mockPopularTvSeriesBloc.state)
        .thenReturn(PopularTvSeriesLoaded(testTVSeriesList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockPopularTvSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularTvSeriesError('Error message')));
    when(mockPopularTvSeriesBloc.state)
        .thenReturn(const PopularTvSeriesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}