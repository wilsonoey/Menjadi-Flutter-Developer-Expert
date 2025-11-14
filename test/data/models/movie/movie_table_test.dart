import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie/movie_table.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';

void main() {
  group('MovieTable', () {
    const tId = 550;
    const tTitle = 'Fight Club';
    const tPosterPath = '/poster.jpg';
    const tOverview = 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.';

    final tMovieTable = MovieTable(
      id: tId,
      title: tTitle,
      posterPath: tPosterPath,
      overview: tOverview,
    );

    final tMovieDetail = MovieDetail(
      id: tId,
      title: tTitle,
      posterPath: tPosterPath,
      overview: tOverview,
      adult: false,
      backdropPath: '/backdrop.jpg',
      genres: const [],
      originalTitle: 'Fight Club',
      releaseDate: '1999-10-15',
      runtime: 139,
      voteAverage: 8.8,
      voteCount: 26280,
    );

    final tMovie = Movie.watchlist(
      id: tId,
      title: tTitle,
      posterPath: tPosterPath,
      overview: tOverview,
    );

    test('should create MovieTable instance correctly', () {
      expect(tMovieTable.id, tId);
      expect(tMovieTable.title, tTitle);
      expect(tMovieTable.posterPath, tPosterPath);
      expect(tMovieTable.overview, tOverview);
    });

    test('should create MovieTable from MovieDetail entity', () {
      final result = MovieTable.fromEntity(tMovieDetail);

      expect(result, tMovieTable);
    });

    test('should create MovieTable from Map', () {
      final map = {
        'id': tId,
        'title': tTitle,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      final result = MovieTable.fromMap(map);

      expect(result, tMovieTable);
    });

    test('should convert MovieTable to JSON', () {
      final result = tMovieTable.toJson();

      final expectedJsonMap = {
        'id': tId,
        'title': tTitle,
        'posterPath': tPosterPath,
        'overview': tOverview,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert MovieTable to Movie entity', () {
      final result = tMovieTable.toEntity();

      expect(result, tMovie);
    });

    test('props should contain all properties', () {
      expect(
        tMovieTable.props,
        [tId, tTitle, tPosterPath, tOverview],
      );
    });

    test('should be equal when properties are same', () {
      final movieTable1 = MovieTable(
        id: tId,
        title: tTitle,
        posterPath: tPosterPath,
        overview: tOverview,
      );

      expect(movieTable1, tMovieTable);
    });

    test('should handle null values correctly', () {
      final movieTableWithNull = MovieTable(
        id: 1,
        title: null,
        posterPath: null,
        overview: null,
      );

      expect(movieTableWithNull.title, isNull);
      expect(movieTableWithNull.posterPath, isNull);
      expect(movieTableWithNull.overview, isNull);
    });

    test('should convert MovieTable with null values to JSON', () {
      final movieTableWithNull = MovieTable(
        id: 1,
        title: null,
        posterPath: null,
        overview: null,
      );

      final result = movieTableWithNull.toJson();

      final expectedJsonMap = {
        'id': 1,
        'title': null,
        'posterPath': null,
        'overview': null,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert MovieTable with null values to Movie entity', () {
      final movieTableWithNull = MovieTable(
        id: 1,
        title: null,
        posterPath: null,
        overview: null,
      );

      final result = movieTableWithNull.toEntity();

      expect(result.id, 1);
      expect(result.title, isNull);
      expect(result.posterPath, isNull);
      expect(result.overview, isNull);
    });
  });
}