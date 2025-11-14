import 'package:ditonton/injection.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_recommendations/tv_series_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_series_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initialize Flutter binding once for all tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Injection Container', () {
    setUp(() async {
      // Reset locator before each test
      await GetIt.instance.reset();
      
      // Initialize dependencies
      init();
      
      // Wait for all async registrations to complete
      await GetIt.instance.allReady();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    test('init() should register all dependencies', () async {
      expect(locator.isRegistered<DatabaseHelper>(), true);
      expect(locator.isRegistered<MovieRepository>(), true);
      expect(locator.isRegistered<TVSeriesRepository>(), true);
      expect(locator.isRegistered<http.Client>(), true);
    });

    group('BLoC Registration', () {
      test('NowPlayingMoviesBloc should be registered as factory', () {
        final bloc1 = locator<NowPlayingMoviesBloc>();
        final bloc2 = locator<NowPlayingMoviesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('PopularMoviesBloc should be registered as factory', () {
        final bloc1 = locator<PopularMoviesBloc>();
        final bloc2 = locator<PopularMoviesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('TopRatedMoviesBloc should be registered as factory', () {
        final bloc1 = locator<TopRatedMoviesBloc>();
        final bloc2 = locator<TopRatedMoviesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('MovieDetailBloc should be registered as factory', () {
        final bloc1 = locator<MovieDetailBloc>();
        final bloc2 = locator<MovieDetailBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('MovieDetailBloc should have getMovieDetail injected', () {
        final bloc = locator<MovieDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<GetMovieDetail>(), true);
      });

      test('MovieDetailBloc should have getWatchListStatus injected', () {
        final bloc = locator<MovieDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<GetWatchListStatus>(), true);
      });

      test('MovieDetailBloc should have saveWatchlist injected', () {
        final bloc = locator<MovieDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<SaveWatchlist>(), true);
      });

      test('MovieDetailBloc should have removeWatchlist injected', () {
        final bloc = locator<MovieDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<RemoveWatchlist>(), true);
      });

      test('MovieRecommendationsBloc should be registered as factory', () {
        final bloc1 = locator<MovieRecommendationsBloc>();
        final bloc2 = locator<MovieRecommendationsBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('MovieSearchBloc should be registered as factory', () {
        final bloc1 = locator<MovieSearchBloc>();
        final bloc2 = locator<MovieSearchBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('WatchlistMoviesBloc should be registered as factory', () {
        final bloc1 = locator<WatchlistMoviesBloc>();
        final bloc2 = locator<WatchlistMoviesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('OnTheAirTvSeriesBloc should be registered as factory', () {
        final bloc1 = locator<OnTheAirTvSeriesBloc>();
        final bloc2 = locator<OnTheAirTvSeriesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('PopularTvSeriesBloc should be registered as factory', () {
        final bloc1 = locator<PopularTvSeriesBloc>();
        final bloc2 = locator<PopularTvSeriesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('TopRatedTvSeriesBloc should be registered as factory', () {
        final bloc1 = locator<TopRatedTvSeriesBloc>();
        final bloc2 = locator<TopRatedTvSeriesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('TvSeriesDetailBloc should be registered as factory', () {
        final bloc1 = locator<TvSeriesDetailBloc>();
        final bloc2 = locator<TvSeriesDetailBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('TvSeriesDetailBloc should have GetTVSeriesDetail injected', () {
        final bloc = locator<TvSeriesDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<GetTVSeriesDetail>(), true);
      });

      test('TvSeriesDetailBloc should have GetWatchListTVSeriesStatus injected', () {
        final bloc = locator<TvSeriesDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<GetWatchListTVSeriesStatus>(), true);
      });

      test('TvSeriesDetailBloc should have SaveWatchlistTVSeries injected', () {
        final bloc = locator<TvSeriesDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<SaveWatchlistTVSeries>(), true);
      });

      test('TvSeriesDetailBloc should have RemoveWatchlistTVSeries injected', () {
        final bloc = locator<TvSeriesDetailBloc>();
        expect(bloc, isNotNull);
        expect(locator.isRegistered<RemoveWatchlistTVSeries>(), true);
      });

      test('TvSeriesRecommendationsBloc should be registered as factory', () {
        final bloc1 = locator<TvSeriesRecommendationsBloc>();
        final bloc2 = locator<TvSeriesRecommendationsBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('TvSeriesSearchBloc should be registered as factory', () {
        final bloc1 = locator<TvSeriesSearchBloc>();
        final bloc2 = locator<TvSeriesSearchBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });

      test('WatchlistTvSeriesBloc should be registered as factory', () {
        final bloc1 = locator<WatchlistTvSeriesBloc>();
        final bloc2 = locator<WatchlistTvSeriesBloc>();
        expect(bloc1, isNot(same(bloc2)));
      });
    });

    group('Use Case Registration', () {
      test('GetNowPlayingMovies should be registered as lazy singleton', () {
        final usecase1 = locator<GetNowPlayingMovies>();
        final usecase2 = locator<GetNowPlayingMovies>();
        expect(usecase1, same(usecase2));
      });

      test('GetPopularMovies should be registered as lazy singleton', () {
        final usecase1 = locator<GetPopularMovies>();
        final usecase2 = locator<GetPopularMovies>();
        expect(usecase1, same(usecase2));
      });

      test('GetTopRatedMovies should be registered as lazy singleton', () {
        final usecase1 = locator<GetTopRatedMovies>();
        final usecase2 = locator<GetTopRatedMovies>();
        expect(usecase1, same(usecase2));
      });

      test('GetMovieDetail should be registered as lazy singleton', () {
        final usecase1 = locator<GetMovieDetail>();
        final usecase2 = locator<GetMovieDetail>();
        expect(usecase1, same(usecase2));
      });

      test('GetMovieRecommendations should be registered as lazy singleton', () {
        final usecase1 = locator<GetMovieRecommendations>();
        final usecase2 = locator<GetMovieRecommendations>();
        expect(usecase1, same(usecase2));
      });

      test('SearchMovies should be registered as lazy singleton', () {
        final usecase1 = locator<SearchMovies>();
        final usecase2 = locator<SearchMovies>();
        expect(usecase1, same(usecase2));
      });

      test('GetWatchListStatus should be registered as lazy singleton', () {
        final usecase1 = locator<GetWatchListStatus>();
        final usecase2 = locator<GetWatchListStatus>();
        expect(usecase1, same(usecase2));
      });

      test('SaveWatchlist should be registered as lazy singleton', () {
        final usecase1 = locator<SaveWatchlist>();
        final usecase2 = locator<SaveWatchlist>();
        expect(usecase1, same(usecase2));
      });

      test('RemoveWatchlist should be registered as lazy singleton', () {
        final usecase1 = locator<RemoveWatchlist>();
        final usecase2 = locator<RemoveWatchlist>();
        expect(usecase1, same(usecase2));
      });

      test('GetWatchlistMovies should be registered as lazy singleton', () {
        final usecase1 = locator<GetWatchlistMovies>();
        final usecase2 = locator<GetWatchlistMovies>();
        expect(usecase1, same(usecase2));
      });

      test('GetOnTheAirTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<GetOnTheAirTVSeries>();
        final usecase2 = locator<GetOnTheAirTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('GetPopularTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<GetPopularTVSeries>();
        final usecase2 = locator<GetPopularTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('GetTopRatedTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<GetTopRatedTVSeries>();
        final usecase2 = locator<GetTopRatedTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('GetTVSeriesDetail should be registered as lazy singleton', () {
        final usecase1 = locator<GetTVSeriesDetail>();
        final usecase2 = locator<GetTVSeriesDetail>();
        expect(usecase1, same(usecase2));
      });

      test('GetTVSeriesRecommendations should be registered as lazy singleton', () {
        final usecase1 = locator<GetTVSeriesRecommendations>();
        final usecase2 = locator<GetTVSeriesRecommendations>();
        expect(usecase1, same(usecase2));
      });

      test('SearchTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<SearchTVSeries>();
        final usecase2 = locator<SearchTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('GetWatchListTVSeriesStatus should be registered as lazy singleton', () {
        final usecase1 = locator<GetWatchListTVSeriesStatus>();
        final usecase2 = locator<GetWatchListTVSeriesStatus>();
        expect(usecase1, same(usecase2));
      });

      test('SaveWatchlistTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<SaveWatchlistTVSeries>();
        final usecase2 = locator<SaveWatchlistTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('RemoveWatchlistTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<RemoveWatchlistTVSeries>();
        final usecase2 = locator<RemoveWatchlistTVSeries>();
        expect(usecase1, same(usecase2));
      });

      test('GetWatchlistTVSeries should be registered as lazy singleton', () {
        final usecase1 = locator<GetWatchlistTVSeries>();
        final usecase2 = locator<GetWatchlistTVSeries>();
        expect(usecase1, same(usecase2));
      });
    });

    group('Repository Registration', () {
      test('MovieRepository should be registered', () {
        final repo = locator<MovieRepository>();
        expect(repo, isNotNull);
      });

      test('TVSeriesRepository should be registered', () {
        final repo = locator<TVSeriesRepository>();
        expect(repo, isNotNull);
      });
    });

    group('Data Source Registration', () {
      test('MovieLocalDataSource should be registered', () {
        final dataSource = locator<MovieLocalDataSource>();
        expect(dataSource, isNotNull);
      });

      test('TVSeriesLocalDataSource should be registered', () {
        final dataSource = locator<TVSeriesLocalDataSource>();
        expect(dataSource, isNotNull);
      });
    });

    group('Remote Data Source Registration', () {
      test('MovieRemoteDataSource should be registered', () {
        final dataSource = locator<MovieRemoteDataSource>();
        expect(dataSource, isNotNull);
      });

      test('TVSeriesRemoteDataSource should be registered', () {
        final dataSource = locator<TVSeriesRemoteDataSource>();
        expect(dataSource, isNotNull);
      });
    });

    group('Helper Registration', () {
      test('DatabaseHelper should be registered as lazy singleton', () {
        final helper1 = locator<DatabaseHelper>();
        final helper2 = locator<DatabaseHelper>();
        expect(helper1, same(helper2));
      });
    });

    group('External Dependencies', () {
      test('http.Client should be registered', () {
        expect(locator.isRegistered<http.Client>(), true);
        final client = locator<http.Client>();
        expect(client, isNotNull);
      });
    });
  });
}