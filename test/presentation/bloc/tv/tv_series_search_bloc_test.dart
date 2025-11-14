import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late TvSeriesSearchBloc tvSeriesSearchBloc;
  late MockSearchTVSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTVSeries();
    tvSeriesSearchBloc = TvSeriesSearchBloc(mockSearchTvSeries);
  });

  tearDown(() {
    tvSeriesSearchBloc.close();
  });

  group('TvSeriesSearchBloc', () {
    test('initial state is TvSeriesSearchLoading', () {
      expect(tvSeriesSearchBloc.state, isA<TvSeriesSearchLoading>());
    });

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'emits [TvSeriesSearchLoading, TvSeriesSearchLoaded] when SearchTvSeriesEvent is added',
      build: () {
        when(mockSearchTvSeries.execute(any))
            .thenAnswer((_) async => Right(testTVSeriesList));
        return tvSeriesSearchBloc;
      },
      act: (bloc) => bloc.add(const OnTvSeriesQueryChanged('spider')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSeriesSearchLoading(),
        TvSeriesSearchLoaded(testTVSeriesList),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'emits [TvSeriesSearchLoading, TvSeriesSearchError] when search fails',
      build: () {
        when(mockSearchTvSeries.execute(any))
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        return tvSeriesSearchBloc;
      },
      act: (bloc) => bloc.add(const OnTvSeriesQueryChanged('test')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSeriesSearchLoading(),
        isA<TvSeriesSearchError>(),
      ],
    );

    blocTest<TvSeriesSearchBloc, TvSeriesSearchState>(
      'emits TvSeriesSearchEmpty when query is empty',
      build: () => tvSeriesSearchBloc,
      act: (bloc) => bloc.add(const OnTvSeriesQueryChanged('')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvSeriesSearchEmpty(),
      ],
    );
  });
}