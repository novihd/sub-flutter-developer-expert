import 'dart:async';
import 'package:core/features/movies/data/models/movie_table.dart';
import 'package:core/features/series/data/models/series_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlistMovie = 'watchlist_movie';
  static const String _tblWatchlistSeries = 'watchlist_series';
  static const String _tblCacheMovie = 'cache_movie';
  static const String _tblCacheSeries = 'cache_series';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';
    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlistMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblWatchlistSeries (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblCacheMovie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE  $_tblCacheSeries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  Future<void> insertCacheTransaction(
      List<MovieTable> movies, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        txn.insert(_tblCacheMovie, movieJson,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> insertCacheTransactionSeries(
      List<SeriesTable> series, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in series) {
        final seriesJson = tv.toJson();
        seriesJson['category'] = category;
        txn.insert(_tblCacheSeries, seriesJson,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheMovie,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<List<Map<String, dynamic>>> getCacheSeries(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheSeries,
      where: 'category = ?',
      whereArgs: [category],
    );

    return results;
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheMovie,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> clearCacheSeries(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheSeries,
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<int> insertWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlistMovie, movie.toJson());
  }

  Future<int> insertWatchlistSeries(SeriesTable series) async {
    final db = await database;
    return await db!.insert(_tblWatchlistSeries, series.toJson());
  }

  Future<int> removeWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> removeWatchlistSeries(SeriesTable series) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistSeries,
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistSeries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblWatchlistMovie);

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistSeries() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblWatchlistSeries);

    return results;
  }
}
