import 'package:core/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:core/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:core/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:core/features/movies/domain/repositories/movie_repository.dart';
import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:core/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:core/features/series/data/datasources/db/database_helper.dart';
import 'package:core/features/series/data/datasources/series_local_data_source.dart';
import 'package:core/features/series/data/datasources/series_remote_data_source.dart';
import 'package:core/features/series/data/repositories/series_repository_impl.dart';
import 'package:core/features/series/domain/repositories/series_repository.dart';
import 'package:core/features/series/domain/usecases/get_now_playing_series.dart';
import 'package:core/features/series/domain/usecases/get_popular_series.dart';
import 'package:core/features/series/domain/usecases/get_series_detail.dart';
import 'package:core/features/series/domain/usecases/get_series_recommendations.dart';
import 'package:core/features/series/domain/usecases/get_series_season.dart';
import 'package:core/features/series/domain/usecases/get_top_rated_series.dart';
import 'package:core/features/series/domain/usecases/get_watchlist_series.dart';
import 'package:core/features/series/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/features/series/domain/usecases/remove_watchlist_series.dart';
import 'package:core/features/series/domain/usecases/save_watchlist_series.dart';
import 'package:core/utils/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movie/presentation/bloc/detail/detail_movie_bloc.dart';
import 'package:movie/presentation/bloc/now_playing/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/recommendation/recommendation_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movie_bloc.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_series_bloc.dart';
import 'package:series/presentation/bloc/detail/detail_series_bloc.dart';
import 'package:series/presentation/bloc/now_playing/now_playing_series_bloc.dart';
import 'package:series/presentation/bloc/popular/popular_series_bloc.dart';
import 'package:series/presentation/bloc/recommendation/recommendation_series_bloc.dart';
import 'package:series/presentation/bloc/season/season_series_bloc.dart';
import 'package:series/presentation/bloc/top_rated/top_rated_series_bloc.dart';
import 'package:series/presentation/bloc/watchlist/watchlist_series_bloc.dart';

final locator = GetIt.instance;

void init() {
  //search bloc
  locator.registerFactory(() => SearchBloc(locator()));
  locator.registerFactory(() => SearchSeriesBloc(locator()));

  //movie bloc
  locator.registerFactory(() => NowPlayingMovieBloc(locator()));
  locator.registerFactory(() => DetailMovieBloc(locator()));
  locator.registerFactory(() => PopularMovieBloc(locator()));
  locator.registerFactory(() => RecommendationMovieBloc(locator()));
  locator.registerFactory(() => TopRatedMovieBloc(locator()));
  locator.registerFactory(
      () => WatchlistMovieBloc(locator(), locator(), locator(), locator()));

  //series bloc
  locator.registerFactory(() => NowPlayingSeriesBloc(locator()));
  locator.registerFactory(() => DetailSeriesBloc(locator()));
  locator.registerFactory(() => PopularSeriesBloc(locator()));
  locator.registerFactory(() => RecommendationSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedSeriesBloc(locator()));
  locator.registerFactory(
      () => WatchlistSeriesBloc(locator(), locator(), locator(), locator()));
  locator.registerFactory(() => SeasonSeriesBloc(locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesSeason(locator()));
  locator.registerLazySingleton(() => SaveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeriesStatus(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator()),
  );

  locator.registerLazySingleton<SeriesRepository>(() => SeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<SeriesRemoteDataSource>(
      () => SeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<SeriesLocalDataSource>(
      () => SeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());

  //network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  locator.registerLazySingleton(() => DataConnectionChecker());
}
