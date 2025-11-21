import 'package:ditonton/data/models/tv/tv_series_table.dart';
import 'package:ditonton/domain/entities/movie/genre.dart';
import 'package:ditonton/domain/entities/tv/season.dart';
import 'package:ditonton/domain/entities/tv/tv_series.dart';
import 'package:ditonton/domain/entities/tv/tv_series_detail.dart';

final testTVSeries = const TVSeries(
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

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = const TVSeriesDetail(
  backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
  episodeRunTime: [60],
  firstAirDate: '2011-04-17',
  genres: [
    Genre(id: 10765, name: 'Sci-Fi & Fantasy'),
    Genre(id: 10759, name: 'Action & Adventure'),
    Genre(id: 18, name: 'Drama'),
  ],
  id: 1399,
  lastAirDate: '2019-05-19',
  name: 'Game of Thrones',
  numberOfEpisodes: 73,
  numberOfSeasons: 8,
  originalName: 'Game of Thrones',
  overview:
      "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  popularity: 346.098,
  posterPath: '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
  seasons: [
    Season(
      airDate: '2010-12-05',
      episodeCount: 64,
      id: 3627,
      name: 'Specials',
      overview: '',
      posterPath: '/kMTcwNRfFKCZ0O2OaBZS0nZ2AIe.jpg',
      seasonNumber: 0,
    ),
    Season(
      airDate: '2011-04-17',
      episodeCount: 10,
      id: 3624,
      name: 'Season 1',
      overview:
          "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the dynastic struggle among several families for control of Westeros, the rising threat of the largely forgotten race of fantastic creatures that live beyond Westeros' northern borders, and the ambition of an exiled heir to the throne.",
      posterPath: '/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg',
      seasonNumber: 1,
    ),
  ],
  status: 'Ended',
  tagline: 'Winter Is Coming',
  type: 'Scripted',
  voteAverage: 8.3,
  voteCount: 11504,
);

final testWatchlistTVSeries = TVSeries.watchlist(
  id: 1399,
  name: 'Game of Thrones',
  posterPath: '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
  overview:
      "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
);

final testTVSeriesTable = const TVSeriesTable(
  id: 1399,
  name: 'Game of Thrones',
  posterPath: '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
  overview:
      "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
);

final testTVSeriesMap = {
  'id': 1399,
  'overview':
      "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  'posterPath': '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
  'name': 'Game of Thrones',
};