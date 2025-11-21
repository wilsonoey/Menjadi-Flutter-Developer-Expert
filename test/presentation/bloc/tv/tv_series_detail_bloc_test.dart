import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListTVSeriesStatus,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetWatchListTVSeriesStatus mockGetWatchListStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlist;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlist;

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetWatchListStatus = MockGetWatchListTVSeriesStatus();
    mockSaveWatchlist = MockSaveWatchlistTVSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTVSeries();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTVSeriesDetail,
      getWatchlistTvSeriesStatus: mockGetWatchListStatus,
      removeWatchlistTvSeries: mockRemoveWatchlist,
      saveWatchlistTvSeries: mockSaveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be Loading', () {
    expect(tvSeriesDetailBloc.state, const TvSeriesDetailLoading());
  });

  group('Event Properties', () {
    test('TvSeriesDetailEvent props should return empty list', () {
      final event = const FetchTvSeriesDetail(tId);
      expect(event.props, [tId]);
    });

    test('FetchTvSeriesDetail should have correct props', () {
      final event = const FetchTvSeriesDetail(tId);
      expect(event.props, [tId]);
    });

    test('AddTvSeriesToWatchlist should have correct props', () {
      final event = AddTvSeriesToWatchlist(testTVSeriesDetail);
      expect(event.props, [testTVSeriesDetail]);
    });

    test('RemoveTvSeriesFromWatchlist should have correct props', () {
      final event = RemoveTvSeriesFromWatchlist(testTVSeriesDetail);
      expect(event.props, [testTVSeriesDetail]);
    });

    test('LoadTvSeriesWatchlistStatus should have correct props', () {
      final event = const LoadTvSeriesWatchlistStatus(tId);
      expect(event.props, [tId]);
    });
  });

  group('Get Tv Series Detail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVSeriesDetail));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailLoading(),
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
      ],
      verify: (_) {
        verify(mockGetTVSeriesDetail.execute(tId));
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Loaded] when watchlist status is true',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVSeriesDetail));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailLoading(),
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailLoading(),
        const TvSeriesDetailError('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetTVSeriesDetail.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Error] when database failure',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(DatabaseFailure('Database error')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailLoading(),
        const TvSeriesDetailError('Database error'),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit [Loading, Error] when connection failure',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed to connect')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvSeriesDetail(tId)),
      expect: () => [
        const TvSeriesDetailLoading(),
        const TvSeriesDetailError('Failed to connect'),
      ],
    );
  });

  group('Tv Series Detail States', () {
    test('TvSeriesDetailEmpty should be equatable', () {
      expect(const TvSeriesDetailEmpty(), const TvSeriesDetailEmpty());
    });

    test('TvSeriesDetailLoading should be equatable', () {
      expect(const TvSeriesDetailLoading(), const TvSeriesDetailLoading());
    });

    test('TvSeriesDetailError should be equatable', () {
      expect(const TvSeriesDetailError('Error'), const TvSeriesDetailError('Error'));
    });

    test('TvSeriesDetailLoaded copyWith with all fields', () {
      final loaded = TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false);
      final copied = loaded.copyWith(isAddedToWatchlist: true);
      
      expect(copied.isAddedToWatchlist, true);
      expect(copied.tvSeries, testTVSeriesDetail);
    });

    test('TvSeriesDetailLoaded copyWith with null fields uses existing', () {
      final loaded = TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false);
      final copied = loaded.copyWith();
      
      expect(copied.isAddedToWatchlist, false);
      expect(copied.tvSeries, testTVSeriesDetail);
    });

    test('TvSeriesWatchlistMessage with all fields', () {
      final message = TvSeriesWatchlistMessage('Test', tvSeries: testTVSeriesDetail, isAddedToWatchlist: true);
      
      expect(message.message, 'Test');
      expect(message.tvSeries, testTVSeriesDetail);
      expect(message.isAddedToWatchlist, true);
    });

    test('TvSeriesWatchlistMessage with null optional fields', () {
      const message = TvSeriesWatchlistMessage('Test');
      
      expect(message.message, 'Test');
      expect(message.tvSeries, null);
      expect(message.isAddedToWatchlist, null);
    });
  });

  group('Tv Series Detail Events', () {
    test('FetchTvSeriesDetail event should be equatable', () {
      expect(const FetchTvSeriesDetail(1), const FetchTvSeriesDetail(1));
    });

    test('FetchTvSeriesDetail event should not equal different id', () {
      expect(const FetchTvSeriesDetail(1), isNot(const FetchTvSeriesDetail(2)));
    });

    test('AddTvSeriesToWatchlist event should be equatable', () {
      expect(AddTvSeriesToWatchlist(testTVSeriesDetail), AddTvSeriesToWatchlist(testTVSeriesDetail));
    });

    test('RemoveTvSeriesFromWatchlist event should be equatable', () {
      expect(RemoveTvSeriesFromWatchlist(testTVSeriesDetail), RemoveTvSeriesFromWatchlist(testTVSeriesDetail));
    });

    test('LoadTvSeriesWatchlistStatus event should be equatable', () {
      expect(const LoadTvSeriesWatchlistStatus(1), const LoadTvSeriesWatchlistStatus(1));
    });
  });

  group('Add to Watchlist TV Series', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit Loaded then success message when add watchlist success',
      build: () {
        when(mockSaveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => true);
        
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddTvSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
        const TvSeriesWatchlistMessage('Added to Watchlist'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTVSeriesDetail));
        verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit error message when add watchlist failed with loaded state',
      build: () {
        when(mockSaveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(AddTvSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        isA<TvSeriesWatchlistMessage>()
            .having((m) => m.message, 'message', 'Failed')
            .having((m) => m.tvSeries, 'tvSeries', testTVSeriesDetail)
            .having((m) => m.isAddedToWatchlist, 'isAddedToWatchlist', false),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTVSeriesDetail));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit error when add watchlist fails without loaded state',
      build: () {
        when(mockSaveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddTvSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        const TvSeriesDetailError('Failed'),
      ],
    );
  });

  group('Remove TV Series from Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit Loaded then success message when remove watchlist success',
      build: () {
        when(mockRemoveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => false);
        
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
        const TvSeriesWatchlistMessage('Removed from Watchlist'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(testTVSeriesDetail));
        verify(mockGetWatchListStatus.execute(testTVSeriesDetail.id));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit error message when remove watchlist failed with loaded state',
      build: () {
        when(mockRemoveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        isA<TvSeriesWatchlistMessage>()
            .having((m) => m.message, 'message', 'Failed')
            .having((m) => m.tvSeries, 'tvSeries', testTVSeriesDetail)
            .having((m) => m.isAddedToWatchlist, 'isAddedToWatchlist', true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should emit error when remove watchlist fails without loaded state',
      build: () {
        when(mockRemoveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        const TvSeriesDetailError('Failed'),
      ],
    );
  });

  group('Load Watchlist Status', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should update watchlist status to true',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
      act: (bloc) => bloc.add(const LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchListStatus.execute(tId));
      },
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should update watchlist status to false',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvSeriesDetailBloc;
      },
      seed: () => TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: true),
      act: (bloc) => bloc.add(const LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        TvSeriesDetailLoaded(testTVSeriesDetail, isAddedToWatchlist: false),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'Should not emit when state is not loaded',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvSeriesDetailBloc;
      },
      seed: () => const TvSeriesDetailLoading(),
      act: (bloc) => bloc.add(const LoadTvSeriesWatchlistStatus(tId)),
      expect: () => [],
    );
  });
}