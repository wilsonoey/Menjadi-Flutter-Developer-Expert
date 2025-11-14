import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';

import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'top_rated_tv_series_page_test.mocks.dart';

@GenerateMocks([TopRatedTvSeriesBloc])
void main() {
  late MockTopRatedTvSeriesBloc mockTopRatedTvSeriesBloc;

  setUp(() {
    mockTopRatedTvSeriesBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockTopRatedTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockTopRatedTvSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvSeriesLoading()));
    when(mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockTopRatedTvSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedTvSeriesLoaded(testTVSeriesList)));
    when(mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesLoaded(testTVSeriesList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockTopRatedTvSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedTvSeriesError('Error message')));
    when(mockTopRatedTvSeriesBloc.state)
        .thenReturn(TopRatedTvSeriesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTVSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}