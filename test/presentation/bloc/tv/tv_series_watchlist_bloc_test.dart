import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'tv_series_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTVSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTVSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  tearDown(() {
    watchlistTvSeriesBloc.close();
  });

  test('initial state should be loading', () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesLoading());
  });

  group('WatchlistTvSeriesEvent', () {
    test('FetchWatchlistTvSeries should have correct props', () {
      final event = FetchWatchlistTvSeries();
      expect(event.props, []);
    });

    test('FetchWatchlistTvSeries instances should be equal', () {
      final event1 = FetchWatchlistTvSeries();
      final event2 = FetchWatchlistTvSeries();
      expect(event1, event2);
    });
  });

  group('Fetch Watchlist TV Series', () {
    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([testTVSeries]));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesLoaded([testTVSeries]),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Loaded] with empty list when no TV series',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesLoaded([]),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Error] when ServerFailure occurs',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Error] when ConnectionFailure occurs',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed to connect')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesError('Failed to connect'),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Error] when DatabaseFailure occurs',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Left(DatabaseFailure('Database error')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        const WatchlistTvSeriesError('Database error'),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Loaded] with multiple TV series',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right([testTVSeries, testTVSeries]));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesLoaded([testTVSeries, testTVSeries]),
      ],
      verify: (_) {
        verify(mockGetWatchlistTvSeries.execute()).called(1);
      },
    );
  });

  group('WatchlistTvSeriesState', () {
    test('WatchlistTvSeriesEmpty should have correct props', () {
      final state = WatchlistTvSeriesEmpty();
      expect(state.props, []);
    });

    test('WatchlistTvSeriesEmpty instances should be equal', () {
      final state1 = WatchlistTvSeriesEmpty();
      final state2 = WatchlistTvSeriesEmpty();
      expect(state1, state2);
    });

    test('WatchlistTvSeriesLoading should have correct props', () {
      final state = WatchlistTvSeriesLoading();
      expect(state.props, []);
    });

    test('WatchlistTvSeriesLoading instances should be equal', () {
      final state1 = WatchlistTvSeriesLoading();
      final state2 = WatchlistTvSeriesLoading();
      expect(state1, state2);
    });

    test('WatchlistTvSeriesLoaded should have correct props', () {
      final state = WatchlistTvSeriesLoaded([testTVSeries]);
      expect(state.props, [[testTVSeries]]);
    });

    test('WatchlistTvSeriesLoaded with same series should be equal', () {
      final state1 = WatchlistTvSeriesLoaded([testTVSeries]);
      final state2 = WatchlistTvSeriesLoaded([testTVSeries]);
      expect(state1, state2);
    });

    test('WatchlistTvSeriesLoaded with different series should not be equal', () {
      final state1 = WatchlistTvSeriesLoaded([testTVSeries]);
      final state2 = const WatchlistTvSeriesLoaded([]);
      expect(state1, isNot(state2));
    });

    test('WatchlistTvSeriesError should have correct props', () {
      const message = 'Error message';
      final state = const WatchlistTvSeriesError(message);
      expect(state.props, [message]);
    });

    test('WatchlistTvSeriesError with same message should be equal', () {
      const state1 = WatchlistTvSeriesError('Error message');
      const state2 = WatchlistTvSeriesError('Error message');
      expect(state1, state2);
    });

    test('WatchlistTvSeriesError with different message should not be equal', () {
      const state1 = WatchlistTvSeriesError('Error 1');
      const state2 = WatchlistTvSeriesError('Error 2');
      expect(state1, isNot(state2));
    });
  });
}