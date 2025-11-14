import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv/season_model.dart';
import 'package:ditonton/domain/entities/tv/season.dart';

void main() {
  group('SeasonModel', () {
    const tAirDate = '2008-01-20';
    const tEpisodeCount = 13;
    const tId = 3573;
    const tName = 'Season 1';
    const tOverview = 'Season overview';
    const tPosterPath = '/poster.jpg';
    const tSeasonNumber = 1;

    final tSeasonModel = SeasonModel(
      airDate: tAirDate,
      episodeCount: tEpisodeCount,
      id: tId,
      name: tName,
      overview: tOverview,
      posterPath: tPosterPath,
      seasonNumber: tSeasonNumber,
    );

    final tSeason = Season(
      airDate: tAirDate,
      episodeCount: tEpisodeCount,
      id: tId,
      name: tName,
      overview: tOverview,
      posterPath: tPosterPath,
      seasonNumber: tSeasonNumber,
    );

    test('should create SeasonModel instance correctly', () {
      expect(tSeasonModel.id, tId);
      expect(tSeasonModel.name, tName);
      expect(tSeasonModel.seasonNumber, tSeasonNumber);
    });

    test('should convert JSON to SeasonModel', () {
      final jsonMap = {
        "air_date": tAirDate,
        "episode_count": tEpisodeCount,
        "id": tId,
        "name": tName,
        "overview": tOverview,
        "poster_path": tPosterPath,
        "season_number": tSeasonNumber,
      };

      final result = SeasonModel.fromJson(jsonMap);

      expect(result, tSeasonModel);
    });

    test('should convert SeasonModel to JSON', () {
      final result = tSeasonModel.toJson();

      final expectedJsonMap = {
        "air_date": tAirDate,
        "episode_count": tEpisodeCount,
        "id": tId,
        "name": tName,
        "overview": tOverview,
        "poster_path": tPosterPath,
        "season_number": tSeasonNumber,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert SeasonModel to Season entity', () {
      final result = tSeasonModel.toEntity();

      expect(result, tSeason);
    });

    test('should be equal when properties are same', () {
      final seasonModel1 = SeasonModel(
        airDate: tAirDate,
        episodeCount: tEpisodeCount,
        id: tId,
        name: tName,
        overview: tOverview,
        posterPath: tPosterPath,
        seasonNumber: tSeasonNumber,
      );

      expect(seasonModel1, tSeasonModel);
    });

    test('props should contain all properties', () {
      expect(
        tSeasonModel.props,
        [tAirDate, tEpisodeCount, tId, tName, tOverview, tPosterPath, tSeasonNumber],
      );
    });
  });
}