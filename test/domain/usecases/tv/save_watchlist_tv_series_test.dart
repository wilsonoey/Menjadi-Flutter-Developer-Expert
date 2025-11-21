import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../dummy_data/tv/tv_series_dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SaveWatchlistTVSeries(mockTVSeriesRepository);
  });

  group('Save Watchlist TV Series Use Case Tests', () {
    test('should save tv series to the repository', () async {
      // arrange
      when(mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testTVSeriesDetail);
      // assert
      verify(mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail));
      expect(result, const Right('Added to Watchlist'));
    });
  });
}