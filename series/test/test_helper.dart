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
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  GetNowPlayingSeries,
  GetPopularSeries,
  GetTopRatedSeries,
  GetSeriesRecommendations,
  GetSeriesDetail,
  GetWatchlistSeries,
  GetWatchlistSeriesStatus,
  SaveWatchlistSeries,
  RemoveWatchlistSeries,
  GetSeriesSeason
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
