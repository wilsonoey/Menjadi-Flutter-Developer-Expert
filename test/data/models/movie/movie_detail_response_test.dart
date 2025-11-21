import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie/genre_model.dart';
import 'package:ditonton/data/models/movie/movie_detail_model.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/entities/movie/genre.dart';

void main() {
  group('MovieDetailResponse', () {
    final tGenreModel = const GenreModel(id: 28, name: 'Action');
    final tGenreEntity = const Genre(id: 28, name: 'Action');

    final tMovieDetailResponse = MovieDetailResponse(
      adult: false,
      backdropPath: '/backdrop.jpg',
      budget: 100000000,
      genres: [tGenreModel],
      homepage: 'https://example.com',
      id: 550,
      imdbId: 'tt0137523',
      originalLanguage: 'en',
      originalTitle: 'Fight Club',
      overview: 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
      popularity: 25.5,
      posterPath: '/poster.jpg',
      releaseDate: '1999-10-15',
      revenue: 100853753,
      runtime: 139,
      status: 'Released',
      tagline: 'Mischief. Mayhem. Soap.',
      title: 'Fight Club',
      video: false,
      voteAverage: 8.8,
      voteCount: 26280,
    );

    final tMovieDetail = MovieDetail(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genres: [tGenreEntity],
      id: 550,
      originalTitle: 'Fight Club',
      overview: 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
      posterPath: '/poster.jpg',
      releaseDate: '1999-10-15',
      runtime: 139,
      title: 'Fight Club',
      voteAverage: 8.8,
      voteCount: 26280,
    );

    test('should create MovieDetailResponse instance correctly', () {
      expect(tMovieDetailResponse.id, 550);
      expect(tMovieDetailResponse.title, 'Fight Club');
      expect(tMovieDetailResponse.adult, false);
      expect(tMovieDetailResponse.budget, 100000000);
      expect(tMovieDetailResponse.genres.length, 1);
    });

    test('should convert JSON to MovieDetailResponse', () {
      final jsonMap = {
        'adult': false,
        'backdrop_path': '/backdrop.jpg',
        'budget': 100000000,
        'genres': [{'id': 28, 'name': 'Action'}],
        'homepage': 'https://example.com',
        'id': 550,
        'imdb_id': 'tt0137523',
        'original_language': 'en',
        'original_title': 'Fight Club',
        'overview': 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
        'popularity': 25.5,
        'poster_path': '/poster.jpg',
        'release_date': '1999-10-15',
        'revenue': 100853753,
        'runtime': 139,
        'status': 'Released',
        'tagline': 'Mischief. Mayhem. Soap.',
        'title': 'Fight Club',
        'video': false,
        'vote_average': 8.8,
        'vote_count': 26280,
      };

      final result = MovieDetailResponse.fromJson(jsonMap);

      expect(result, tMovieDetailResponse);
    });

    test('should convert MovieDetailResponse to JSON', () {
      final result = tMovieDetailResponse.toJson();

      final expectedJsonMap = {
        'adult': false,
        'backdrop_path': '/backdrop.jpg',
        'budget': 100000000,
        'genres': [{'id': 28, 'name': 'Action'}],
        'homepage': 'https://example.com',
        'id': 550,
        'imdb_id': 'tt0137523',
        'original_language': 'en',
        'original_title': 'Fight Club',
        'overview': 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
        'popularity': 25.5,
        'poster_path': '/poster.jpg',
        'release_date': '1999-10-15',
        'revenue': 100853753,
        'runtime': 139,
        'status': 'Released',
        'tagline': 'Mischief. Mayhem. Soap.',
        'title': 'Fight Club',
        'video': false,
        'vote_average': 8.8,
        'vote_count': 26280,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert MovieDetailResponse to MovieDetail entity', () {
      final result = tMovieDetailResponse.toEntity();

      expect(result, tMovieDetail);
    });

    test('should have correct props for Equatable', () {
      expect(
        tMovieDetailResponse.props,
        [
          false,
          '/backdrop.jpg',
          100000000,
          [tGenreModel],
          'https://example.com',
          550,
          'tt0137523',
          'en',
          'Fight Club',
          'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
          25.5,
          '/poster.jpg',
          '1999-10-15',
          100853753,
          139,
          'Released',
          'Mischief. Mayhem. Soap.',
          'Fight Club',
          false,
          8.8,
          26280,
        ],
      );
    });

    test('should be equal when properties are same', () {
      final movieDetail1 = MovieDetailResponse(
        adult: false,
        backdropPath: '/backdrop.jpg',
        budget: 100000000,
        genres: [tGenreModel],
        homepage: 'https://example.com',
        id: 550,
        imdbId: 'tt0137523',
        originalLanguage: 'en',
        originalTitle: 'Fight Club',
        overview: 'An insomniac office worker and a devil-may-care soap maker form an underground fight club.',
        popularity: 25.5,
        posterPath: '/poster.jpg',
        releaseDate: '1999-10-15',
        revenue: 100853753,
        runtime: 139,
        status: 'Released',
        tagline: 'Mischief. Mayhem. Soap.',
        title: 'Fight Club',
        video: false,
        voteAverage: 8.8,
        voteCount: 26280,
      );

      expect(movieDetail1, tMovieDetailResponse);
    });
  });
}