import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTVSeries,
  GetPopularTVSeries,
  GetTopRatedTVSeries,
])
void main() {
  late MockGetOnTheAirTVSeries mockGetOnTheAirTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late OnTheAirTvSeriesBloc onTheAirTVSeriesBloc;
  late PopularTvSeriesBloc popularTVSeriesBloc;
  late TopRatedTvSeriesBloc topRatedTVSeriesBloc;

  setUp(() {
    mockGetOnTheAirTVSeries = MockGetOnTheAirTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    onTheAirTVSeriesBloc = OnTheAirTvSeriesBloc(mockGetOnTheAirTVSeries);
    popularTVSeriesBloc = PopularTvSeriesBloc(mockGetPopularTVSeries);
    topRatedTVSeriesBloc = TopRatedTvSeriesBloc(mockGetTopRatedTVSeries);
  });

  final tTvSeriesList = <TVSeries>[testTVSeries];

  group('Popular TV Series', () {
    test('initial state should be Initial', () {
      expect(popularTVSeriesBloc.state, PopularTvSeriesLoading());
    });

    test('FetchOnTheAirTvSeries should have correct props', () {
      final event = FetchOnTheAirTvSeries();
      expect(event.props, []);
    });

    test('FetchPopularTvSeries should have correct props', () {
      final event = FetchPopularTvSeries();
      expect(event.props, []);
    });

    test('FetchTopRatedTvSeries should have correct props', () {
      final event = FetchTopRatedTvSeries();
      expect(event.props, []);
    });

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return popularTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesLoaded(tTvSeriesList),
      ],
      verify: (_) {
        verify(mockGetPopularTVSeries.execute());
      },
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        const PopularTvSeriesError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetPopularTVSeries.execute());
      },
    );
  });

  group('Now Playing TV Series', () {
    test('initial state should be Initial', () {
      expect(onTheAirTVSeriesBloc.state, OnTheAirTvSeriesLoading());
    });

    blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetOnTheAirTVSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return onTheAirTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        OnTheAirTvSeriesLoading(),
        OnTheAirTvSeriesLoaded(tTvSeriesList),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTVSeries.execute());
      },
    );

    blocTest<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetOnTheAirTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return onTheAirTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvSeries()),
      expect: () => [
        OnTheAirTvSeriesLoading(),
        const OnTheAirTvSeriesError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetOnTheAirTVSeries.execute());
      },
    );
  });

  group('Top Rated TV Series', () {
    test('initial state should be Initial', () {
      expect(topRatedTVSeriesBloc.state, TopRatedTvSeriesLoading());
    });

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return topRatedTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesLoaded(tTvSeriesList),
      ],
      verify: (_) {
        verify(mockGetTopRatedTVSeries.execute());
      },
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTVSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        const TopRatedTvSeriesError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetTopRatedTVSeries.execute());
      },
    );
  });
}