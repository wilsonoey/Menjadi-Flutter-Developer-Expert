import 'dart:convert';

import 'package:ditonton/data/models/tv/tv_series_model.dart';
import 'package:ditonton/data/models/tv/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../json_reader.dart';

void main() {
  final tTVSeriesModel = TVSeriesModel(
    backdropPath: '/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg',
    firstAirDate: '2011-04-17',
    genreIds: [10765, 10759, 18],
    id: 1399,
    name: 'Game of Thrones',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Game of Thrones',
    overview:
        "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 29.780826,
    posterPath: '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
    voteAverage: 7.91,
    voteCount: 1172,
  );

  final tTVSeriesResponseModel =
      TVSeriesResponse(tvSeriesList: <TVSeriesModel>[tTVSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/on_the_air.json'));
      // act
      final result = TVSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTVSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg",
            "first_air_date": "2011-04-17",
            "genre_ids": [10765, 10759, 18],
            "id": 1399,
            "name": "Game of Thrones",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Game of Thrones",
            "overview":
                "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
            "popularity": 29.780826,
            "poster_path": "/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg",
            "vote_average": 7.91,
            "vote_count": 1172
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}