import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie/genre_model.dart';
import 'package:ditonton/data/models/tv/season_model.dart';
import 'package:ditonton/data/models/tv/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/movie/genre.dart';
import 'package:ditonton/domain/entities/tv/season.dart';
import 'package:ditonton/domain/entities/tv/tv_series_detail.dart';

void main() {
  group('TVSeriesDetailResponse', () {
    final tGenreModel = GenreModel(id: 18, name: 'Drama');
    final tGenreEntity = Genre(id: 18, name: 'Drama');

    final tSeasonModel = SeasonModel(
      airDate: '2008-01-20',
      episodeCount: 13,
      id: 3573,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    );

    final tSeasonEntity = Season(
      airDate: '2008-01-20',
      episodeCount: 13,
      id: 3573,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
    );

    final tTVSeriesDetailResponse = TVSeriesDetailResponse(
      backdropPath: '/backdrop.jpg',
      episodeRunTime: [42],
      firstAirDate: '2008-01-20',
      genres: [tGenreModel],
      id: 1396,
      lastAirDate: '2013-05-19',
      name: 'Breaking Bad',
      numberOfEpisodes: 62,
      numberOfSeasons: 5,
      originalName: 'Breaking Bad',
      overview: 'A high school chemistry teacher turned meth cook.',
      popularity: 30.0,
      posterPath: '/poster.jpg',
      seasons: [tSeasonModel],
      status: 'Ended',
      tagline: 'Remember my name',
      type: 'Scripted',
      voteAverage: 9.5,
      voteCount: 11000,
    );

    final tTVSeriesDetail = TVSeriesDetail(
      backdropPath: '/backdrop.jpg',
      episodeRunTime: [42],
      firstAirDate: '2008-01-20',
      genres: [tGenreEntity],
      id: 1396,
      lastAirDate: '2013-05-19',
      name: 'Breaking Bad',
      numberOfEpisodes: 62,
      numberOfSeasons: 5,
      originalName: 'Breaking Bad',
      overview: 'A high school chemistry teacher turned meth cook.',
      popularity: 30.0,
      posterPath: '/poster.jpg',
      seasons: [tSeasonEntity],
      status: 'Ended',
      tagline: 'Remember my name',
      type: 'Scripted',
      voteAverage: 9.5,
      voteCount: 11000,
    );

    test('should create TVSeriesDetailResponse instance correctly', () {
      expect(tTVSeriesDetailResponse.id, 1396);
      expect(tTVSeriesDetailResponse.name, 'Breaking Bad');
      expect(tTVSeriesDetailResponse.numberOfSeasons, 5);
    });

    test('should convert JSON to TVSeriesDetailResponse', () {
      final jsonMap = {
        "backdrop_path": "/backdrop.jpg",
        "episode_run_time": [42],
        "first_air_date": "2008-01-20",
        "genres": [{"id": 18, "name": "Drama"}],
        "id": 1396,
        "last_air_date": "2013-05-19",
        "name": "Breaking Bad",
        "number_of_episodes": 62,
        "number_of_seasons": 5,
        "original_name": "Breaking Bad",
        "overview": "A high school chemistry teacher turned meth cook.",
        "popularity": 30.0,
        "poster_path": "/poster.jpg",
        "seasons": [
          {
            "air_date": "2008-01-20",
            "episode_count": 13,
            "id": 3573,
            "name": "Season 1",
            "overview": "Season overview",
            "poster_path": "/poster.jpg",
            "season_number": 1,
          }
        ],
        "status": "Ended",
        "tagline": "Remember my name",
        "type": "Scripted",
        "vote_average": 9.5,
        "vote_count": 11000,
      };

      final result = TVSeriesDetailResponse.fromJson(jsonMap);

      expect(result, tTVSeriesDetailResponse);
    });

    test('should convert TVSeriesDetailResponse to JSON', () {
      final result = tTVSeriesDetailResponse.toJson();

      final expectedJsonMap = {
        "backdrop_path": "/backdrop.jpg",
        "episode_run_time": [42],
        "first_air_date": "2008-01-20",
        "genres": [{"id": 18, "name": "Drama"}],
        "id": 1396,
        "last_air_date": "2013-05-19",
        "name": "Breaking Bad",
        "number_of_episodes": 62,
        "number_of_seasons": 5,
        "original_name": "Breaking Bad",
        "overview": "A high school chemistry teacher turned meth cook.",
        "popularity": 30.0,
        "poster_path": "/poster.jpg",
        "seasons": [
          {
            "air_date": "2008-01-20",
            "episode_count": 13,
            "id": 3573,
            "name": "Season 1",
            "overview": "Season overview",
            "poster_path": "/poster.jpg",
            "season_number": 1,
          }
        ],
        "status": "Ended",
        "tagline": "Remember my name",
        "type": "Scripted",
        "vote_average": 9.5,
        "vote_count": 11000,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert TVSeriesDetailResponse to TVSeriesDetail entity', () {
      final result = tTVSeriesDetailResponse.toEntity();

      expect(result, tTVSeriesDetail);
    });

    test('should have correct props for Equatable', () {
      expect(
        tTVSeriesDetailResponse.props,
        [
          '/backdrop.jpg',
          [42],
          '2008-01-20',
          [tGenreModel],
          1396,
          '2013-05-19',
          'Breaking Bad',
          62,
          5,
          'Breaking Bad',
          'A high school chemistry teacher turned meth cook.',
          30.0,
          '/poster.jpg',
          [tSeasonModel],
          'Ended',
          'Remember my name',
          'Scripted',
          9.5,
          11000,
        ],
      );
    });

    test('should be equal when properties are same', () {
      final tvDetail1 = TVSeriesDetailResponse(
        backdropPath: '/backdrop.jpg',
        episodeRunTime: [42],
        firstAirDate: '2008-01-20',
        genres: [tGenreModel],
        id: 1396,
        lastAirDate: '2013-05-19',
        name: 'Breaking Bad',
        numberOfEpisodes: 62,
        numberOfSeasons: 5,
        originalName: 'Breaking Bad',
        overview: 'A high school chemistry teacher turned meth cook.',
        popularity: 30.0,
        posterPath: '/poster.jpg',
        seasons: [tSeasonModel],
        status: 'Ended',
        tagline: 'Remember my name',
        type: 'Scripted',
        voteAverage: 9.5,
        voteCount: 11000,
      );

      expect(tvDetail1, tTVSeriesDetailResponse);
    });
  });
}