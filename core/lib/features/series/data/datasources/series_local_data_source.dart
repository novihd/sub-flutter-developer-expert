import 'package:core/core.dart';

import '../models/series_table.dart';
import 'db/database_helper.dart';

abstract class SeriesLocalDataSource {
  Future<void> cacheNowPlayingSeries(List<SeriesTable> series);
  Future<List<SeriesTable>> getCachedNowPlayingSeries();
  Future<void> cachePopularSeries(List<SeriesTable> series);
  Future<List<SeriesTable>> getCachedPopularSeries();
  Future<void> cacheTopSeries(List<SeriesTable> series);
  Future<List<SeriesTable>> getCachedTopSeries();
  Future<String> insertWatchlistSeries(SeriesTable series);
  Future<String> removeWatchlistSeries(SeriesTable series);
  Future<SeriesTable?> getSeriesById(int id);
  Future<List<SeriesTable>> getWatchlistSeries();
}

class SeriesLocalDataSourceImpl implements SeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  SeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistSeries(SeriesTable series) async {
    try {
      await databaseHelper.insertWatchlistSeries(series);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistSeries(SeriesTable series) async {
    try {
      await databaseHelper.removeWatchlistSeries(series);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<SeriesTable?> getSeriesById(int id) async {
    final result = await databaseHelper.getSeriesById(id);
    if (result != null) {
      return SeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<SeriesTable>> getWatchlistSeries() async {
    final result = await databaseHelper.getWatchlistSeries();
    return result.map((data) => SeriesTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheNowPlayingSeries(List<SeriesTable> series) async {
    await databaseHelper.clearCacheSeries('now playing');
    await databaseHelper.insertCacheTransactionSeries(series, 'now playing');
  }

  @override
  Future<List<SeriesTable>> getCachedNowPlayingSeries() async {
    final result = await databaseHelper.getCacheSeries('now playing');
    if (result.isNotEmpty) {
      return result.map((data) => SeriesTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data");
    }
  }

  @override
  Future<void> cachePopularSeries(List<SeriesTable> series) async {
    await databaseHelper.clearCacheSeries('popular');
    await databaseHelper.insertCacheTransactionSeries(series, 'popular');
  }

  @override
  Future<List<SeriesTable>> getCachedPopularSeries() async {
    final result = await databaseHelper.getCacheSeries('popular');
    if (result.isNotEmpty) {
      return result.map((e) => SeriesTable.fromMap(e)).toList();
    } else {
      throw CacheException("Can't get the data");
    }
  }

  @override
  Future<void> cacheTopSeries(List<SeriesTable> series) async {
    await databaseHelper.clearCacheSeries('top');
    await databaseHelper.insertCacheTransactionSeries(series, 'top');
  }

  @override
  Future<List<SeriesTable>> getCachedTopSeries() async {
    final result = await databaseHelper.getCacheSeries('top');
    if (result.isNotEmpty) {
      return result.map((e) => SeriesTable.fromMap(e)).toList();
    } else {
      throw CacheException("Can't get the data");
    }
  }
}
