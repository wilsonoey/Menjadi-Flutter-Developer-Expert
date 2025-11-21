import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  tearDown(() {
    watchlistMoviesBloc.close();
  });

  test('initial state should be loading', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesLoading());
  });

  group('WatchlistMoviesEvent', () {
    test('FetchWatchlistMovies should have correct props', () {
      final event = FetchWatchlistMovies();
      expect(event.props, []);
    });

    test('FetchWatchlistMovies instances should be equal', () {
      final event1 = FetchWatchlistMovies();
      final event2 = FetchWatchlistMovies();
      expect(event1, event2);
    });
  });

  group('Fetch Watchlist Movies', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testMovie]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesLoaded([testMovie]),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Loaded] with empty list when no movies',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        const WatchlistMoviesLoaded([]),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when ServerFailure occurs',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        const WatchlistMoviesError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when ConnectionFailure occurs',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed to connect')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        const WatchlistMoviesError('Failed to connect'),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when DatabaseFailure occurs',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(DatabaseFailure('Database error')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        const WatchlistMoviesError('Database error'),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Loaded] with multiple movies',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testMovie, testMovie]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesLoaded([testMovie, testMovie]),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute()).called(1);
      },
    );
  });

  group('WatchlistMoviesState', () {
    test('WatchlistMoviesEmpty should have correct props', () {
      final state = WatchlistMoviesEmpty();
      expect(state.props, []);
    });

    test('WatchlistMoviesEmpty instances should be equal', () {
      final state1 = WatchlistMoviesEmpty();
      final state2 = WatchlistMoviesEmpty();
      expect(state1, state2);
    });

    test('WatchlistMoviesLoading should have correct props', () {
      final state = WatchlistMoviesLoading();
      expect(state.props, []);
    });

    test('WatchlistMoviesLoading instances should be equal', () {
      final state1 = WatchlistMoviesLoading();
      final state2 = WatchlistMoviesLoading();
      expect(state1, state2);
    });

    test('WatchlistMoviesLoaded should have correct props', () {
      final state = WatchlistMoviesLoaded([testMovie]);
      expect(state.props, [[testMovie]]);
    });

    test('WatchlistMoviesLoaded with same movies should be equal', () {
      final state1 = WatchlistMoviesLoaded([testMovie]);
      final state2 = WatchlistMoviesLoaded([testMovie]);
      expect(state1, state2);
    });

    test('WatchlistMoviesLoaded with different movies should not be equal', () {
      final state1 = WatchlistMoviesLoaded([testMovie]);
      final state2 = const WatchlistMoviesLoaded([]);
      expect(state1, isNot(state2));
    });

    test('WatchlistMoviesError should have correct props', () {
      const message = 'Error message';
      final state = const WatchlistMoviesError(message);
      expect(state.props, [message]);
    });

    test('WatchlistMoviesError with same message should be equal', () {
      const state1 = WatchlistMoviesError('Error message');
      const state2 = WatchlistMoviesError('Error message');
      expect(state1, state2);
    });

    test('WatchlistMoviesError with different message should not be equal', () {
      const state1 = WatchlistMoviesError('Error 1');
      const state2 = WatchlistMoviesError('Error 2');
      expect(state1, isNot(state2));
    });
  });
}