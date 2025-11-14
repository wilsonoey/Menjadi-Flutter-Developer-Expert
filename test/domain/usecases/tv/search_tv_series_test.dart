import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SearchTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TVSeries>[];
  final tQuery = 'Game of Thrones';

  group('SearchTVSeries', () {
    test('should get list of tv series from the repository', () async {
      // arrange
      when(mockTVSeriesRepository.searchTVSeries(tQuery))
          .thenAnswer((_) async => Right(tTVSeries));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTVSeries));
      verify(mockTVSeriesRepository.searchTVSeries(tQuery));
    });
  });
}