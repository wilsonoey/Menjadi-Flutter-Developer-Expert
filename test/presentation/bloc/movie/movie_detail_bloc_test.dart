import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be Loading', () {
    expect(movieDetailBloc.state, MovieDetailLoading());
  });

  group('Event Properties', () {
    test('MovieDetailEvent props should return empty list', () {
      final event = FetchMovieDetail(tId);
      expect(event.props, [tId]);
    });

    test('FetchMovieDetail should have correct props', () {
      final event = FetchMovieDetail(tId);
      expect(event.props, [tId]);
    });

    test('AddMovieToWatchlist should have correct props', () {
      final event = AddMovieToWatchlist(testMovieDetail);
      expect(event.props, [testMovieDetail]);
    });

    test('RemoveMovieFromWatchlist should have correct props', () {
      final event = RemoveMovieFromWatchlist(testMovieDetail);
      expect(event.props, [testMovieDetail]);
    });

    test('LoadWatchlistStatus should have correct props', () {
      final event = LoadWatchlistStatus(tId);
      expect(event.props, [tId]);
    });
  });

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when watchlist status is true',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when database failure',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(DatabaseFailure('Database error')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Database error'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when connection failure',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed to connect')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Failed to connect'),
      ],
    );
  });

  group('Movie Detail States', () {
    test('MovieDetailEmpty should be equatable', () {
      expect(const MovieDetailEmpty(), const MovieDetailEmpty());
    });

    test('MovieDetailLoading should be equatable', () {
      expect(const MovieDetailLoading(), const MovieDetailLoading());
    });

    test('MovieDetailError should be equatable', () {
      expect(const MovieDetailError('Error'), const MovieDetailError('Error'));
    });

    test('MovieDetailLoaded copyWith with all fields', () {
      final loaded = MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false);
      final copied = loaded.copyWith(isAddedToWatchlist: true);
      
      expect(copied.isAddedToWatchlist, true);
      expect(copied.movie, testMovieDetail);
    });

    test('MovieDetailLoaded copyWith with null fields uses existing', () {
      final loaded = MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false);
      final copied = loaded.copyWith();
      
      expect(copied.isAddedToWatchlist, false);
      expect(copied.movie, testMovieDetail);
    });

    test('MovieWatchlistMessage with all fields', () {
      final message = MovieWatchlistMessage('Test', movie: testMovieDetail, isAddedToWatchlist: true);
      
      expect(message.message, 'Test');
      expect(message.movie, testMovieDetail);
      expect(message.isAddedToWatchlist, true);
    });

    test('MovieWatchlistMessage with null optional fields', () {
      const message = MovieWatchlistMessage('Test');
      
      expect(message.message, 'Test');
      expect(message.movie, null);
      expect(message.isAddedToWatchlist, null);
    });
  });

  group('Movie Detail Events', () {
    test('FetchMovieDetail event should be equatable', () {
      expect(const FetchMovieDetail(1), const FetchMovieDetail(1));
    });

    test('FetchMovieDetail event should not equal different id', () {
      expect(const FetchMovieDetail(1), isNot(const FetchMovieDetail(2)));
    });

    test('AddMovieToWatchlist event should be equatable', () {
      expect(AddMovieToWatchlist(testMovieDetail), AddMovieToWatchlist(testMovieDetail));
    });

    test('RemoveMovieFromWatchlist event should be equatable', () {
      expect(RemoveMovieFromWatchlist(testMovieDetail), RemoveMovieFromWatchlist(testMovieDetail));
    });

    test('LoadWatchlistStatus event should be equatable', () {
      expect(const LoadWatchlistStatus(1), const LoadWatchlistStatus(1));
    });
  });

  group('Add to Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit Loaded then success message when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
        const MovieWatchlistMessage('Added to Watchlist'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit error message when add watchlist failed with loaded state',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieWatchlistMessage>()
            .having((m) => m.message, 'message', 'Failed')
            .having((m) => m.movie, 'movie', testMovieDetail)
            .having((m) => m.isAddedToWatchlist, 'isAddedToWatchlist', false),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit error when add watchlist fails without loaded state',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailError('Failed'),
      ],
    );
  });

  group('Remove from Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit Loaded then success message when remove watchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
        const MovieWatchlistMessage('Removed from Watchlist'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchListStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit error message when remove watchlist failed with loaded state',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieWatchlistMessage>()
            .having((m) => m.message, 'message', 'Failed')
            .having((m) => m.movie, 'movie', testMovieDetail)
            .having((m) => m.isAddedToWatchlist, 'isAddedToWatchlist', true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit error when remove watchlist fails without loaded state',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailError('Failed'),
      ],
    );
  });

  group('Load Watchlist Status', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should update watchlist status to true',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should update watchlist status to false',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      seed: () => MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        MovieDetailLoaded(testMovieDetail, isAddedToWatchlist: false),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should not emit when state is not loaded',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      seed: () => const MovieDetailLoading(),
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [],
    );
  });
}