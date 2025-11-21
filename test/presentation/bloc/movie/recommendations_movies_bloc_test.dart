import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendations/movie_recommendations_bloc.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationsBloc movieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc = MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  tearDown(() {
    movieRecommendationsBloc.close();
  });

  const tId = 1;
  const tId2 = 2;
  final tMovieList = <Movie>[testMovie];

  group('MovieRecommendationsEvent', () {
    test('FetchMovieRecommendations should have correct props', () {
      final event = const FetchMovieRecommendations(tId);
      expect(event.props, [tId]);
    });

    test('FetchMovieRecommendations with same id should be equal', () {
      final event1 = const FetchMovieRecommendations(tId);
      final event2 = const FetchMovieRecommendations(tId);
      expect(event1, event2);
    });

    test('FetchMovieRecommendations with different id should not be equal', () {
      final event1 = const FetchMovieRecommendations(tId);
      final event2 = const FetchMovieRecommendations(tId2);
      expect(event1, isNot(event2));
    });
  });

  group('MovieRecommendationsBloc', () {
    test('initial state should be MovieRecommendationsLoading', () {
      expect(movieRecommendationsBloc.state, MovieRecommendationsLoading());
    });

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsLoaded(tMovieList),
      ],
      verify: (_) {
        verify(mockGetMovieRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        const MovieRecommendationsError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetMovieRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, Loaded] with empty list when no recommendations',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        const MovieRecommendationsLoaded([]),
      ],
      verify: (_) {
        verify(mockGetMovieRecommendations.execute(tId)).called(1);
      },
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, Error] when connection failure occurs',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Connection Failure')));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        const MovieRecommendationsError('Connection Failure'),
      ],
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should emit [Loading, Error] when cache failure occurs',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(DatabaseFailure('Cache Failure')));
        return movieRecommendationsBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendations(tId)),
      expect: () => [
        MovieRecommendationsLoading(),
        const MovieRecommendationsError('Cache Failure'),
      ],
    );

    blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
      'Should handle multiple events sequentially',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return movieRecommendationsBloc;
      },
      act: (bloc) {
        bloc.add(const FetchMovieRecommendations(tId));
      },
      expect: () => [
        MovieRecommendationsLoading(),
        MovieRecommendationsLoaded(tMovieList),
      ],
    );
  });

  group('MovieRecommendationsState', () {
    test('MovieRecommendationsLoading should have correct props', () {
      final state = MovieRecommendationsLoading();
      expect(state.props, []);
    });

    test('MovieRecommendationsLoading instances should be equal', () {
      final state1 = MovieRecommendationsLoading();
      final state2 = MovieRecommendationsLoading();
      expect(state1, state2);
    });

    test('MovieRecommendationsLoaded should have correct props', () {
      final state = MovieRecommendationsLoaded(tMovieList);
      expect(state.props, [tMovieList]);
    });

    test('MovieRecommendationsLoaded with same list should be equal', () {
      final state1 = MovieRecommendationsLoaded(tMovieList);
      final state2 = MovieRecommendationsLoaded(tMovieList);
      expect(state1, state2);
    });

    test('MovieRecommendationsError should have correct props', () {
      const message = 'Error message';
      final state = const MovieRecommendationsError(message);
      expect(state.props, [message]);
    });

    test('MovieRecommendationsError with same message should be equal', () {
      const message = 'Error message';
      final state1 = const MovieRecommendationsError(message);
      final state2 = const MovieRecommendationsError(message);
      expect(state1, state2);
    });

    test('MovieRecommendationsError with different message should not be equal', () {
      final state1 = const MovieRecommendationsError('Error 1');
      final state2 = const MovieRecommendationsError('Error 2');
      expect(state1, isNot(state2));
    });
  });
}