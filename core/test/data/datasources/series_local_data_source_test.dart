// ignore_for_file: prefer_const_declarations

import 'package:core/core.dart';
import 'package:core/features/series/data/datasources/series_local_data_source.dart';
import 'package:core/features/series/data/models/series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = SeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  final testSeriesCache = const SeriesTable(
      id: 1402,
      overview:
          "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
      posterPath: '/xf9wuDcqlUPWABZNeDKPbZUjWx0.jpg',
      name: 'The Walking Dead');

  final testSeriesCacheMap = {
    'id': 1402,
    'overview':
        "Sheriff's deputy Rick Grimes awakens from a coma to find a post-apocalyptic world dominated by flesh-eating zombies. He sets out to find his family and encounters many other survivors along the way.",
    'posterPath': '/xf9wuDcqlUPWABZNeDKPbZUjWx0.jpg',
    'name': 'The Walking Dead'
  };

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlistSeries(testSeriesTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistSeries(testSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlistSeries(testSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistSeries(testSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlistSeries(testSeriesTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistSeries(testSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlistSeries(testSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Series Detail By Id', () {
    final tId = 1;

    test('should return Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getSeriesById(tId))
          .thenAnswer((_) async => testSeriesMap);
      // act
      final result = await dataSource.getSeriesById(tId);
      // assert
      expect(result, testSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist series', () {
    test('should return list of Series Table from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistSeries())
          .thenAnswer((_) async => [testSeriesMap]);
      // act
      final result = await dataSource.getWatchlistSeries();
      // assert
      expect(result, [testSeriesTable]);
    });
  });

  group('Cache Now Playing Series', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCacheSeries('now playing'))
          .thenAnswer((_) async => 1);

      await dataSource.cacheNowPlayingSeries([testSeriesCache]);
      verify(mockDatabaseHelper.clearCacheSeries('now playing'));

      verify(mockDatabaseHelper
          .insertCacheTransactionSeries([testSeriesCache], 'now playing'));
    });

    test('should return list of series from db when data exist', () async {
      when(mockDatabaseHelper.getCacheSeries('now playing'))
          .thenAnswer((realInvocation) async => [testSeriesCacheMap]);
      final result = await dataSource.getCachedNowPlayingSeries();
      expect(result, [testSeriesCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheSeries('now playing'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedNowPlayingSeries();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('Cache Popular Series', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCacheSeries('popular'))
          .thenAnswer((_) async => 1);

      await dataSource.cachePopularSeries([testSeriesCache]);
      verify(mockDatabaseHelper.clearCacheSeries('popular'));

      verify(mockDatabaseHelper
          .insertCacheTransactionSeries([testSeriesCache], 'popular'));
    });

    test('should return list of series from db when data exist', () async {
      when(mockDatabaseHelper.getCacheSeries('popular'))
          .thenAnswer((realInvocation) async => [testSeriesCacheMap]);
      final result = await dataSource.getCachedPopularSeries();
      expect(result, [testSeriesCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheSeries('popular'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedPopularSeries();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('Cache Top Rated Series', () {
    test('should call database helper to save data', () async {
      when(mockDatabaseHelper.clearCacheSeries('top'))
          .thenAnswer((_) async => 1);

      await dataSource.cacheTopSeries([testSeriesCache]);
      verify(mockDatabaseHelper.clearCacheSeries('top'));

      verify(mockDatabaseHelper
          .insertCacheTransactionSeries([testSeriesCache], 'top'));
    });

    test('should return list of series from db when data exist', () async {
      when(mockDatabaseHelper.getCacheSeries('top'))
          .thenAnswer((realInvocation) async => [testSeriesCacheMap]);
      final result = await dataSource.getCachedTopSeries();
      expect(result, [testSeriesCache]);
    });

    test('should throw CacheException when cache data is not exist', () async {
      when(mockDatabaseHelper.getCacheSeries('top'))
          .thenAnswer((realInvocation) async => []);

      final call = dataSource.getCachedTopSeries();
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });
}
