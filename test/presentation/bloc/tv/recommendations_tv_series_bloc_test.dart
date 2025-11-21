import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_recommendations/tv_series_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';
import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'recommendations_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTVSeriesRecommendations])
void main() {
  late TvSeriesRecommendationsBloc tvSeriesRecommendationsBloc;
  late MockGetTVSeriesRecommendations mockGetTvSeriesRecommendations;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTVSeriesRecommendations();
    tvSeriesRecommendationsBloc = TvSeriesRecommendationsBloc(
      mockGetTvSeriesRecommendations,
    );
  });

  tearDown(() {
    tvSeriesRecommendationsBloc.close();
  });

  const tId = 1;
  const tId2 = 2;
  final tTvSeriesList = <TVSeries>[testTVSeries];

  group('TvSeriesRecommendationsEvent', () {
    test('FetchTvSeriesRecommendations should have correct props', () {
      final event = const FetchTvSeriesRecommendations(tId);
      expect(event.props, [tId]);
    });

    test('FetchTvSeriesRecommendations with same id should be equal', () {
      final event1 = const FetchTvSeriesRecommendations(tId);
      final event2 = const FetchTvSeriesRecommendations(tId);
      expect(event1, event2);
    });

    test('FetchTvSeriesRecommendations with different id should not be equal', () {
      final event1 = const FetchTvSeriesRecommendations(tId);
      final event2 = const FetchTvSeriesRecommendations(tId2);
      expect(event1, isNot(event2));
    });
  });

  group('TvSeriesRecommendationsBloc', () {
    test('initial state should be TVSeriesRecommendationsLoading', () {
      expect(tvSeriesRecommendationsBloc.state, TvSeriesRecommendationsLoading());
    });

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        TvSeriesRecommendationsLoaded(tTvSeriesList),
      ],
      verify: (_) {
        verify(mockGetTvSeriesRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        const TvSeriesRecommendationsError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetTvSeriesRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should emit [Loading, Loaded] with empty list when no recommendations',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        const TvSeriesRecommendationsLoaded([]),
      ],
      verify: (_) {
        verify(mockGetTvSeriesRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should emit [Loading, Error] when connection failure occurs',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Connection Failure')));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        const TvSeriesRecommendationsError('Connection Failure'),
      ],
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should emit [Loading, Error] when cache failure occurs',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(DatabaseFailure('Cache Failure')));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesRecommendations(tId)),
      expect: () => [
        TvSeriesRecommendationsLoading(),
        const TvSeriesRecommendationsError('Cache Failure'),
      ],
    );

    blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'Should handle multiple events sequentially',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) {
        bloc.add(const FetchTvSeriesRecommendations(tId));
      },
      expect: () => [
        TvSeriesRecommendationsLoading(),
        TvSeriesRecommendationsLoaded(tTvSeriesList),
      ],
    );
  });

  group('TvSeriesRecommendationsState', () {
    test('TvSeriesRecommendationsLoading should have correct props', () {
      final state = TvSeriesRecommendationsLoading();
      expect(state.props, []);
    });

    test('TvSeriesRecommendationsLoading instances should be equal', () {
      final state1 = TvSeriesRecommendationsLoading();
      final state2 = TvSeriesRecommendationsLoading();
      expect(state1, state2);
    });

    test('TvSeriesRecommendationsLoaded should have correct props', () {
      final state = TvSeriesRecommendationsLoaded(tTvSeriesList);
      expect(state.props, [tTvSeriesList]);
    });

    test('TvSeriesRecommendationsLoaded with same list should be equal', () {
      final state1 = TvSeriesRecommendationsLoaded(tTvSeriesList);
      final state2 = TvSeriesRecommendationsLoaded(tTvSeriesList);
      expect(state1, state2);
    });

    test('TvSeriesRecommendationsError should have correct props', () {
      const message = 'Error message';
      final state = const TvSeriesRecommendationsError(message);
      expect(state.props, [message]);
    });

    test('TvSeriesRecommendationsError with same message should be equal', () {
      const message = 'Error message';
      final state1 = const TvSeriesRecommendationsError(message);
      final state2 = const TvSeriesRecommendationsError(message);
      expect(state1, state2);
    });

    test('TvSeriesRecommendationsError with different message should not be equal', () {
      final state1 = const TvSeriesRecommendationsError('Error 1');
      final state2 = const TvSeriesRecommendationsError('Error 2');
      expect(state1, isNot(state2));
    });
  });
}