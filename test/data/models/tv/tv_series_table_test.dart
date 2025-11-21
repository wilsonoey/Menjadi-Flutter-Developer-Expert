import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/entities/tv/tv_series_detail.dart';

void main() {
  group('TVSeriesTable', () {
    const tId = 1396;
    const tName = 'Breaking Bad';
    const tPosterPath = '/poster.jpg';
    const tOverview = 'A high school chemistry teacher turned meth cook.';

    final tTVSeriesTable = const TVSeriesTable(
      id: tId,
      name: tName,
      posterPath: tPosterPath,
      overview: tOverview,
    );

    final tTVSeriesDetail = const TVSeriesDetail(
      id: tId,
      name: tName,
      posterPath: tPosterPath,
      overview: tOverview,
      backdropPath: '/backdrop.jpg',
      episodeRunTime: [42],
      firstAirDate: '2008-01-20',
      genres: [],
      lastAirDate: '2013-05-19',
      numberOfEpisodes: 62,
      numberOfSeasons: 5,
      originalName: 'Breaking Bad',
      popularity: 30.0,
      seasons: [],
      status: 'Ended',
      tagline: 'Remember my name',
      type: 'Scripted',
      voteAverage: 9.5,
      voteCount: 11000,
    );

    final tTVSeries = TVSeries.watchlist(
      id: tId,
      name: tName,
      posterPath: tPosterPath,
      overview: tOverview,
    );

    test('should create TVSeriesTable instance correctly', () {
      expect(tTVSeriesTable.id, tId);
      expect(tTVSeriesTable.name, tName);
      expect(tTVSeriesTable.posterPath, tPosterPath);
      expect(tTVSeriesTable.overview, tOverview);
    });

    test('should create TVSeriesTable from TVSeriesDetail entity', () {
      final result = TVSeriesTable.fromEntity(tTVSeriesDetail);

      expect(result, tTVSeriesTable);
    });

    test('should create TVSeriesTable from Map', () {
      final map = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = TVSeriesTable.fromMap(map);

      expect(result, tTVSeriesTable);
    });

    test('should convert TVSeriesTable to JSON', () {
      final result = tTVSeriesTable.toJson();

      final expectedJsonMap = {
        'id': tId,
        'name': tName,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert TVSeriesTable to TVSeries entity', () {
      final result = tTVSeriesTable.toEntity();

      expect(result, tTVSeries);
    });

    test('props should contain all properties', () {
      expect(
        tTVSeriesTable.props,
        [tId, tName, tPosterPath, tOverview],
      );
    });

    test('should be equal when properties are same', () {
      final tvSeriesTable1 = const TVSeriesTable(
        id: tId,
        name: tName,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(tvSeriesTable1, tTVSeriesTable);
    });

    test('should handle null values correctly', () {
      final tvSeriesTableWithNull = const TVSeriesTable(
        id: 1,
        name: null,
        posterPath: null,
        overview: null,
      );

      expect(tvSeriesTableWithNull.name, isNull);
      expect(tvSeriesTableWithNull.posterPath, isNull);
      expect(tvSeriesTableWithNull.overview, isNull);
    });

    test('should convert TVSeriesTable with null values to JSON', () {
      final tvSeriesTableWithNull = const TVSeriesTable(
        id: 1,
        name: null,
        posterPath: null,
        overview: null,
      );

      final result = tvSeriesTableWithNull.toJson();

      final expectedJsonMap = {
        'id': 1,
        'name': null,
        'posterPath': null,
        'overview': null,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert TVSeriesTable with null values to TVSeries entity', () {
      final tvSeriesTableWithNull = const TVSeriesTable(
        id: 1,
        name: null,
        posterPath: null,
        overview: null,
      );

      final result = tvSeriesTableWithNull.toEntity();

      expect(result.id, 1);
      expect(result.name, isNull);
      expect(result.posterPath, isNull);
      expect(result.overview, isNull);
    });
  });
}