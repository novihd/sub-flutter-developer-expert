import 'package:core/features/movies/domain/usecases/get_movie_detail.dart';
import 'package:core/features/movies/domain/usecases/get_movie_recommendations.dart';
import 'package:core/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:core/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:core/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_movies.dart';
import 'package:core/features/movies/domain/usecases/get_watchlist_status.dart';
import 'package:core/features/movies/domain/usecases/remove_watchlist.dart';
import 'package:core/features/movies/domain/usecases/save_watchlist.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieRecommendations,
  GetMovieDetail,
  GetWatchlistMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
